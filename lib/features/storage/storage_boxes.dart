// SPDX-License-Identifier: GPL-3.0-or-later
/// Storage Boxes of a project via api.hetzner.com: model, providers,
/// operations and the action tracker (STB-001 to STB-037).
library;

// Generated model names are longer than a line.
// ignore_for_file: lines_longer_than_80_chars

import 'package:dio/dio.dart';
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_storage_box_api/hetzner_storage_box_api.dart' as box;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tonik_util/tonik_util.dart';

part 'storage_boxes.g.dart';

/// Resource type of Storage Box actions.
const storageBoxType = 'storage_box';

/// Access protocols of a box or a subaccount; `readonly` only for
/// subaccounts, `zfs` only for boxes.
typedef Access = Map<String, bool>;

/// Keys of the box access settings (STB-007 to STB-011).
const boxAccessKeys = [
  'ssh_enabled',
  'samba_enabled',
  'webdav_enabled',
  'zfs_enabled',
  'reachable_externally',
];

/// Keys of the subaccount access settings (STB-034).
const subaccountAccessKeys = [
  'readonly',
  'ssh_enabled',
  'samba_enabled',
  'webdav_enabled',
  'reachable_externally',
];

Access _access(Object? value, List<String> keys) => {
  for (final k in keys) k: (json(value)[k] as bool?) ?? false,
};

/// The automatic snapshot plan; times are UTC (STB-031).
typedef SnapshotPlan = ({
  int maxSnapshots,
  int minute,
  int hour,
  int? dayOfWeek,
  int? dayOfMonth,
});

/// A Storage Box as Falco shows it.
@immutable
class StorageBox {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.status,
    required this.typeName,
    required this.location,
    required this.created,
    this.username = '',
    this.server = '',
    this.system = '',
    this.capacity = 0,
    this.used = 0,
    this.usedData = 0,
    this.usedSnapshots = 0,
    this.access = const {},
    this.plan,
    this.protectDelete = false,
    this.labels = const {},
  });

  factory fromJson(Json b, String projectId) {
    final type = json(b['storage_box_type']);
    final stats = json(b['stats']);
    final plan = json(b['snapshot_plan']);
    return StorageBox(
      id: b['id']! as int,
      projectId: projectId,
      name: b['name']! as String,
      status: switch (b['status']) {
        'active' => ResourceStatus.active,
        'initializing' => ResourceStatus.initializing,
        'locked' => ResourceStatus.locked,
        _ => ResourceStatus.unknown,
      },
      typeName: type['name'] as String? ?? '',
      capacity: type['size'] as int? ?? 0,
      location: json(b['location'])['name'] as String? ?? '',
      created: DateTime.parse(b['created']! as String),
      username: b['username'] as String? ?? '',
      server: b['server'] as String? ?? '',
      system: b['system'] as String? ?? '',
      used: stats['size'] as int? ?? 0,
      usedData: stats['size_data'] as int? ?? 0,
      usedSnapshots: stats['size_snapshots'] as int? ?? 0,
      access: _access(b['access_settings'], boxAccessKeys),
      plan: plan.isEmpty
          ? null
          : (
              maxSnapshots: plan['max_snapshots']! as int,
              minute: plan['minute']! as int,
              hour: plan['hour']! as int,
              dayOfWeek: plan['day_of_week'] as int?,
              dayOfMonth: plan['day_of_month'] as int?,
            ),
      protectDelete: json(b['protection'])['delete'] == true,
      labels: json(b['labels']).cast<String, String>(),
    );
  }

  final int id;
  final String projectId;
  final String name;
  final ResourceStatus status;
  final String typeName;
  final String location;
  final DateTime created;

  /// Login of the main account, e.g. `u12345`.
  final String username;

  /// Host name, e.g. `u12345.your-storagebox.de`.
  final String server;
  final String system;

  /// Size of the type in bytes.
  final int capacity;

  /// Used bytes: all, data and snapshots (STB-005, STB-006).
  final int used;
  final int usedData;
  final int usedSnapshots;
  final Access access;
  final SnapshotPlan? plan;
  final bool protectDelete;
  final Map<String, String> labels;
}

