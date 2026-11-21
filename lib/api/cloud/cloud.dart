// SPDX-License-Identifier: GPL-3.0-or-later
/// Entry points into the generated Cloud and Storage Box clients.
library;

import 'package:dio/dio.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tonik_util/tonik_util.dart';

part 'cloud.g.dart';

/// Base URL of the Cloud API (includes DNS).
const cloudBaseUrl = 'https://api.hetzner.cloud/v1';

/// Generated Cloud API server bound to a pinned [dio] from [createDio].
cloud.Server cloudServer(Dio dio) => cloud.CustomServer(
  baseUrl: dio.options.baseUrl,
  serverConfig: ServerConfig<Dio>.client(dio),
);

/// Creates the pinned Cloud API dio with an auth interceptor. Tests
/// override this with a fake transport.
@Riverpod(keepAlive: true)
Dio Function(Interceptor auth) cloudDio(Ref ref) =>
    (auth) =>
        createDio(baseUrl: cloudBaseUrl, userAgent: falcoUserAgent, auth: auth);

/// The Cloud API of one project. The token is read from the SecretStore
/// per request.
@Riverpod(keepAlive: true)
cloud.Server cloudApi(Ref ref, String projectId) {
  final secrets = ref.watch(secretStoreProvider);
  final dio = ref.watch(cloudDioProvider)(
    storedBearerAuth(() => secrets.cloudToken(projectId)),
  );
  ref.onDispose(dio.close);
  return cloudServer(dio);
}

/// Checks the token behind [dio] with one small list call; throws its
/// [FalcoError]
/// (ONB-017). Nothing is stored.
Future<void> checkCloudToken(Dio dio) async {
  final response = await unwrap(
    cloud.ServersApi(cloudServer(dio)).listServers(perPage: 1),
  );
  if (response is! cloud.ListServersResponse200) throw const Server();
}

/// Loads one Cloud action for the [ActionTracker].
Future<ActionProgress> Function(int id) cloudActionFetcher(
  cloud.ActionsApi api,
) => (id) async {
  final response = await unwrap(api.getAction(id: id));
  if (response is! cloud.GetActionResponse200) throw const Server();
  final a = response.body.action;
  return ActionProgress(
    id: a.id,
    command: a.command,
    status: switch (a.status) {
      cloud.ActionsIdGet200BodyActionStatusModel.running ||
      // An unknown new status is still in flight; the next poll decides.
      cloud.ActionsIdGet200BodyActionStatusModel.unknown =>
        ActionStatus.running,
      cloud.ActionsIdGet200BodyActionStatusModel.success =>
        ActionStatus.success,
      cloud.ActionsIdGet200BodyActionStatusModel.error => ActionStatus.error,
    },
    progress: a.progress,
    resources: [for (final r in a.resources) (r.$type, r.id)],
    errorCode: a.error?.code,
    started: a.started,
  );
};

/// Runs a mutating [call] and returns the id of the action it started.
/// The generated responses share no type, so [id] picks the action from
/// the one success case.
Future<int> actionOf<R>(
  Future<TonikResult<R, Response<Object?>>> call,
  int? Function(R response) id,
) async => id(await unwrap(call)) ?? (throw const Server());

/// Loads [load] for every project of [scope] and joins the lists, so a
/// list of "All projects" is the lists of its projects.
Future<List<T>> perProject<T>(
  Ref ref,
  Scope scope,
  Future<List<T>> Function(cloud.Server api, String projectId) load,
) async {
  final projects = await ref.watch(scopeRepositoryProvider).projectsOf(scope);
  final lists = await Future.wait([
    for (final p in projects) load(ref.watch(cloudApiProvider(p.id)), p.id),
  ]);
  return [for (final l in lists) ...l];
}
