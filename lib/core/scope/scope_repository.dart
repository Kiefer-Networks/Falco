// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:math';

import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scope_repository.g.dart';

/// Accounts and projects. The list itself holds no secrets but is kept in
/// the [SecretStore] as well, so nothing about the user sits in plain
/// preferences.
class ScopeRepository {
  /// Creates the repository.
  const new(this._secrets);

  final SecretStore _secrets;

  static const _key = 'accounts';

  /// All accounts in display order.
  Future<List<Account>> accounts() async {
    final raw = await _secrets.read(_key);
    if (raw == null) return [];
    return [
      for (final a in jsonDecode(raw) as List)
        Account.fromJson((a! as Map).cast<String, Object?>()),
    ];
  }

  /// Adds or replaces [account] (matched by id).
  Future<void> save(Account account) async {
    final all = await accounts();
    final index = all.indexWhere((a) => a.id == account.id);
    if (index < 0) {
      all.add(account);
    } else {
      all[index] = account;
    }
    await _write(all);
  }

  /// Deletes an account with all its project and Robot secrets.
  Future<void> deleteAccount(String accountId) async {
    final all = await accounts();
    final account = all.where((a) => a.id == accountId).firstOrNull;
    if (account == null) return;
    for (final p in account.projects) {
      await _secrets.deleteProject(p.id);
    }
    await _secrets.deleteRobot(accountId);
    await _write(all..removeWhere((a) => a.id == accountId));
  }

  /// Deletes a project and its secrets from its account.
  Future<void> deleteProject(String accountId, String projectId) async {
    final all = await accounts();
    final index = all.indexWhere((a) => a.id == accountId);
    if (index < 0) return;
    await _secrets.deleteProject(projectId);
    all[index] = all[index].copyWith(
      projects: [...all[index].projects.where((p) => p.id != projectId)],
    );
    await _write(all);
  }

  /// Projects a [scope] covers; empty for Robot or unknown scopes.
  Future<List<Project>> projectsOf(Scope scope) async {
    final account = (await accounts())
        .where((a) => a.id == scope.accountId)
        .firstOrNull;
    if (account == null) return const [];
    return switch (scope) {
      ProjectScope(:final projectId) => [
        ...account.projects.where((p) => p.id == projectId),
      ],
      AllProjectsScope() => account.projects,
      RobotScope() => const [],
    };
  }

  Future<void> _write(List<Account> all) =>
      _secrets.write(_key, jsonEncode([for (final a in all) a.toJson()]));
}

/// A new random local id.
String newId() {
  final random = Random.secure();
  return [
    for (var i = 0; i < 16; i++)
      random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}

/// The app wide scope repository.
@Riverpod(keepAlive: true)
ScopeRepository scopeRepository(Ref ref) =>
    ScopeRepository(ref.watch(secretStoreProvider));
