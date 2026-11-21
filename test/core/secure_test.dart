// SPDX-License-Identifier: GPL-3.0-or-later
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
      expect(await repo.projectsOf(const ProjectScope('a1', 'p2')), [
        account.projects[1],
      ]);
      expect(
        await repo.projectsOf(const AllProjectsScope('a1')),
        account.projects,
      );
      expect(await repo.projectsOf(const RobotScope('a1')), isEmpty);
      expect(await repo.projectsOf(const AllProjectsScope('nope')), isEmpty);
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

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      bound = _Bound();
      secrets = SecretStore(null, bound);
    });

    test('one system check per unlock, again after close', () async {
      await secrets.setCloudToken('p1', 't1');
      await secrets.setCloudToken('p2', 't2');
      expect(await secrets.bound, isTrue);
      secrets.close();
      bound.reads = 0;
      expect(await secrets.cloudToken('p1'), 't1');
      expect(await secrets.cloudToken('p2'), 't2');
      expect(bound.reads, 1);
      secrets.close();
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

    test('a cancelled prompt on Android keeps the vault bound', () async {
      bound.fail = true;
      await expectLater(
        secrets.setCloudToken('p1', 't1'),
        throwsA(isA<PlatformException>()),
      );
      expect(await const FlutterSecureStorage().readAll(), isEmpty);
    });

    test('a device without screen lock keeps a working vault', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      bound.fail = true;
      await secrets.setCloudToken('p1', 't1');
      expect(await secrets.bound, isFalse);
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
          authenticatorProvider.overrideWithValue((_) async => true),
        ],
      );
      addTearDown(c.dispose);
      await secrets.setCloudToken('p1', 't1');
      final lock = c.read(appLockProvider.notifier);
      var now = DateTime(2026);
      lock.now = () => now;
      await lock.unlock('why');
      lock.paused();
      now = now.add(const Duration(minutes: 5));
      expect(lock.resumed(), isTrue);
      final before = bound.reads;
      await secrets.cloudToken('p1');
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
/// device without screen lock.
class _Bound extends FlutterSecureStorage {
  final data = <String, String>{};
  int reads = 0;
  bool fail = false;
  AndroidOptions? android;

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
    return data[key];
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
    if (fail) throw PlatformException(code: 'no_passcode');
    data[key] = value!;
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
  }) async => data.containsKey(key);
}
