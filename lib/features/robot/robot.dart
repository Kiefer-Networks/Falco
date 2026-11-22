// SPDX-License-Identifier: GPL-3.0-or-later
/// Robot webservice of an account: the client, one provider per read,
/// the Robot activity and the one way a Robot change runs (ROB-001 to
/// ROB-059).
library;

import 'dart:async' show Completer;
import 'dart:convert' show utf8;
import 'dart:io' show HttpHeaders;
import 'dart:math' show Random;

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart'
    show DioException, InterceptorsWrapper, Options, RequestOptions;
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/scope/scope_repository.dart' show accountsProvider;
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/features/accounts/checks.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'robot.g.dart';

/// A Robot login that Robot refused on `GET /server` too (ROB-002).
const robotLoginRejected = Unauthorized(code: 'ROBOT_LOGIN');

/// The Robot webservice of an account; the login is read per request.
/// Until Robot answered a login, one request with it goes out and the
/// others wait for that answer: Robot blocks the address after three
/// failed logins, so a changed password must not fail once per open list.
/// When Robot refuses a request, `GET /server` is asked once with the
/// same login (one already in flight counts): refused there too, the
/// login is wrong and every request with it fails at once as
/// [robotLoginRejected] (a password changed outside the app included).
/// Accepted there, the refusal blocks only that path, a section the login
/// may not use. Either way it is sent again only after the stored login
/// changes or is saved again (ROB-002). A changed login or a removed
/// account rebuilds the client.
@Riverpod(keepAlive: true)
RobotClient robotApi(Ref ref, String accountId) {
  final secrets = ref.watch(secretStoreProvider);
  // Logins are compared by a keyed hash; the key lives only here.
  final key = [for (var i = 0; i < 32; i++) Random.secure().nextInt(256)];
  Digest fingerprint(RobotCredentials c) =>
      Hmac(sha256, key).convert(utf8.encode('${c.user}\n${c.password}'));
  const login = 'falco.robotLogin';
  const probing = 'falco.robotProbe';
  const first = 'falco.robotFirst';
  const serving = 'falco.robotServing';
  const server = '/server';
  final refused = <String, Digest>{};
  // One probe per login at a time; refusals meanwhile share it.
  final probes = <Digest, Future<int?>>{};
  // Logins Robot answered, and the one request asking for the others.
  final known = <Digest>{};
  final asking = <Digest, Future<void>>{};
  Digest? wrong;
  Digest? last;
  // Every login change and account removal reloads the accounts, and so
  // do other account edits; only a different stored login rebuilds.
  ref.listen(accountsProvider, (previous, next) async {
    if (!(previous?.hasValue ?? false) || next.isLoading) return;
    final seen = last;
    if (seen == null) {
      ref.invalidateSelf();
      return;
    }
    RobotCredentials? c;
    try {
      c = await secrets.robot(accountId);
    } on Object {
      c = null;
    }
    if (!ref.mounted) return;
    if (c == null || fingerprint(c) != seen) ref.invalidateSelf();
  });
  final dio = ref.watch(robotDioProvider)(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // A probe carries the refused request's login already.
        if (options.extra[probing] == true) return handler.next(options);
        final c = await secrets.robot(accountId);
        final sent = c == null ? null : fingerprint(c);
        last = sent;
        while (sent != null && !known.contains(sent)) {
          final ahead = asking[sent];
          if (ahead == null) break;
          await ahead;
        }
        if (c == null || sent == null) {
          return handler.reject(
            DioException(requestOptions: options, error: const Unauthorized()),
          );
        }
        if (sent == wrong || sent == refused[options.path]) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: sent == wrong ? robotLoginRejected : const Unauthorized(),
            ),
          );
        }
        if (!known.contains(sent)) {
          final done = Completer<void>();
          asking[sent] = done.future;
          options.extra[first] = done;
        }
        if (options.path == server &&
            options.method == 'GET' &&
            !probes.containsKey(sent)) {
          final status = Completer<int?>();
          probes[sent] = status.future;
          options.extra[serving] = status;
        }
        options.extra[login] = sent;
        basicAuth(c.user, c.password).onRequest(options, handler);
      },
    ),
  );
  // Status of `GET /server` with the login [refusedBy] carried; null
  // when Robot did not answer.
  Future<int?> probe(RequestOptions refusedBy, Digest sent) =>
      probes[sent] ??= () async {
        try {
          final r = await dio.get<Object?>(
            server,
            options: Options(
              headers: {
                HttpHeaders.authorizationHeader:
                    refusedBy.headers[HttpHeaders.authorizationHeader],
              },
              extra: {probing: true},
            ),
          );
          return r.statusCode;
        } on DioException catch (e) {
          return e.response?.statusCode;
        } finally {
          probes.removeWhere((k, _) => k == sent);
        }
      }();

  // The login a request carried, not the one stored meanwhile.
  Future<void> answered(RequestOptions options, int? status) async {
    final sent = options.extra[login];
    if (options.extra.remove(serving) case final Completer<int?> c) {
      probes.removeWhere((_, f) => f == c.future);
      c.complete(status);
    }
    try {
      if (sent is! Digest || status == null) return;
      if (status == 401) {
        if (sent == wrong) return;
        final path = options.path;
        final check = path == server ? 401 : await probe(options, sent);
        if (check == 401) {
          wrong = sent;
          known.remove(sent);
        } else {
          refused[path] = sent;
          if (check != null) known.add(sent);
        }
      } else {
        known.add(sent);
        if (status < 400 && wrong == sent) wrong = null;
      }
    } finally {
      // Waiting requests go now: with the answer, or one of them asks.
      if (options.extra.remove(first) case final Completer<void> done) {
        asking.removeWhere((_, f) => f == done.future);
        done.complete();
      }
    }
  }

  // A refusal that proved the login wrong says so.
  bool rejectsLogin(RequestOptions options, int? status) =>
      status == 401 && wrong != null && options.extra[login] == wrong;

  // First, so it sees the answer before errors are mapped.
  dio.interceptors.insert(
    0,
    InterceptorsWrapper(
      onResponse: (r, handler) async {
        await answered(r.requestOptions, r.statusCode);
        if (rejectsLogin(r.requestOptions, r.statusCode)) {
          return handler.reject(
            DioException.badResponse(
              statusCode: 401,
              requestOptions: r.requestOptions,
              response: r,
            ).copyWith(error: robotLoginRejected),
          );
        }
        handler.next(r);
      },
      onError: (e, handler) async {
        final status = e.response?.statusCode;
        await answered(e.requestOptions, status);
        if (rejectsLogin(e.requestOptions, status)) {
          return handler.reject(e.copyWith(error: robotLoginRejected));
        }
        handler.next(e);
      },
    ),
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

/// One template. Robot documents no name in the single template answer,
/// so an empty one comes from the list (ROB-058); without it the apply
/// confirmation would have nothing to type and Save would clear the name.
/// The list is read, not watched: deleting the template reloads the list
/// and must not reload this one. The loaded list is used when it has the
/// template, Robot is asked again only otherwise. Without a name the
/// template fails: an empty name would let a typed confirmation pass
/// untyped and Save would clear the name.
@riverpod
Future<RobotFirewall> robotTemplate(Ref ref, String accountId, int id) async {
  final api = ref.watch(robotApiProvider(accountId));
  // Read once by a confirmation: alive until it answers, and the list
  // with it while it is read.
  final alive = ref.keepAlive();
  final list = ref.listen(robotTemplatesProvider(accountId).future, (_, _) {});
  final RobotFirewall t;
  String? name;
  String? nameIn(List<RobotFirewall> list) =>
      list.where((e) => e.id == id && e.name.isNotEmpty).firstOrNull?.name;
  try {
    t = await api.template(id);
    if (t.name.isNotEmpty) return t;
    try {
      name = nameIn(await list.read());
    } on Object {
      name = null;
    }
  } finally {
    list.close();
    alive.close();
  }
  name ??= nameIn(await api.templates());
  if (name == null) throw const NotFound();
  return (
    id: id,
    name: name,
    status: t.status,
    filterIpv6: t.filterIpv6,
    whitelistHos: t.whitelistHos,
    isDefault: t.isDefault,
    port: t.port,
    rules: t.rules,
  );
}

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

/// Text of a Robot failure; a wrong login and a section the login may
/// not use say so (ROB-002); throttling stays throttling (ROB-003).
String robotErrorText(FalcoError e, AppLocalizations l10n) => switch (e) {
  Unauthorized(code: 'ROBOT_LOGIN') => l10n.robotLoginRejected,
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
  // Everything from ref before the first await: the page may be gone
  // when the request returns.
  final activity = ref.read(robotActivityProvider(accountId).notifier);
  final api = ref.read(robotApiProvider(accountId));
  final container = ProviderScope.containerOf(ref.context, listen: false);
  try {
    await change(api);
  } on Object catch (e) {
    activity.add(command, ok: false, server: server);
    throw toFalcoError(e);
  }
  activity.add(command, ok: true, server: server);
  refresh.forEach(container.invalidate);
}
