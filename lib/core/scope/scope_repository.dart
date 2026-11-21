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

  /// Deletes an account with all its project and Robot secrets, in one
  /// vault write (one system check).
  Future<void> deleteAccount(String accountId) async {
    final all = await accounts();
    final account = all.where((a) => a.id == accountId).firstOrNull;
    if (account == null) return;
    await _secrets.apply((c) {
      for (final p in account.projects) {
        c.deleteProject(p.id);
      }
      c.deleteRobot(accountId);
    });
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

/// All accounts; invalidated after every change. Lists of a scope watch
/// it, so adding or deleting a project reaches them.
@Riverpod(keepAlive: true)
Future<List<Account>> accounts(Ref ref) =>
    ref.watch(scopeRepositoryProvider).accounts();
