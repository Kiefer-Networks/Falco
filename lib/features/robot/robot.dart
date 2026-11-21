// SPDX-License-Identifier: GPL-3.0-or-later
/// Robot webservice of an account: the client, one provider per read,
/// the Robot activity and the one way a Robot change runs (ROB-001 to
/// ROB-059).
library;

import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/features/accounts/checks.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'robot.g.dart';

/// The Robot webservice of an account; the login is read per request.
@Riverpod(keepAlive: true)
RobotClient robotApi(Ref ref, String accountId) {
  final secrets = ref.watch(secretStoreProvider);
  final dio = ref.watch(robotDioProvider)(
    storedBasicAuth(() async {
      final c = await secrets.robot(accountId);
      return c == null ? null : (c.user, c.password);
    }),
  );
  ref.onDispose(dio.close);
  return RobotClient(dio);
}

@riverpod
Future<List<RobotServer>> robotServers(Ref ref, String accountId) =>
    ref.watch(robotApiProvider(accountId)).servers();

@riverpod
Future<RobotServer> robotServer(Ref ref, String accountId, int number) =>
    ref.watch(robotApiProvider(accountId)).server(number);

/// Reset types of every server (ROB-036), for the list quick actions.
@riverpod
Future<Map<int, List<String>>> robotResets(Ref ref, String accountId) =>
    ref.watch(robotApiProvider(accountId)).resets();

/// Reset types of one server (ROB-035, BUG-012).
@riverpod
Future<List<String>> robotResetTypes(Ref ref, String accountId, int number) =>
    ref.watch(robotApiProvider(accountId)).resetTypes(number);

@riverpod
Future<bool> robotWol(Ref ref, String accountId, int number) =>
    ref.watch(robotApiProvider(accountId)).wolAvailable(number);

/// Every boot configuration of a server (ROB-037).
@riverpod
Future<Map<String, BootOption>> robotBoot(
  Ref ref,
  String accountId,
  int number,
) => ref.watch(robotApiProvider(accountId)).boot(number);

@riverpod
Future<RobotCancellation> robotCancellation(
  Ref ref,
  String accountId,
  int number,
) => ref.watch(robotApiProvider(accountId)).cancellation(number);

@riverpod
Future<List<RobotRdns>> robotRdns(Ref ref, String accountId) =>
    ref.watch(robotApiProvider(accountId)).rdns();

@riverpod
Future<List<RobotFailover>> robotFailovers(Ref ref, String accountId) =>
    ref.watch(robotApiProvider(accountId)).failovers();

@riverpod
Future<List<RobotVSwitch>> robotVSwitches(Ref ref, String accountId) =>
    ref.watch(robotApiProvider(accountId)).vswitches();

@riverpod
Future<RobotVSwitch> robotVSwitch(Ref ref, String accountId, int id) =>
    ref.watch(robotApiProvider(accountId)).vswitch(id);

@riverpod
Future<List<RobotKey>> robotKeys(Ref ref, String accountId) =>
    ref.watch(robotApiProvider(accountId)).keys();

@riverpod
Future<RobotKey> robotKey(Ref ref, String accountId, String fingerprint) =>
    ref.watch(robotApiProvider(accountId)).key(fingerprint);

@riverpod
Future<List<RobotAddress>> robotAddresses(
  Ref ref,
  String accountId,
  AddressKind kind,
) => ref.watch(robotApiProvider(accountId)).addresses(kind);

@riverpod
Future<RobotAddress> robotAddress(
  Ref ref,
  String accountId,
  AddressKind kind,
  String ip,
) => ref.watch(robotApiProvider(accountId)).address(kind, ip);

/// The separate MAC: `(possible, mac)`.
@riverpod
Future<(bool, String?)> robotMac(
  Ref ref,
  String accountId,
  AddressKind kind,
  String ip,
) async {
  try {
    return (true, await ref.watch(robotApiProvider(accountId)).mac(kind, ip));
  } on Object catch (e) {
    if (toFalcoError(e) is NotFound) return (false, null);
    rethrow;
  }
}

@riverpod
Future<AddressCancellation> robotAddressCancellation(
  Ref ref,
  String accountId,
  AddressKind kind,
  String ip,
) => ref.watch(robotApiProvider(accountId)).addressCancellation(kind, ip);