/// A snapshot of a box (STB-013).
typedef BoxSnapshot = ({
  int id,
  String name,
  String description,
  int size,
  bool automatic,
  DateTime created,
  Map<String, String> labels,
});

BoxSnapshot _snapshot(Json s) => (
  id: s['id']! as int,
  name: s['name'] as String? ?? '',
  description: s['description'] as String? ?? '',
  size: json(s['stats'])['size'] as int? ?? 0,
  automatic: s['is_automatic'] == true,
  created: DateTime.parse(s['created']! as String),
  labels: json(s['labels']).cast<String, String>(),
);

/// A subaccount of a box (STB-017).
typedef Subaccount = ({
  int id,
  String name,
  String username,
  String home,
  String description,
  String server,
  Access access,
  DateTime created,
  Map<String, String> labels,
});

Subaccount _subaccount(Json s) => (
  id: s['id']! as int,
  name: s['name'] as String? ?? '',
  username: s['username'] as String? ?? '',
  home: s['home_directory'] as String? ?? '',
  description: s['description'] as String? ?? '',
  server: s['server'] as String? ?? '',
  access: _access(s['access_settings'], subaccountAccessKeys),
  created: DateTime.parse(s['created']! as String),
  labels: json(s['labels']).cast<String, String>(),
);

/// A box type with its monthly price per location (STB-029, STB-037).
typedef BoxType = ({
  String name,
  String description,
  int size,
  int subaccounts,
  int? snapshots,
  bool deprecated,
  Map<String, String> monthlyGross,
});

BoxType _type(Json t) => (
  name: t['name']! as String,
  description: t['description'] as String? ?? '',
  size: t['size'] as int? ?? 0,
  subaccounts: t['subaccounts_limit'] as int? ?? 0,
  snapshots: t['snapshot_limit'] as int?,
  deprecated: t['deprecation'] != null,
  monthlyGross: {
    for (final p in jsonList(t['prices']))
      p['location']! as String: json(p['price_monthly'])['gross']! as String,
  },
);

/// All Storage Boxes of [scope] (STB-001).
@riverpod
Future<List<StorageBox>> storageBoxes(Ref ref, Scope scope) async {
  final projects = await ref.watch(scopeRepositoryProvider).projectsOf(scope);
  final lists = await Future.wait([
    for (final p in projects)
      fetchAllJson(
        (page) =>
            box.StorageBoxesApi(ref.watch(storageBoxApiProvider(p.id)))
                .listStorageBoxes(page: page, perPage: maxPerPage),
        'storage_boxes',
        (j) => StorageBox.fromJson(j, p.id),
      ),
  ]);
  return [for (final l in lists) ...l];
}

/// One Storage Box (STB-005).
@riverpod
Future<StorageBox> storageBox(Ref ref, ProjectScope scope, int boxId) async {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  final body = await cloudJson(
    box.StorageBoxesApi(api).getStorageBox(id: boxId),
  );
  return StorageBox.fromJson(json(body['storage_box']), scope.projectId);
}

/// Snapshots of a box, newest first (STB-013).
@riverpod
Future<List<BoxSnapshot>> boxSnapshots(
  Ref ref,
  ProjectScope scope,
  int boxId,
) async {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  final body = await cloudJson(
    box.StorageBoxSnapshotsApi(api).listStorageBoxSnapshots(id: boxId),
  );
  return [for (final s in jsonList(body['snapshots'])) _snapshot(s)]
    ..sort((a, b) => b.created.compareTo(a.created));
}

/// One snapshot (STB-035).
@riverpod
Future<BoxSnapshot> boxSnapshot(
  Ref ref,
  ProjectScope scope,
  int boxId,
  int snapshotId,
) async {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  final body = await cloudJson(
    box.StorageBoxSnapshotsApi(api)
        .getStorageBoxSnapshot(id: boxId, snapshotId: snapshotId),
  );
  return _snapshot(json(body['snapshot']));
}

