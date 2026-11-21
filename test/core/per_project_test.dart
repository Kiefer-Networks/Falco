// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_cloud.dart';
import '../fake_http.dart';

const _two = Account(
  id: 'a1',
  name: 'Acme',
  projects: [
    Project(id: 'p1', name: 'prod'),
    Project(id: 'p2', name: 'staging'),
  ],
);

const _all = AllProjectsScope('a1');

/// A container against [cloud]; the account list arrives once [gate]
/// completes, like a slow secure storage read. [broken] projects answer
/// 500.
Future<ProviderContainer> _container(
  FakeCloud cloud, {
  required List<Account> Function() accounts,
  Set<String> broken = const {},
  Future<void>? gate,
}) async {
  // Tokens for every project a test may add.
  seedSecrets(const [_two]);
  final failing = FakeCloud()..failWith = (500, null);
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      preferencesProvider.overrideWithValue(await testPrefs()),
      ...fakeApis(cloud),
      accountsProvider.overrideWith((ref) async {
        await gate;
        return accounts();
      }),
      for (final id in broken)
        cloudApiProvider(id)
            .overrideWithValue(cloudServer(fakeDio(failing.adapter))),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('QRS-022 a list read once survives its wait for the accounts', () async {
    final gate = Completer<void>();
    final c = await _container(
      FakeCloud(),
      accounts: () => [acme],
      gate: gate.future,
    );
    // Nobody listens: without keeping itself alive the provider is
    // disposed before the accounts arrive and its API watch throws.
    final images = c.read(imagesProvider(_all).future);
    await pumpEventQueue();
    gate.complete();
    expect(await images, isNotEmpty);
  });

  test(
    'QRS-022 a failing project leaves the others in "All projects"',
    () async {
      final c = await _container(
        FakeCloud(),
        accounts: () => [_two],
        broken: {'p2'},
      );
      final servers = await c.read(serversProvider(_all).future);
      expect(servers, isA<PartialList<CloudServer>>());
      expect((servers as PartialList<CloudServer>).failed, [_two.projects[1]]);
      expect({for (final s in servers) s.projectId}, {'p1'});
      await expectLater(
        c.read(serversProvider(const ProjectScope('a1', 'p2')).future),
        throwsA(isA<Server>()),
      );
    },
  );

  test('QRS-022 every project failing is an error', () async {
    final c = await _container(
      FakeCloud(),
      accounts: () => [_two],
      broken: {'p1', 'p2'},
    );
    await expectLater(
      c.read(serversProvider(_all).future),
      throwsA(isA<Server>()),
    );
  });

  test('QRS-022 a new project reaches the lists of "All projects"', () async {
    var accounts = [acme];
    final c = await _container(FakeCloud(), accounts: () => accounts);
    c.listen(serversProvider(_all), (_, _) {});
    final before = await c.read(serversProvider(_all).future);
    expect({for (final s in before) s.projectId}, {'p1'});
    accounts = [_two];
    c.invalidate(accountsProvider);
    await c.read(accountsProvider.future);
    final after = await c.read(serversProvider(_all).future);
    expect({for (final s in after) s.projectId}, {'p1', 'p2'});
  });
}
