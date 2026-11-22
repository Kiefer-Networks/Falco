// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_cloud.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecretStore and ScopeRepository (SET-017, SET-018)', () {
    late SecretStore secrets;
    late ScopeRepository repo;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      secrets = SecretStore();
      repo = ScopeRepository(secrets);
    });

    const account = Account(
      id: 'a1',
      name: 'Work',
      hasRobot: true,
      projects: [
        Project(id: 'p1', name: 'Prod'),
        Project(id: 'p2', name: 'Staging'),
      ],
    );

    test('stores accounts and resolves scopes', () async {
      await repo.save(account);
      expect(await repo.accounts(), [account]);
      final all = await repo.accounts();
      expect(projectsIn(all, const ProjectScope('a1', 'p2')), [
        account.projects[1],
      ]);
      expect(projectsIn(all, const AllProjectsScope('a1')), account.projects);
      expect(projectsIn(all, const RobotScope('a1')), isEmpty);
      expect(projectsIn(all, const AllProjectsScope('nope')), isEmpty);
    });

    test('save replaces by id', () async {
      await repo.save(account);
      await repo.save(account.copyWith(name: 'Home'));
      expect((await repo.accounts()).single.name, 'Home');
    });

    test('typed secrets round trip', () async {
      await secrets.setCloudToken('p1', 'cloud-token');
      await secrets.setRobot(
        'a1',
        const RobotCredentials(user: '#ws+x', password: 'pw'),
      );
      await secrets.setS3(
        'p1',
        const S3Credentials(
          accessKey: 'ak',
          secretKey: 'sk',
          endpoint: 'https://fsn1.your-objectstorage.com',
          region: 'fsn1',
        ),
      );
      expect(await secrets.cloudToken('p1'), 'cloud-token');
      expect((await secrets.robot('a1'))!.password, 'pw');
      expect((await secrets.s3('p1'))!.region, 'fsn1');
    });

    test('deleting a project or account deletes its secrets', () async {
      await repo.save(account);
      await secrets.setCloudToken('p1', 't1');
      await secrets.setCloudToken('p2', 't2');
      await secrets.setRobot(
        'a1',
        const RobotCredentials(user: 'u', password: 'p'),
      );

      await repo.deleteProject('a1', 'p1');
      expect(await secrets.cloudToken('p1'), isNull);
      expect((await repo.accounts()).single.projects.single.id, 'p2');

      await repo.deleteAccount('a1');
      expect(await repo.accounts(), isEmpty);
      expect(await secrets.cloudToken('p2'), isNull);
      expect(await secrets.robot('a1'), isNull);
    });

    test('credentials never print their values', () {
      const robot = RobotCredentials(user: 'u', password: 'secret');
      const s3 = S3Credentials(
        accessKey: 'ak',
        secretKey: 'secret',
        endpoint: 'e',
        region: 'r',
      );
      expect('$robot $s3', isNot(contains('secret')));
    });

    test('account description round trips, S3 keys delete alone', () async {
      const a = Account(id: 'a1', name: 'Acme', description: 'Main');
      await repo.save(a);
      expect((await repo.accounts()).single, a);
      await secrets.setCloudToken('p1', 't');
      await secrets.setS3(
        'p1',
        const S3Credentials(
          accessKey: 'k',
          secretKey: 's',
          endpoint: 'https://fsn1.your-objectstorage.com',
          region: 'fsn1',
        ),
      );
      await secrets.deleteS3('p1');
      expect(await secrets.s3('p1'), isNull);
      expect(await secrets.cloudToken('p1'), 't');
    });

    test('BUG-010 old formats (a single CLOUD_TOKEN) are not read', () async {
      FlutterSecureStorage.setMockInitialValues({'CLOUD_TOKEN': 'old'});
      expect(await repo.accounts(), isEmpty);
      expect(await secrets.cloudToken('CLOUD_TOKEN'), isNull);
    });

    test('ids are random and 32 hex characters', () {
      final a = newId();
      expect(a, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect(newId(), isNot(a));
    });
  });

  group('SET-015 hardware bound secrets', () {
    late _Bound bound;
    late SecretStore secrets;
    late bool deviceLock;
    late AndroidDevice device;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      bound = _Bound();
      deviceLock = true;
      device = (sdk: 36, secure: true);
      secrets = SecretStore(
        null,
        bound,
        () async => deviceLock,
        () async => device,
      );
    });

    String? namespace() => bound.android?.toMap()['storageNamespace'];

    test('a read started while closed does not fail the unlock (L3)', () async {
      await secrets.setCloudToken('p1', 't1');
      secrets.close();
      final background = expectLater(
        secrets.cloudToken('p1'),
        throwsA(isA<Locked>()),
      );
      expect(await secrets.open(), isTrue);
      await background;
      expect(await secrets.cloudToken('p1'), 't1');
    });

    test('Android 7 to 10 keeps the vault unbound (L4)', () async {
      device = (sdk: 29, secure: true);
      bound.fail = true;
      await secrets.setCloudToken('p1', 't1');
      expect(await secrets.bound, isFalse);
      expect(bound.data, isEmpty);
      secrets.close();
      expect(await secrets.cloudToken('p1'), 't1');
    });

    test('an invalidated key moves the vault to a new key, also on a '
        'write (L6)', () async {
      await secrets.setCloudToken('p1', 't1');
      expect(namespace(), 'vault');
      bound.writeError = PlatformException(
        code: 'Exception encountered',
        details: 'KeyPermanentlyInvalidatedException: Key invalidated',
      );
      await secrets.setCloudToken('p2', 't2');
      expect(namespace(), 'vault.1');
      secrets.close();
      await secrets.open();
      expect(await secrets.cloudToken('p2'), 't2');
    });

    test('a vault key made without a screen lock is replaced by an asking '
        'one once there is a lock (L7)', () async {
      device = (sdk: 36, secure: false);
      await secrets.setCloudToken('p1', 't1');
      device = (sdk: 36, secure: true);
      final writes = bound.writes;
      expect(await secrets.verify(), isTrue);
      expect(bound.writes, writes + 1, reason: 'the new key asks');
      expect(namespace(), 'vault.1');
      secrets.close();
      await secrets.open();
      expect(await secrets.cloudToken('p1'), 't1');
      // A cancelled replacement fails the check and keeps the old vault.
      bound.fail = true;
      device = (sdk: 36, secure: false);
      final other = SecretStore(
        null,
        bound,
        () async => deviceLock,
        () async => device,
      );
      await other.cloudToken('p1');
      device = (sdk: 36, secure: true);
      await expectLater(other.verify(), throwsA(isA<Locked>()));
      expect(await other.cloudToken('p1'), 't1');
      bound.fail = false;
      expect(await other.verify(), isTrue);
    });

    test('a re-key switches to the new key only after its write, in line '
        'with other writes, and a cancelled one stays closed '
        '(R16, R27, R28)', () async {
      const plain = FlutterSecureStorage();
      device = (sdk: 36, secure: false);
      await secrets.setCloudToken('p1', 't1');
      device = (sdk: 36, secure: true);
      // Cancelled while locked: the vault stays closed.
      secrets.close();
      bound.fail = true;
      await expectLater(secrets.verify(), throwsA(isA<Locked>()));
      await expectLater(secrets.cloudToken('p1'), throwsA(isA<Locked>()));
      // The process may end during the prompt: nothing switched yet.
      bound
        ..fail = false
        ..writeGate = Completer();
      final verified = secrets.verify();
      await pumpEventQueue();
      expect(await plain.read(key: 'vault.ns'), isNull);
      expect(await plain.read(key: 'vault.weak'), '1');
      final concurrent = secrets.setCloudToken('p2', 't2');
      bound.writeGate!.complete();
      bound.writeGate = null;
      expect(await verified, isTrue);
      await concurrent;
      expect(await plain.read(key: 'vault.ns'), '1');
      expect(await plain.read(key: 'vault.weak'), isNull);
      expect(bound.spaces['vault'], isEmpty);
      final fresh = SecretStore(
        null,
        bound,
        () async => deviceLock,
        () async => device,
      );
      expect(await fresh.cloudToken('p1'), 't1');
      expect(await fresh.cloudToken('p2'), 't2');
    });

    test('a weak vault moves to an asking key with the next write or the '
        'first read, also with the lock off (R5 Q23)', () async {
      const plain = FlutterSecureStorage();
      device = (sdk: 36, secure: false);
      await secrets.setCloudToken('p1', 't1');
      device = (sdk: 36, secure: true);
      await secrets.setCloudToken('p2', 't2');
      expect(await plain.read(key: 'vault.ns'), '1');
      expect(await plain.read(key: 'vault.weak'), isNull);
      // A new process that only reads.
      device = (sdk: 36, secure: false);
      await plain.write(key: 'vault.weak', value: '1');
      final fresh = SecretStore(
        null,
        bound,
        () async => deviceLock,
        () async => device,
      );
      device = (sdk: 36, secure: true);
      expect(await fresh.cloudToken('p1'), 't1');
      await pumpEventQueue();
      expect(await plain.read(key: 'vault.ns'), '2');
      expect(await plain.read(key: 'vault.weak'), isNull);
    });

    test('a check of a weak vault publishes nothing before the re-key '
        'write (R5 Q24)', () async {
      device = (sdk: 36, secure: false);
      await secrets.setCloudToken('p1', 't1');
      device = (sdk: 36, secure: true);
      secrets.close();
      bound.writeGate = Completer();
      final verified = secrets.verify();
      await pumpEventQueue();
      await expectLater(secrets.cloudToken('p1'), throwsA(isA<Locked>()));
      bound.writeGate!.complete();
      bound.writeGate = null;
      expect(await verified, isTrue);
      expect(await secrets.cloudToken('p1'), 't1');
    });

    test('readers of an open vault do not wait for a check (R5 Q25)', () async {
      await secrets.setCloudToken('p1', 't1');
      bound.gate = Completer();
      final verified = secrets.verify();
      await pumpEventQueue();
      expect(await secrets.cloudToken('p1'), 't1');
      bound.readError = PlatformException(code: 'cancel');
      bound.gate!.complete();
      bound.gate = null;
      await expectLater(verified, throwsA(isA<Locked>()));
      bound.readError = null;
      expect(await secrets.cloudToken('p1'), 't1');
    });

    test('an invalidated key during a re-key moves past its target and '
        'stores no generation before a write succeeded (R5 Q26)', () async {
      const plain = FlutterSecureStorage();
      final invalidated = PlatformException(
        code: 'Exception encountered',
        details: 'KeyPermanentlyInvalidatedException: Key invalidated',
      );
      device = (sdk: 36, secure: false);
      await secrets.setCloudToken('p1', 't1');
      device = (sdk: 36, secure: true);
      // Invalidated, then the retry is cancelled: nothing stored.
      bound
        ..writeError = invalidated
        ..fail = true;
      await expectLater(secrets.verify(), throwsA(isA<Locked>()));
      expect(await plain.read(key: 'vault.ns'), isNull);
      expect(await plain.read(key: 'vault.weak'), '1');
      bound
        ..fail = false
        ..writeError = invalidated;
      expect(await secrets.verify(), isTrue);
      expect(await plain.read(key: 'vault.ns'), '2');
      final fresh = SecretStore(
        null,
        bound,
        () async => deviceLock,
        () async => device,
      );
      expect(await fresh.cloudToken('p1'), 't1');
    });

    test('a write finishing after close does not reopen the vault '
        '(R5 Q28)', () async {
      await secrets.setCloudToken('p1', 't1');
      bound.writeGate = Completer();
      final write = secrets.setCloudToken('p2', 't2');
      await pumpEventQueue();
      secrets.close();
      bound.writeGate!.complete();
      bound.writeGate = null;
      await write;
      await expectLater(secrets.cloudToken('p1'), throwsA(isA<Locked>()));
    });

    test('with the lock on the vault starts closed (L8), an unlock without '
        'a vault read still opens it (L2)', () async {
      await secrets.setCloudToken('p1', 't1');
      final c = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(await testPrefs()),
          secretStoreProvider.overrideWithValue(secrets),
          authenticatorProvider.overrideWithValue((_) async => true),
        ],
      );
      addTearDown(c.dispose);
      final reads = bound.reads;
      closeVaultAtStart(c);
      await expectLater(secrets.cloudToken('p1'), throwsA(isA<Locked>()));
      expect(bound.reads, reads, reason: 'no prompt over the cover');
      await c.read(appLockProvider.notifier).unlock('why');
      expect(await secrets.cloudToken('p1'), 't1');
    });

    test('one system check per unlock, again after close', () async {
      await secrets.setCloudToken('p1', 't1');
      await secrets.setCloudToken('p2', 't2');
      expect(await secrets.bound, isTrue);
      secrets.close();
      bound.reads = 0;
      await secrets.open();
      expect(await secrets.cloudToken('p1'), 't1');
      expect(await secrets.cloudToken('p2'), 't2');
      expect(bound.reads, 1);
      secrets.close();
      await secrets.open();
      expect(await secrets.cloudToken('p1'), 't1');
      expect(bound.reads, 2);
      // Nothing secret outside the vault, only the names of its entries.
      expect(await const FlutterSecureStorage().readAll(), {
        'vault.keys': '["cloud.p1","cloud.p2"]',
      });
      // Android asks on every vault access, else the plugin keeps the key
      // open after close (L2).
      expect(bound.android?.toMap()['requireBiometricsPerOperation'], 'true');
    });

    test('a check reads the vault even when it is open (L3)', () async {
      await secrets.setCloudToken('p1', 't1');
      final reads = bound.reads;
      expect(await secrets.verify(), isTrue);
      expect(bound.reads, reads + 1);
    });

    test('concurrent moves into the vault keep every secret (L8)', () async {
      FlutterSecureStorage.setMockInitialValues({
        'cloud.p1': 't1',
        'cloud.p2': 't2',
        'robot.a1': '{"user":"u","password":"p"}',
      });
      await Future.wait([
        secrets.cloudToken('p1'),
        secrets.cloudToken('p2'),
        secrets.robot('a1'),
      ]);
      secrets.close();
      await secrets.open();
      expect(await secrets.cloudToken('p1'), 't1');
      expect(await secrets.cloudToken('p2'), 't2');
      expect((await secrets.robot('a1'))?.user, 'u');
      expect(await const FlutterSecureStorage().read(key: 'cloud.p1'), isNull);
    });

    test('a vault the system deleted names what is lost (L6)', () async {
      await secrets.setCloudToken('p1', 't1');
      await secrets.setRobot(
        'a1',
        const RobotCredentials(user: 'u', password: 'p'),
      );
      // New fingerprint: Android drops the key and the vault with it.
      bound.data.clear();
      secrets.close();
      expect(await secrets.cloudToken('p1'), isNull);
      expect(secrets.lost.value, {'cloud.p1', 'robot.a1'});
      secrets
        ..lost.value = const {}
        ..close();
      await secrets.cloudToken('p1');
      expect(secrets.lost.value, isEmpty, reason: 'reported once');
    });

    test('a cancelled prompt on Android keeps the vault bound and fails as '
        'Locked', () async {
      bound.fail = true;
      await expectLater(
        secrets.setCloudToken('p1', 't1'),
        throwsA(isA<Locked>()),
      );
      expect(await const FlutterSecureStorage().readAll(), isEmpty);
    });

    test('a cancelled read fails as Locked (K1)', () async {
      await secrets.setCloudToken('p1', 't1');
      bound.readError = PlatformException(code: 'cancel');
      await expectLater(secrets.verify(), throwsA(isA<Locked>()));
      bound.readError = null;
      expect(await secrets.cloudToken('p1'), 't1');
    });

    test('deleting an account writes the vault once, a cancelled write '
        'changes nothing (K1)', () async {
      final repo = ScopeRepository(secrets);
      await repo.save(
        const Account(
          id: 'a1',
          name: 'Work',
          hasRobot: true,
          projects: [
            Project(id: 'p1', name: 'Prod'),
            Project(id: 'p2', name: 'Staging'),
          ],
        ),
      );
      await secrets.apply(
        (c) => c
          ..cloudToken('p1', 't1')
          ..cloudToken('p2', 't2')
          ..robot('a1', const RobotCredentials(user: 'u', password: 'p')),
      );
      expect(bound.writes, 1);
      bound.fail = true;
      await expectLater(repo.deleteAccount('a1'), throwsA(isA<Locked>()));
      expect(await repo.accounts(), hasLength(1));
      expect(await secrets.cloudToken('p2'), 't2');
      bound.fail = false;
      await repo.deleteAccount('a1');
      expect(bound.writes, 2);
      expect(await repo.accounts(), isEmpty);
      expect(await secrets.cloudToken('p1'), isNull);
      expect(await secrets.robot('a1'), isNull);
    });

    test('an iOS write failure with a screen lock is a cancel, not a move '
        'out of the vault (W1)', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await secrets.setCloudToken('p1', 't1');
      bound.fail = true;
      await expectLater(
        secrets.setCloudToken('p1', 't2'),
        throwsA(isA<Locked>()),
      );
      expect(await secrets.bound, isTrue);
      expect(await secrets.cloudToken('p1'), 't1');
    });

    test('a close during a running read discards it (W2)', () async {
      await secrets.setCloudToken('p1', 't1');
      secrets.close();
      bound.gate = Completer();
      final opening = secrets.open();
      await pumpEventQueue();
      secrets.close();
      bound.gate!.complete();
      await opening;
      bound.gate = null;
      final reads = bound.reads;
      await expectLater(secrets.cloudToken('p1'), throwsA(isA<Locked>()));
      expect(bound.reads, reads, reason: 'closed: no prompt from background');
    });

    test('an invalidated key resets the vault and names what is lost '
        '(K8)', () async {
      await secrets.setCloudToken('p1', 't1');
      bound.readError = PlatformException(
        code: 'Exception encountered',
        details: 'KeyPermanentlyInvalidatedException: Key invalidated',
      );
      expect(await secrets.verify(), isTrue);
      bound.readError = null;
      // Not bound any more: the app lock asks the device check instead.
      expect(await secrets.bound, isFalse);
      expect(secrets.lost.value, {'cloud.p1'});
      expect(await secrets.cloudToken('p1'), isNull);
    });

    test('a device without screen lock keeps a working vault', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await secrets.setCloudToken('p0', 't0');
      deviceLock = false;
      bound.fail = true;
      await secrets.setCloudToken('p1', 't1');
      expect(await secrets.bound, isFalse);
      // The stale bound vault is gone (W1).
      expect(bound.data, isEmpty);
      secrets.close();
      expect(await secrets.cloudToken('p1'), 't1');
      bound.fail = false;
      await secrets.setCloudToken('p2', 't2');
      expect(await secrets.bound, isTrue);
    });

    test('secrets stored one by one move into the vault', () async {
      FlutterSecureStorage.setMockInitialValues({'cloud.p1': 't1'});
      expect(await secrets.cloudToken('p1'), 't1');
      expect(bound.data.keys, ['vault']);
      expect((await const FlutterSecureStorage().readAll()).keys, [
        'vault.keys',
      ]);
    });

    test('the lock forgets the open vault', () async {
      final c = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(await testPrefs()),
          secretStoreProvider.overrideWithValue(secrets),
          authenticatorProvider.overrideWithValue((_) => secrets.verify()),
        ],
      );
      addTearDown(c.dispose);
      await ScopeRepository(secrets)
          .save(const Account(id: 'a1', name: 'Acme'));
      await secrets.setCloudToken('p1', 't1');
      final lock = c.read(appLockProvider.notifier);
      var now = DateTime(2026);
      lock.now = () => now;
      await lock.unlock('why');
      lock.paused();
      now = now.add(const Duration(minutes: 5));
      expect(lock.resumed(), isTrue);
      final before = bound.reads;
      // A background request while locked asks nothing (K3).
      await expectLater(secrets.cloudToken('p1'), throwsA(isA<Locked>()));
      expect(bound.reads, before);
      await lock.unlock('why');
      expect(await secrets.cloudToken('p1'), 't1');
      expect(bound.reads, before + 1);
    });
  });

  group('AppLock', () {
    setUp(() => seedSecrets(const [Account(id: 'a1', name: 'Acme')]));

    Future<ProviderContainer> container(
      List<bool?> answers, {
      Map<String, Object> prefs = const {},
    }) async {
      final c = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(await testPrefs(prefs)),
          authenticatorProvider.overrideWithValue(
            (_) async => answers.removeAt(0),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test(
      'starts locked and unlocks on success only (SET-007, SET-011)',
      () async {
        final c = await container([false, true]);
        expect(c.read(appLockProvider), AppLockState.locked);
        await c.read(appLockProvider.notifier).unlock('why');
        expect(c.read(appLockProvider), AppLockState.locked);
        await c.read(appLockProvider.notifier).unlock('why');
        expect(c.read(appLockProvider), AppLockState.unlocked);
      },
    );

    test('SET-023 asks nothing before the first account', () async {
      seedSecrets(const []);
      final answers = <bool?>[false];
      final c = await container(answers);
      expect(c.read(appLockProvider), AppLockState.locked);
      await c.read(appLockProvider.notifier).unlock('why');
      expect(c.read(appLockProvider), AppLockState.unlocked);
      expect(answers, [false], reason: 'no prompt without an account');
    });

    test('starts unlocked when the lock is off (SET-007)', () async {
      final c = await container([], prefs: {'lock': false});
      expect(c.read(appLockProvider), AppLockState.unlocked);
    });

    test('a device without screen lock gets its own state and may turn '
        'the lock off (SET-012, SET-013, BUG-023)', () async {
      final c = await container([null]);
      await c.read(appLockProvider.notifier).unlock('why');
      expect(c.read(appLockProvider), AppLockState.unavailable);
      await c.read(appLockProvider.notifier).disable();
      expect(c.read(appLockProvider), AppLockState.unlocked);
      expect(c.read(appSettingsProvider).lock, isFalse);
    });

    test('an unreadable account list still asks (L10)', () async {
      FlutterSecureStorage.setMockInitialValues({'accounts': 'not json'});
      final answers = <bool?>[true];
      final c = await container(answers);
      await c.read(appLockProvider.notifier).unlock('why');
      expect(answers, isEmpty);
      expect(c.read(appLockProvider), AppLockState.unlocked);
    });

    test('the device time set back locks, the own prompt is no background '
        '(L4, L5)', () async {
      late AppLock lock;
      var uptime = Duration.zero;
      final c = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(
            await testPrefs({'lockTimeout': 300}),
          ),
          authenticatorProvider.overrideWithValue((_) async {
            // The system prompt sends the app to background.
            lock.paused();
            uptime += const Duration(minutes: 10);
            return true;
          }),
        ],
      );
      addTearDown(c.dispose);
      lock = c.read(appLockProvider.notifier);
      final now = DateTime(2026);
      lock
        ..now = (() => now)
        ..uptime = (() => uptime);
      await lock.unlock('why');
      expect(lock.resumed(), isFalse);
      expect(c.read(appLockProvider), AppLockState.unlocked);

      // Ten minutes away, the clock set back by ten minutes.
      lock.paused();
      uptime += const Duration(minutes: 10);
      expect(lock.resumed(), isTrue);
      expect(c.read(appLockProvider), AppLockState.locked);
    });

    test('SET-010 leaving during a check that fails still locks after the '
        'auto lock time (K2)', () async {
      late AppLock lock;
      var now = DateTime(2026);
      var first = true;
      final c = ProviderContainer(
        overrides: [
          preferencesProvider.overrideWithValue(
            await testPrefs({'lockTimeout': 300}),
          ),
          authenticatorProvider.overrideWithValue((_) async {
            if (first) {
              first = false;
              return true;
            }
            // The user leaves while the prompt is up and returns later.
            lock.paused();
            now = now.add(const Duration(minutes: 10));
            expect(lock.resumed(), isFalse, reason: 'the check decides');
            return false;
          }),
        ],
      );
      addTearDown(c.dispose);
      lock = c.read(appLockProvider.notifier)..now = (() => now);
      await lock.unlock('why');
      expect(c.read(appLockProvider), AppLockState.unlocked);
      expect(await lock.check('turn off'), isFalse);
      expect(c.read(appLockProvider), AppLockState.locked);
    });

    test('concurrent unlocks share one prompt', () async {
      final answers = <bool?>[true];
      final c = await container(answers);
      final lock = c.read(appLockProvider.notifier);
      await Future.wait([lock.unlock('a'), lock.unlock('b')]);
      expect(answers, isEmpty);
      expect(c.read(appLockProvider), AppLockState.unlocked);
    });

    test('locks again after the auto lock time (SET-010)', () async {
      final c = await container([true], prefs: {'lockTimeout': 300});
      final lock = c.read(appLockProvider.notifier);
      var now = DateTime(2026);
      lock.now = () => now;
      await lock.unlock('why');

      lock.paused();
      now = now.add(const Duration(seconds: 299));
      lock.resumed();
      expect(c.read(appLockProvider), AppLockState.unlocked);

      lock.paused();
      now = now.add(const Duration(minutes: 5));
      lock.resumed();
      expect(c.read(appLockProvider), AppLockState.locked);
    });

    test('auto lock time: choices, default 60 s, capped at 900 s '
        '(SET-008, SET-009)', () async {
      expect(lockTimeouts, [0, 30, 60, 300, 900]);
      expect(clampLockTimeout(null), 60);
      expect(clampLockTimeout(-1), 60);
      expect(clampLockTimeout(30), 30);
      expect(clampLockTimeout(3600), 900);
      final c = await container([], prefs: {'lockTimeout': -1});
      expect(c.read(appSettingsProvider).lockTimeout, 60);
    });

    test('settings are stored and read back', () async {
      final c = await container([]);
      final s = c.read(appSettingsProvider);
      expect(s.variant, FalcoVariant.dark);
      expect(s.secureScreen, isTrue);
      await c
          .read(appSettingsProvider.notifier)
          .update(
            s.copyWith(
              variant: () => null,
              accent: AccentPreset.blue,
              language: () => 'de',
              defaultAccount: () => 'a1',
              secureScreen: false,
            ),
          );
      final prefs = c.read(preferencesProvider);
      expect(prefs.getString('variant'), 'system');
      expect(prefs.getString('accent'), 'blue');
      expect(prefs.getString('language'), 'de');
      expect(prefs.getString('defaultAccount'), 'a1');
      expect(prefs.getBool('secureScreen'), isFalse);
    });
  });
}