/// Subaccounts of a box (STB-017).
@riverpod
Future<List<Subaccount>> subaccounts(
  Ref ref,
  ProjectScope scope,
  int boxId,
) async {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  final body = await cloudJson(
    box.StorageBoxSubaccountsApi(api).listStorageBoxSubaccounts(id: boxId),
  );
  return [for (final s in jsonList(body['subaccounts'])) _subaccount(s)];
}

/// One subaccount (STB-032).
@riverpod
Future<Subaccount> subaccount(
  Ref ref,
  ProjectScope scope,
  int boxId,
  int subaccountId,
) async {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  final body = await cloudJson(
    box.StorageBoxSubaccountsApi(api)
        .getStorageBoxSubaccount(id: boxId, subaccountId: subaccountId),
  );
  return _subaccount(json(body['subaccount']));
}

/// Top level folders of a box, for a subaccount's home (STB-025).
@riverpod
Future<List<String>> boxFolders(Ref ref, ProjectScope scope, int boxId) async {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  final body = await cloudJson(
    box.StorageBoxesApi(api).listStorageBoxFolders(id: boxId),
  );
  return [...?(body['folders'] as List?)?.cast<String>()]..sort();
}

/// All box types, current ones first (STB-002, STB-029).
@riverpod
Future<List<BoxType>> boxTypes(Ref ref, ProjectScope scope) async {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  final types = await fetchAllJson(
    (page) =>
        box.StorageBoxTypesApi(api)
            .listStorageBoxTypes(page: page, perPage: maxPerPage),
    'storage_box_types',
    _type,
  );
  return types.where((t) => !t.deprecated).toList()
    ..sort((a, b) => a.size.compareTo(b.size));
}

/// One box type with its prices (STB-037).
@riverpod
Future<BoxType> boxType(Ref ref, ProjectScope scope, int typeId) async {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  final body = await cloudJson(
    box.StorageBoxTypesApi(api).getStorageBoxType(id: typeId),
  );
  return _type(json(body['storage_box_type']));
}

/// Actions of one box, newest first (STB-026).
@riverpod
Future<List<ActionProgress>> boxActions(
  Ref ref,
  ProjectScope scope,
  int boxId,
) {
  final api = ref.watch(storageBoxApiProvider(scope.projectId));
  return fetchAllJson(
    (page) => box.StorageBoxActionsApi(api).listStorageBoxActions(
      id: boxId,
      sort: [box.StorageBoxesIdActionsParametersArrayModel.starteddesc],
      page: page,
      perPage: maxPerPage,
    ),
    'actions',
    boxAction,
  );
}

/// Actions of all boxes of a project, for the project activity (STB-022).
Future<List<ActionProgress>> allBoxActions(box.Server api) => fetchAllJson(
  (page) =>
      box.StorageBoxActionsApi(api)
          .listStorageBoxesActions(page: page, perPage: maxPerPage),
  'actions',
  boxAction,
);

/// A Storage Box action as the tracker and activity show it.
ActionProgress boxAction(Json a) => ActionProgress(
  id: a['id']! as int,
  command: a['command'] as String? ?? '',
  status: switch (a['status']) {
    'success' => ActionStatus.success,
    'error' => ActionStatus.error,
    _ => ActionStatus.running,
  },
  progress: a['progress'] as int? ?? 0,
  resources: [
    for (final r in jsonList(a['resources']))
      (r['type']! as String, r['id']! as int),
  ],
  errorCode: json(a['error'])['code'] as String?,
  started: DateTime.tryParse(a['started'] as String? ?? ''),
);

/// Loads one Storage Box action for the [ActionTracker] (STB-027).
Future<ActionProgress> Function(int id) boxActionFetcher(box.Server api) =>
    (id) async => boxAction(
      json(
        (await cloudJson(
          box.StorageBoxActionsApi(api).getStorageBoxesAction(id: id),
        ))['action'],
      ),
    );

/// Runs a Storage Box [call] that starts an action; returns its id.
Future<int> boxCall(Future<TonikResult<Object?, Response<Object?>>> call) =>
    cloudAction(call);

