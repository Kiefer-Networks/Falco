// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

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

    test('ids are random and 32 hex characters', () {
      final a = newId();
      expect(a, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect(newId(), isNot(a));
    });
  });

  group('AppLock', () {
    ProviderContainer container(List<bool> answers) {
      final c = ProviderContainer(
        overrides: [
          authenticatorProvider.overrideWithValue(
            (_) async => answers.removeAt(0),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('starts locked and unlocks on success only', () async {
      final c = container([false, true]);
      expect(c.read(appLockProvider), isTrue);
      await c.read(appLockProvider.notifier).unlock('why');
      expect(c.read(appLockProvider), isTrue);
      await c.read(appLockProvider.notifier).unlock('why');
      expect(c.read(appLockProvider), isFalse);
    });

    test('concurrent unlocks share one prompt', () async {
      final answers = [true];
      final c = container(answers);
      final lock = c.read(appLockProvider.notifier);
      await Future.wait([lock.unlock('a'), lock.unlock('b')]);
      expect(answers, isEmpty);
      expect(c.read(appLockProvider), isFalse);
    });

    test('locks again after the background timeout', () async {
      final c = container([true]);
      final lock = c.read(appLockProvider.notifier);
      var now = DateTime(2026);
      lock.now = () => now;
      await lock.unlock('why');

      lock.paused();
      now = now.add(const Duration(seconds: 30));
      lock.resumed();
      expect(c.read(appLockProvider), isFalse);

      lock.paused();
      now = now.add(AppLock.backgroundTimeout);
      lock.resumed();
      expect(c.read(appLockProvider), isTrue);
    });
  });
}