/// The bound store of a device: counts reads, [fail]s writes like a
/// device without screen lock. On Android each Keystore namespace holds
/// its own items, like the plugin; iOS ignores the Android options.
class _Bound extends FlutterSecureStorage {
  final spaces = <String, Map<String, String>>{};
  int reads = 0;
  int writes = 0;
  bool fail = false;
  AndroidOptions? android;

  /// Thrown by the next reads, like a cancelled or invalidated key.
  PlatformException? readError;

  /// Thrown once by the next write.
  PlatformException? writeError;

  /// Holds reads until completed.
  Completer<void>? gate;

  /// Holds writes until completed.
  Completer<void>? writeGate;

  /// Items of the namespace used last.
  Map<String, String> get data => _space(android);

  Map<String, String> _space(AndroidOptions? options) => spaces.putIfAbsent(
    defaultTargetPlatform == TargetPlatform.android
        ? options?.toMap()['storageNamespace'] ?? 'vault'
        : '',
    () => {},
  );

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _space(aOptions).remove(key);

  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _space(aOptions).clear();

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    reads++;
    android = aOptions;
    await gate?.future;
    if (readError case final e?) throw e;
    return _space(aOptions)[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    android = aOptions;
    await writeGate?.future;
    if (writeError case final e?) {
      writeError = null;
      throw e;
    }
    if (fail) throw PlatformException(code: 'no_passcode');
    writes++;
    _space(aOptions)[key] = value!;
  }

  @override
  Future<bool> containsKey({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _space(aOptions).containsKey(key);
}
