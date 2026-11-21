// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/ui/ui.dart';
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

    test('ids are random and 32 hex characters', () {
      final a = newId();
      expect(a, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect(newId(), isNot(a));
    });
  });

  group('AppLock', () {
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

    test('starts unlocked when the lock is off (SET-007)', () async {
      final c = await container([], prefs: {'lock': false});
      expect(c.read(appLockProvider), AppLockState.unlocked);
    });

    test('a device without screen lock gets its own state and may turn '
        'the lock off (SET-012, SET-013)', () async {
      final c = await container([null]);
      await c.read(appLockProvider.notifier).unlock('why');
      expect(c.read(appLockProvider), AppLockState.unavailable);
      await c.read(appLockProvider.notifier).disable();
      expect(c.read(appLockProvider), AppLockState.unlocked);
      expect(c.read(appSettingsProvider).lock, isFalse);
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
