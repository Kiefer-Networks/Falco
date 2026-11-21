// SPDX-License-Identifier: GPL-3.0-or-later
/// Entry points into the generated Cloud and Storage Box clients.
library;

import 'package:dio/dio.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:tonik_util/tonik_util.dart';

/// Base URL of the Cloud API (includes DNS).
const cloudBaseUrl = 'https://api.hetzner.cloud/v1';

/// Generated Cloud API server bound to a pinned [dio] from [createDio].
cloud.Server cloudServer(Dio dio) => cloud.CustomServer(
  baseUrl: dio.options.baseUrl,
  serverConfig: ServerConfig<Dio>.client(dio),
);

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
  );
};