/// The password policy of Storage Boxes and subaccounts (STB-003,
/// STB-012): 12 to 128 characters of the allowed set, with upper and
/// lower case, a digit and a special character.
bool validBoxPassword(String p) =>
    p.length >= 12 &&
    p.length <= 128 &&
    RegExp(r'^[a-zA-ZÄÖÜäöüß0-9^°!§$%/()=?+#\-.,;:~*@{}_&]+$').hasMatch(p) &&
    RegExp('[A-ZÄÖÜ]').hasMatch(p) &&
    RegExp('[a-zäöüß]').hasMatch(p) &&
    RegExp('[0-9]').hasMatch(p) &&
    RegExp('[^a-zA-ZÄÖÜäöüß0-9]').hasMatch(p);

/// Creates a box (STB-003, STB-004).
Future<int> createStorageBox(
  box.Server api, {
  required String name,
  required String location,
  required String type,
  required String password,
  required Access access,
  Map<String, String> labels = const {},
}) => boxCall(
  box.StorageBoxesApi(api).createStorageBox(
    body: box.StorageBoxesPostBodyBodyModel.fromJson({
      'name': name,
      'location': location,
      'storage_box_type': type,
      'password': password,
      'access_settings': access,
      'labels': labels,
    }),
  ),
);

/// Renames or relabels a box (STB-023).
Future<void> updateStorageBox(
  box.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
}) => cloudJson(
  box.StorageBoxesApi(api).updateStorageBox(
    id: id,
    body: box.StorageBoxesIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
    }),
  ),
);

/// Deletes a box (STB-024).
Future<int> deleteStorageBox(box.Server api, int id) =>
    boxCall(box.StorageBoxesApi(api).deleteStorageBox(id: id));

/// Turns delete protection on or off (STB-028).
Future<int> protectStorageBox(box.Server api, int id, {required bool delete}) =>
    boxCall(
      box.StorageBoxActionsApi(api).changeStorageBoxProtection(
        id: id,
        body:
            box.StorageBoxesIdActionsChangeProtectionPostBodyBodyModel.fromJson(
              {'delete': delete},
            ),
      ),
    );

/// Changes the box type (STB-029).
Future<int> changeBoxType(box.Server api, int id, String type) => boxCall(
  box.StorageBoxActionsApi(api).changeStorageBoxType(
    id: id,
    body: box.StorageBoxesIdActionsChangeTypePostBodyBodyModel.fromJson({
      'storage_box_type': type,
    }),
  ),
);

/// Sets a new password of the main account (STB-012).
Future<int> resetBoxPassword(box.Server api, int id, String password) =>
    boxCall(
      box.StorageBoxActionsApi(api).resetStorageBoxPassword(
        id: id,
        body: box.StorageBoxesIdActionsResetPasswordPostBodyBodyModel.fromJson({
          'password': password,
        }),
      ),
    );

/// Changes the box access settings (STB-007 to STB-011).
Future<int> updateBoxAccess(box.Server api, int id, Access access) => boxCall(
  box.StorageBoxActionsApi(api).updateStorageBoxAccessSettings(
    id: id,
    body:
        box.StorageBoxesIdActionsUpdateAccessSettingsPostBodyBodyModel.fromJson(
          access,
        ),
  ),
);

/// Turns the snapshot plan on with [plan] or off with null (STB-030,
/// STB-031).
Future<int> setSnapshotPlan(box.Server api, int id, SnapshotPlan? plan) {
  final actions = box.StorageBoxActionsApi(api);
  return boxCall(
    plan == null
        ? actions.disableStorageBoxSnapshotPlan(id: id)
        : actions.enableStorageBoxSnapshotPlan(
            id: id,
            body:
                box.StorageBoxesIdActionsEnableSnapshotPlanPostBodyBodyModel.fromJson(
                  {
                    'max_snapshots': plan.maxSnapshots,
                    'minute': plan.minute,
                    'hour': plan.hour,
                    'day_of_week': plan.dayOfWeek,
                    'day_of_month': plan.dayOfMonth,
                  },
                ),
          ),
  );
}

/// Creates a snapshot with an optional description (STB-014).
Future<int> createBoxSnapshot(box.Server api, int id, String description) =>
    boxCall(
      box.StorageBoxSnapshotsApi(api).createStorageBoxSnapshot(
        id: id,
        body: box.StorageBoxesIdSnapshotsPostBodyBodyModel.fromJson({
          if (description.isNotEmpty) 'description': description,
        }),
      ),
    );