@riverpod
Future<RobotFirewall> robotFirewall(Ref ref, String accountId, int number) =>
    ref.watch(robotApiProvider(accountId)).firewall(number);

@riverpod
Future<List<RobotFirewall>> robotTemplates(Ref ref, String accountId) =>
    ref.watch(robotApiProvider(accountId)).templates();

@riverpod
Future<RobotFirewall> robotTemplate(Ref ref, String accountId, int id) =>
    ref.watch(robotApiProvider(accountId)).template(id);

/// `YYYY-MM-DD` of [d].
String isoDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// Traffic of [address] in the running month (ROB-008). Robot has data
/// for days that passed, so on the 1st it shows nothing yet.
@riverpod
Future<Traffic?> robotMonthTraffic(
  Ref ref,
  String accountId,
  String address,
) async {
  final now = DateTime.now();
  final data = await ref
      .watch(robotApiProvider(accountId))
      .traffic(
        type: TrafficType.month,
        from: isoDate(DateTime(now.year, now.month)),
        to: isoDate(now),
        ips: [address],
      );
  return data.values.firstOrNull;
}

/// Robot changes of this app session, newest first. Robot has no action
/// list of its own, so the app records what it did (ROB-016).
@Riverpod(keepAlive: true)
class RobotActivity extends _$RobotActivity {
  var _next = 1;

  @override
  List<ActionProgress> build(String accountId) => const [];

  void add(String command, {required bool ok, int? server}) => state = [
    ActionProgress(
      id: _next++,
      command: command,
      status: ok ? ActionStatus.success : ActionStatus.error,
      progress: 100,
      resources: [if (server != null) ('server', server)],
      started: DateTime.now(),
    ),
    ...state,
  ];
}

/// Robot commands as the activity names them.
abstract final class RobotCommand {
  static const reset = 'robot_reset';
  static const wol = 'robot_wol';
  static const bootOn = 'robot_boot_on';
  static const bootOff = 'robot_boot_off';
  static const rename = 'robot_rename';
  static const cancel = 'robot_cancel';
  static const withdraw = 'robot_withdraw';
  static const rdns = 'robot_rdns';
  static const failover = 'robot_failover';
  static const vswitch = 'robot_vswitch';
  static const key = 'robot_key';
  static const address = 'robot_address';
  static const firewall = 'robot_firewall';
}

/// Text of a Robot failure; a section the login may not use says so
/// (ROB-002); throttling stays throttling (ROB-003).
String robotErrorText(FalcoError e, AppLocalizations l10n) => switch (e) {
  Unauthorized() || Forbidden() => l10n.robotSectionDisabled,
  _ => errorText(e, l10n),
};

/// Runs a Robot [change] from [ref]'s screen: records it in the
/// activity, reloads [refresh] and reports "Action completed" or the
/// failure as the snackbar (ROB-016). Returns whether it worked.
Future<bool> runRobot(
  BuildContext context,
  WidgetRef ref,
  String accountId,
  Future<void> Function(RobotClient api) change, {
  required String command,
  List<ProviderOrFamily> refresh = const [],
  int? server,
  String? done,
}) async {
  final l10n = AppLocalizations.of(context);
  try {
    await saveRobot(
      ref,
      accountId,
      change,
      command: command,
      refresh: refresh,
      server: server,
    );
    if (context.mounted) {
      FalcoScaffold.showSnack(context, done ?? l10n.robotDone);
    }
    return true;
  } on FalcoError catch (e) {
    if (context.mounted) {
      FalcoScaffold.showSnack(context, l10n.robotFailed(errorText(e, l10n)));
    }
    return false;
  }
}

/// Like [runRobot] for a sheet's save: a failure is recorded and thrown,
/// so the sheet shows it and stays open.
Future<void> saveRobot(
  WidgetRef ref,
  String accountId,
  Future<void> Function(RobotClient api) change, {
  required String command,
  List<ProviderOrFamily> refresh = const [],
  int? server,
}) async {
  final activity = ref.read(robotActivityProvider(accountId).notifier);
  try {
    await change(ref.read(robotApiProvider(accountId)));
  } on Object catch (e) {
    activity.add(command, ok: false, server: server);
    throw toFalcoError(e);
  }
  activity.add(command, ok: true, server: server);
  refresh.forEach(ref.invalidate);
}