/// Changes description and labels of a snapshot (STB-036).
Future<void> updateBoxSnapshot(
  box.Server api,
  int id,
  int snapshotId, {
  required String description,
  required Map<String, String> labels,
}) => cloudJson(
  box.StorageBoxSnapshotsApi(api).updateStorageBoxSnapshot(
    id: id,
    snapshotId: snapshotId,
    body: box.StorageBoxesIdSnapshotsSnapshotIdPutBodyBodyModel.fromJson({
      'description': description,
      'labels': labels,
    }),
  ),
);

/// Deletes a snapshot (STB-015).
Future<int> deleteBoxSnapshot(box.Server api, int id, int snapshotId) =>
    boxCall(
      box.StorageBoxSnapshotsApi(api)
          .deleteStorageBoxSnapshot(id: id, snapshotId: snapshotId),
    );

/// Replaces all data of the box with snapshot [name] (STB-016).
Future<int> rollbackBox(box.Server api, int id, String name) => boxCall(
  box.StorageBoxActionsApi(api).rollbackStorageBoxSnapshot(
    id: id,
    body: box.StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel.fromJson({
      'snapshot': name,
    }),
  ),
);

/// Creates a subaccount (STB-018).
Future<int> createSubaccount(
  box.Server api,
  int id, {
  required String home,
  required String password,
  required Access access,
  String name = '',
  String description = '',
  Map<String, String> labels = const {},
}) => boxCall(
  box.StorageBoxSubaccountsApi(api).createStorageBoxSubaccount(
    id: id,
    body: box.StorageBoxesIdSubaccountsPostBodyBodyModel.fromJson({
      'home_directory': home,
      'password': password,
      'access_settings': access,
      if (name.isNotEmpty) 'name': name,
      'description': description,
      'labels': labels,
    }),
  ),
);

/// Changes name, description and labels of a subaccount (STB-021).
Future<void> updateSubaccount(
  box.Server api,
  int id,
  int subaccountId, {
  required String name,
  required String description,
  required Map<String, String> labels,
}) => cloudJson(
  box.StorageBoxSubaccountsApi(api).updateStorageBoxSubaccount(
    id: id,
    subaccountId: subaccountId,
    body: box.StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel.fromJson({
      'name': ?(name.isEmpty ? null : name),
      'description': description,
      'labels': labels,
    }),
  ),
);

/// Deletes a subaccount (STB-019).
Future<int> deleteSubaccount(box.Server api, int id, int subaccountId) =>
    boxCall(
      box.StorageBoxSubaccountsApi(api)
          .deleteStorageBoxSubaccount(id: id, subaccountId: subaccountId),
    );

/// Sets a new subaccount password (STB-020).
Future<int> resetSubaccountPassword(
  box.Server api,
  int id,
  int subaccountId,
  String password,
) => boxCall(
  box.StorageBoxSubaccountActionsApi(api).resetStorageBoxSubaccountPassword(
    id: id,
    subaccountId: subaccountId,
    body:
        box.StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel.fromJson(
          {'password': password},
        ),
  ),
);

/// Moves a subaccount's home (STB-033).
Future<int> changeSubaccountHome(
  box.Server api,
  int id,
  int subaccountId,
  String home,
) => boxCall(
  box.StorageBoxSubaccountActionsApi(
    api,
  ).changeStorageBoxSubaccountHomeDirectory(
    id: id,
    subaccountId: subaccountId,
    body:
        box.StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel.fromJson(
          {'home_directory': home},
        ),
  ),
);

/// Changes read only, external access and protocols of a subaccount
/// (STB-034).
Future<int> updateSubaccountAccess(
  box.Server api,
  int id,
  int subaccountId,
  Access access,
) => boxCall(
  box.StorageBoxSubaccountActionsApi(
    api,
  ).updateStorageBoxSubaccountAccessSettings(
    id: id,
    subaccountId: subaccountId,
    body:
        box.StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.fromJson(
          access,
        ),
  ),
);
