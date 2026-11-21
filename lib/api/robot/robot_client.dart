// SPDX-License-Identifier: GPL-3.0-or-later
/// Handwritten Robot webservice client (no OpenAPI spec exists). Every
/// endpoint has a fixture under test/fixtures/robot/. Requests are form
/// encoded (`application/x-www-form-urlencoded`), answers are JSON.
library;

import 'package:dio/dio.dart';
import 'package:falco/core/errors/falco_error.dart';

/// Base URL of the Robot webservice.
const robotBaseUrl = 'https://robot-ws.your-server.de';

/// A JSON object as Robot sends it.
typedef RobotJson = Map<String, Object?>;

RobotJson _obj(Object? v) => v is Map ? v.cast<String, Object?>() : const {};

/// [v] unwrapped from `{key: {...}}` when wrapped.
RobotJson _unwrap(Object? v, String key) {
  final o = _obj(v);
  return o[key] is Map ? _obj(o[key]) : o;
}

/// A list field that is an array of options, or the one active value.
List<String> _strings(Object? v) => switch (v) {
  final List<Object?> l => [for (final e in l) '$e'],
  null => const [],
  final s => ['$s'],
};

int _int(Object? v) => v is int ? v : int.tryParse('$v') ?? 0;

/// A dedicated server (`GET /server`, `GET /server/{n}`).
class RobotServer {
  const new({
    required this.number,
    required this.name,
    required this.product,
    required this.dc,
    required this.status,
    required this.cancelled,
    this.ipv4,
    this.ipv6Net,
    this.traffic = '',
    this.paidUntil = '',
    this.ips = const [],
    this.subnets = const [],
    this.reset = false,
    this.rescue = false,
    this.vnc = false,
    this.windows = false,
    this.wol = false,
  });

  /// Parses a server, wrapped in `{"server": ...}` or not.
  factory fromJson(Map<String, Object?> json) {
    final s = _unwrap(json, 'server');
    return RobotServer(
      number: s['server_number']! as int,
      name: (s['server_name'] as String?) ?? '',
      ipv4: s['server_ip'] as String?,
      ipv6Net: s['server_ipv6_net'] as String?,
      product: s['product']! as String,
      dc: s['dc']! as String,
      status: s['status']! as String,
      cancelled: s['cancelled']! as bool,
      traffic: s['traffic'] as String? ?? '',
      paidUntil: s['paid_until'] as String? ?? '',
      ips: _strings(s['ip']),
      subnets: [
        for (final n in (s['subnet'] as List?) ?? const <Object?>[])
          '${_obj(n)['ip']}/${_obj(n)['mask']}',
      ],
      reset: s['reset'] == true,
      rescue: s['rescue'] == true,
      vnc: s['vnc'] == true,
      windows: s['windows'] == true,
      wol: s['wol'] == true,
    );
  }

  /// Server number, the id in Robot.
  final int number;

  /// User given name, may be empty.
  final String name;

  /// Main IPv4 address.
  final String? ipv4;

  /// IPv6 net.
  final String? ipv6Net;

  /// Product name, e.g. `AX41-NVMe`.
  final String product;

  /// Data center, e.g. `FSN1-DC14`.
  final String dc;

  /// `ready` or `in process`.
  final String status;

  /// Whether a cancellation is pending.
  final bool cancelled;

  /// Free traffic, e.g. `5 TB` or `unlimited`.
  final String traffic;

  /// `YYYY-MM-DD`.
  final String paidUntil;

  /// Single IPs and subnets (`ip/mask`) of the server.
  final List<String> ips;
  final List<String> subnets;

  /// Availability flags (detail only).
  final bool reset;
  final bool rescue;
  final bool vnc;
  final bool windows;
  final bool wol;

  /// Name, or the number when it has none.
  String get label => name.isEmpty ? '#$number' : name;
}

/// Cancellation of a server (`GET /server/{n}/cancellation`).
typedef RobotCancellation = ({
  String earliest,
  bool cancelled,
  bool reservationPossible,
  bool reserved,
  String? date,
  List<String> reasons,
});

RobotCancellation _cancellation(Object? json) {
  final c = _unwrap(json, 'cancellation');
  return (
    earliest: c['earliest_cancellation_date'] as String? ?? '',
    cancelled: c['cancelled'] == true,
    reservationPossible: c['reservation_possible'] == true,
    // Documented as `reservation` and `reserved`.
    reserved: c['reserved'] == true || c['reservation'] == true,
    // The examples spell it with a dash for IPs and subnets.
    date: (c['cancellation_date'] ?? c['cancellation-date']) as String?,
    reasons: _strings(c['cancellation_reason']),
  );
}

/// A boot configuration: rescue, linux, vnc or windows. Before activation
/// `os`, `dist`, `lang` and `arch` list the options; once active they hold
/// the chosen value.
typedef BootOption = ({
  bool active,
  String? password,
  List<String> os,
  List<String> dist,
  List<String> lang,
  List<String> arch,
  List<String> keys,
});

BootOption _boot(Object? json) {
  final b = _obj(json);
  return (
    active: b['active'] == true,
    password: b['password'] as String?,
    os: _strings(b['os']),
    dist: _strings(b['dist']),
    lang: _strings(b['lang']),
    arch: _strings(b['arch']),
    keys: _strings(b['authorized_key']),
  );
}

/// Boot kinds of `/boot/{n}/{kind}`.
abstract final class BootKind {
  static const rescue = 'rescue';
  static const linux = 'linux';
  static const vnc = 'vnc';
  static const windows = 'windows';
  static const List<String> all = [rescue, linux, vnc, windows];
}

/// An SSH key stored in Robot.
typedef RobotKey = ({
  String name,
  String fingerprint,
  String type,
  int size,
  String data,
  String created,
});

RobotKey _key(Object? json) {
  final k = _unwrap(json, 'key');
  return (
    name: k['name'] as String? ?? '',
    fingerprint: k['fingerprint']! as String,
    type: k['type'] as String? ?? '',
    size: _int(k['size']),
    data: k['data'] as String? ?? '',
    created: k['created_at'] as String? ?? '',
  );
}

/// A reverse DNS entry.
typedef RobotRdns = ({String ip, String ptr});

RobotRdns _rdns(Object? json) {
  final r = _unwrap(json, 'rdns');
  return (ip: r['ip']! as String, ptr: r['ptr'] as String? ?? '');
}

/// A failover IP or net and where it is routed.
typedef RobotFailover = ({
  String ip,
  String netmask,
  String serverIp,
  int serverNumber,
  String? activeServerIp,
});

RobotFailover _failover(Object? json) {
  final f = _unwrap(json, 'failover');
  return (
    ip: f['ip']! as String,
    netmask: f['netmask'] as String? ?? '',
    serverIp: f['server_ip'] as String? ?? '',
    serverNumber: _int(f['server_number']),
    activeServerIp: f['active_server_ip'] as String?,
  );
}

/// A server in a vSwitch.
typedef VSwitchServer = ({int number, String ip, String status});

/// A vSwitch; `servers` and `subnets` only from `GET /vswitch/{id}`.
typedef RobotVSwitch = ({
  int id,
  String name,
  int vlan,
  bool cancelled,
  List<VSwitchServer> servers,
  List<String> subnets,
  List<String> cloudNetworks,
});

RobotVSwitch _vswitch(Object? json) {
  final v = _obj(json);
  List<RobotJson> list(String key) => [
    for (final e in (v[key] as List?) ?? const <Object?>[]) _obj(e),
  ];
  return (
    id: _int(v['id']),
    name: v['name'] as String? ?? '',
    vlan: _int(v['vlan']),
    cancelled: v['cancelled'] == true,
    servers: [
      for (final s in list('server'))
        (
          number: _int(s['server_number']),
          ip: s['server_ip'] as String? ?? '',
          status: s['status'] as String? ?? '',
        ),
    ],
    subnets: [for (final s in list('subnet')) '${s['ip']}/${s['mask']}'],
    cloudNetworks: [
      for (final s in list('cloud_network')) '${s['ip']}/${s['mask']}',
    ],
  );
}

/// What an address endpoint serves: single IPs or subnets.
enum AddressKind {
  ip,
  subnet;

  /// The JSON key and path segment.
  String get key => name;
}

/// A single IP or a subnet with its traffic warnings.
typedef RobotAddress = ({
  String ip,
  int? mask,
  String? gateway,
  String? broadcast,
  String? serverIp,
  int serverNumber,
  bool failover,
  bool locked,
  String? separateMac,
  bool warnings,
  int hourly,
  int daily,
  int monthly,
});

RobotAddress _address(Object? json, AddressKind kind) {
  final a = _unwrap(json, kind.key);
  return (
    ip: a['ip']! as String,
    mask: a['mask'] == null ? null : _int(a['mask']),
    gateway: a['gateway'] as String?,
    broadcast: a['broadcast'] as String?,
    serverIp: a['server_ip'] as String?,
    serverNumber: _int(a['server_number']),
    failover: a['failover'] == true,
    locked: a['locked'] == true,
    separateMac: a['separate_mac'] as String?,
    warnings: a['traffic_warnings'] == true,
    hourly: _int(a['traffic_hourly']),
    daily: _int(a['traffic_daily']),
    monthly: _int(a['traffic_monthly']),
  );
}

/// Cancellation of a single IP or subnet.
typedef AddressCancellation = ({String earliest, bool cancelled, String? date});

/// One firewall rule; absent fields match everything. Keys as Robot names
/// them (`name`, `ip_version`, `src_ip`, `dst_port`, `action`, ...).
typedef FirewallRule = Map<String, String>;

/// Fields of a firewall rule in form order.
const firewallRuleFields = [
  'name',
  'ip_version',
  'protocol',
  'src_ip',
  'src_port',
  'dst_ip',
  'dst_port',
  'tcp_flags',
  'action',
];

/// Rules per direction (`input`, `output`).
typedef FirewallRules = Map<String, List<FirewallRule>>;

FirewallRules _rules(Object? json) {
  final r = _obj(json);
  return {
    for (final d in const ['input', 'output'])
      d: [
        for (final e in (r[d] as List?) ?? const <Object?>[])
          {
            for (final MapEntry(:key, :value) in _obj(e).entries)
              if (value != null) key: '$value',
          },
      ],
  };
}

/// The firewall of a server, or a template (`id`, `name`, `isDefault`).
typedef RobotFirewall = ({
  int id,
  String name,
  String status,
  bool filterIpv6,
  bool whitelistHos,
  bool isDefault,
  String port,
  FirewallRules rules,
});

RobotFirewall _firewall(Object? json) {
  final f = _obj(json);
  return (
    id: _int(f['id']),
    name: f['name'] as String? ?? '',
    status: f['status'] as String? ?? '',
    filterIpv6: f['filter_ipv6'] == true,
    whitelistHos: f['whitelist_hos'] == true,
    isDefault: f['is_default'] == true,
    port: f['port'] as String? ?? '',
    rules: _rules(f['rules']),
  );
}

/// Traffic in GB of one IP or subnet: in, out, sum.
typedef Traffic = ({double inGb, double outGb, double sumGb});

/// Traffic query types and their `from`/`to` formats.
enum TrafficType { day, month, year }

/// Form fields of [rules] as `rules[input][0][name]=...`.
List<(String, String)> rulesForm(FirewallRules rules) => [
  for (final MapEntry(key: direction, value: list) in rules.entries)
    for (final (i, rule) in list.indexed)
      for (final MapEntry(:key, :value) in rule.entries)
        if (value.isNotEmpty) ('rules[$direction][$i][$key]', value),
];

/// Encodes [form] as `application/x-www-form-urlencoded`; repeated keys
/// (`authorized_key[]`) stay in order.
String formEncode(List<(String, String)> form) => [
  for (final (k, v) in form)
    '${Uri.encodeQueryComponent(k)}=${Uri.encodeQueryComponent(v)}',
].join('&');

/// Robot API calls. Errors arrive as [DioException] carrying a
/// FalcoError (see ErrorInterceptor).
class RobotClient {
  /// Creates the client on a pinned, basic auth `dio`.
  const new(this._dio);

  final Dio _dio;

  Future<Object?> _call(
    String method,
    String path, [
    List<(String, String)> form = const [],
  ]) async {
    final response = await _dio.request<Object?>(
      path,
      data: form.isEmpty ? null : formEncode(form),
      options: Options(
        method: method,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    return response.data;
  }

  Future<Object?> _get(String path) => _call('GET', path);

  /// A list endpoint; Robot answers 404 when the list is empty.
  Future<List<T>> _list<T>(String path, T Function(Object? e) map) async {
    try {
      final data = await _get(path);
      return [for (final e in data is List ? data : const <Object?>[]) map(e)];
    } on DioException catch (e) {
      if (toFalcoError(e) is NotFound) return const [];
      rethrow;
    }
  }

  String _ip(String ip) => Uri.encodeComponent(ip);

  // Servers.

  /// `GET /server`.
  Future<List<RobotServer>> servers() =>
      _list('/server', (e) => RobotServer.fromJson(_obj(e)));

  /// `GET /server/{n}`.
  Future<RobotServer> server(int number) async =>
      RobotServer.fromJson(_obj(await _get('/server/$number')));

  /// `POST /server/{n}`: rename (ROB-042).
  Future<void> renameServer(int number, String name) =>
      _call('POST', '/server/$number', [('server_name', name)]);

  /// `GET /server/{n}/cancellation` (ROB-014).
  Future<RobotCancellation> cancellation(int number) async =>
      _cancellation(await _get('/server/$number/cancellation'));

  /// `POST /server/{n}/cancellation`: [date] is `YYYY-MM-DD` or `now`;
  /// [reserve] only when a reservation is possible (ROB-014).
  Future<void> cancelServer(
    int number, {
    required String date,
    String? reason,
    bool? reserve,
  }) => _call('POST', '/server/$number/cancellation', [
    ('cancellation_date', date),
    if (reason != null && reason.isNotEmpty) ('cancellation_reason', reason),
    if (reserve != null) ('reserve_location', '$reserve'),
  ]);

  /// `DELETE /server/{n}/cancellation` (ROB-015).
  Future<void> withdrawCancellation(int number) =>
      _call('DELETE', '/server/$number/cancellation');

  // Reset and Wake on LAN.

  /// `GET /reset`: reset types per server number (ROB-036).
  Future<Map<int, List<String>>> resets() async => {
    for (final r in await _list('/reset', (e) => _unwrap(e, 'reset')))
      _int(r['server_number']): _strings(r['type']),
  };

  /// `GET /reset/{n}`: the reset types the server offers (BUG-012).
  Future<List<String>> resetTypes(int number) async =>
      _strings(_unwrap(await _get('/reset/$number'), 'reset')['type']);

  /// `POST /reset/{n}` (ROB-009).
  Future<void> reset(int number, String type) =>
      _call('POST', '/reset/$number', [('type', type)]);

  /// `GET /wol/{n}`: whether Wake on LAN is available (ROB-043).
  Future<bool> wolAvailable(int number) async {
    try {
      await _get('/wol/$number');
      return true;
    } on DioException catch (e) {
      if (toFalcoError(e) is NotFound) return false;
      rethrow;
    }
  }

  /// `POST /wol/{n}` (ROB-010).
  Future<void> wakeOnLan(int number) => _call('POST', '/wol/$number');

  // Boot configurations.

  /// `GET /boot/{n}`: every boot configuration (ROB-037).
  Future<Map<String, BootOption>> boot(int number) async {
    final b = _unwrap(await _get('/boot/$number'), 'boot');
    return {
      for (final k in BootKind.all)
        if (b[k] is Map) k: _boot(b[k]),
    };
  }

  /// `GET /boot/{n}/{kind}`: options of one configuration.
  Future<BootOption> bootOption(int number, String kind) async =>
      _boot(_unwrap(await _get('/boot/$number/$kind'), kind));

  /// `GET /boot/{n}/{kind}/last`: the last activation (ROB-038, ROB-039).
  Future<BootOption> lastBoot(int number, String kind) async =>
      _boot(_unwrap(await _get('/boot/$number/$kind/last'), kind));

  /// `POST /boot/{n}/{kind}`: activates it; the answer carries the
  /// password, shown once (ROB-011, ROB-039 to ROB-041).
  Future<BootOption> activateBoot(
    int number,
    String kind, {
    String? os,
    String? dist,
    String? lang,
    String? arch,
    List<String> keys = const [],
  }) async => _boot(
    _unwrap(
      await _call('POST', '/boot/$number/$kind', [
        if (os != null) ('os', os),
        if (dist != null) ('dist', dist),
        if (lang != null) ('lang', lang),
        if (arch != null) ('arch', arch),
        for (final k in keys) ('authorized_key[]', k),
      ]),
      kind,
    ),
  );

  /// `DELETE /boot/{n}/{kind}` (ROB-012).
  Future<void> deactivateBoot(int number, String kind) =>
      _call('DELETE', '/boot/$number/$kind');

  // Reverse DNS.

  /// `GET /rdns` (ROB-020).
  Future<List<RobotRdns>> rdns() => _list('/rdns', _rdns);

  /// `GET /rdns/{ip}` (ROB-045); null without entry.
  Future<RobotRdns?> rdnsOf(String ip) async {
    try {
      return _rdns(await _get('/rdns/${_ip(ip)}'));
    } on DioException catch (e) {
      if (toFalcoError(e) is NotFound) return null;
      rethrow;
    }
  }

  /// `PUT /rdns/{ip}` creates, `POST` changes (ROB-046).
  Future<void> setRdns(String ip, String ptr, {required bool create}) =>
      _call(create ? 'PUT' : 'POST', '/rdns/${_ip(ip)}', [('ptr', ptr)]);

  /// `DELETE /rdns/{ip}` (ROB-023).
  Future<void> deleteRdns(String ip) => _call('DELETE', '/rdns/${_ip(ip)}');

  // Failover.

  /// `GET /failover` (ROB-017).
  Future<List<RobotFailover>> failovers() => _list('/failover', _failover);

  /// `GET /failover/{ip}` (ROB-044).
  Future<RobotFailover> failover(String ip) async =>
      _failover(await _get('/failover/${_ip(ip)}'));

  /// `POST /failover/{ip}`: routes to [target], a server main IP
  /// (ROB-018).
  Future<void> routeFailover(String ip, String target) =>
      _call('POST', '/failover/${_ip(ip)}', [('active_server_ip', target)]);

  /// `DELETE /failover/{ip}` (ROB-019).
  Future<void> unrouteFailover(String ip) =>
      _call('DELETE', '/failover/${_ip(ip)}');

  // vSwitch.

  /// `GET /vswitch` (ROB-024).
  Future<List<RobotVSwitch>> vswitches() => _list('/vswitch', _vswitch);

  /// `GET /vswitch/{id}` (ROB-026, ROB-027).
  Future<RobotVSwitch> vswitch(int id) async =>
      _vswitch(await _get('/vswitch/$id'));

  /// `POST /vswitch` (ROB-025).
  Future<RobotVSwitch> createVSwitch(String name, int vlan) async => _vswitch(
    await _call('POST', '/vswitch', [('name', name), ('vlan', '$vlan')]),
  );

  /// `POST /vswitch/{id}` (ROB-030).
  Future<void> updateVSwitch(int id, String name, int vlan) =>
      _call('POST', '/vswitch/$id', [('name', name), ('vlan', '$vlan')]);

  /// `DELETE /vswitch/{id}`: cancels at [date] or `now` (ROB-031).
  Future<void> cancelVSwitch(int id, String date) =>
      _call('DELETE', '/vswitch/$id', [('cancellation_date', date)]);

  /// `POST /vswitch/{id}/server` (ROB-028).
  Future<void> addVSwitchServers(int id, List<int> servers) => _call(
    'POST',
    '/vswitch/$id/server',
    [for (final s in servers) ('server[]', '$s')],
  );

  /// `DELETE /vswitch/{id}/server` (ROB-029).
  Future<void> removeVSwitchServers(int id, List<int> servers) => _call(
    'DELETE',
    '/vswitch/$id/server',
    [for (final s in servers) ('server[]', '$s')],
  );

  // SSH keys.

  /// `GET /key` (ROB-032).
  Future<List<RobotKey>> keys() => _list('/key', _key);

  /// `GET /key/{fp}` (ROB-047).
  Future<RobotKey> key(String fingerprint) async =>
      _key(await _get('/key/$fingerprint'));

  /// `POST /key` (ROB-033).
  Future<RobotKey> addKey(String name, String data) async =>
      _key(await _call('POST', '/key', [('name', name), ('data', data)]));

  /// `POST /key/{fp}` (ROB-048).
  Future<void> renameKey(String fingerprint, String name) =>
      _call('POST', '/key/$fingerprint', [('name', name)]);

  /// `DELETE /key/{fp}` (ROB-034).
  Future<void> deleteKey(String fingerprint) =>
      _call('DELETE', '/key/$fingerprint');

  // Single IPs and subnets.

  /// `GET /ip`, `GET /subnet` (ROB-049, ROB-053).
  Future<List<RobotAddress>> addresses(AddressKind kind) =>
      _list('/${kind.key}', (e) => _address(e, kind));

  /// `GET /ip/{ip}`, `GET /subnet/{ip}`.
  Future<RobotAddress> address(AddressKind kind, String ip) async =>
      _address(await _get('/${kind.key}/${_ip(ip)}'), kind);

  /// `POST /ip/{ip}`, `POST /subnet/{ip}`: traffic warnings (ROB-050,
  /// ROB-054). Hourly and daily in MB, monthly in GB.
  Future<void> setTrafficWarnings(
    AddressKind kind,
    String ip, {
    required bool enabled,
    required int hourly,
    required int daily,
    required int monthly,
  }) => _call('POST', '/${kind.key}/${_ip(ip)}', [
    ('traffic_warnings', '$enabled'),
    ('traffic_hourly', '$hourly'),
    ('traffic_daily', '$daily'),
    ('traffic_monthly', '$monthly'),
  ]);

  /// `GET /{kind}/{ip}/mac`: the separate MAC, null when none is set;
  /// throws [NotFound] (`MAC_NOT_AVAILABLE`) when none is possible.
  Future<String?> mac(AddressKind kind, String ip) async {
    try {
      return _obj(_obj(await _get('/${kind.key}/${_ip(ip)}/mac'))['mac'])['mac']
          as String?;
    } on DioException catch (e) {
      if (toFalcoError(e).code == 'MAC_NOT_FOUND') return null;
      rethrow;
    }
  }

  /// `PUT /{kind}/{ip}/mac` creates, `DELETE` removes (ROB-051, ROB-055).
  Future<void> setMac(AddressKind kind, String ip, {required bool on}) =>
      _call(on ? 'PUT' : 'DELETE', '/${kind.key}/${_ip(ip)}/mac');

  /// `GET /{kind}/{ip}/cancellation` (ROB-052, ROB-056).
  Future<AddressCancellation> addressCancellation(
    AddressKind kind,
    String ip,
  ) async {
    final c = _cancellation(await _get('/${kind.key}/${_ip(ip)}/cancellation'));
    return (earliest: c.earliest, cancelled: c.cancelled, date: c.date);
  }

  /// `POST /{kind}/{ip}/cancellation`.
  Future<void> cancelAddress(AddressKind kind, String ip, String date) => _call(
    'POST',
    '/${kind.key}/${_ip(ip)}/cancellation',
    [('cancellation_date', date)],
  );

  /// `DELETE /{kind}/{ip}/cancellation`.
  Future<void> withdrawAddressCancellation(AddressKind kind, String ip) =>
      _call('DELETE', '/${kind.key}/${_ip(ip)}/cancellation');

  // Traffic.

  /// `POST /traffic` for [ips] and [subnets] between [from] and [to] in
  /// the format of [type] (ROB-008, ROB-059). Without data an address is
  /// missing from the result.
  Future<Map<String, Traffic>> traffic({
    required TrafficType type,
    required String from,
    required String to,
    List<String> ips = const [],
    List<String> subnets = const [],
  }) async {
    final data = _obj(
      _unwrap(
        await _call('POST', '/traffic', [
          ('type', type.name),
          ('from', from),
          ('to', to),
          for (final ip in ips) ('ip[]', ip),
          for (final s in subnets) ('subnet[]', s),
        ]),
        'traffic',
      )['data'],
    );
    double gb(Object? v) => v is num ? v.toDouble() : 0;
    return {
      for (final MapEntry(:key, :value) in data.entries)
        key: (
          inGb: gb(_obj(value)['in']),
          outGb: gb(_obj(value)['out']),
          sumGb: gb(_obj(value)['sum']),
        ),
    };
  }

  // Firewall.

  /// `GET /firewall/{n}` (ROB-057).
  Future<RobotFirewall> firewall(int number) async =>
      _firewall(_unwrap(await _get('/firewall/$number'), 'firewall'));

  /// `POST /firewall/{n}`: the whole configuration, or a template.
  Future<void> setFirewall(
    int number, {
    required bool active,
    required bool filterIpv6,
    bool? whitelistHos,
    FirewallRules? rules,
    int? templateId,
  }) => _call('POST', '/firewall/$number', [
    ('status', active ? 'active' : 'disabled'),
    ('filter_ipv6', '$filterIpv6'),
    if (templateId != null)
      ('template_id', '$templateId')
    else ...[
      ('whitelist_hos', '${whitelistHos ?? false}'),
      ...rulesForm(rules ?? const {}),
    ],
  ]);

  /// `DELETE /firewall/{n}`: clears the configuration.
  Future<void> clearFirewall(int number) =>
      _call('DELETE', '/firewall/$number');

  /// `GET /firewall/template` (ROB-058).
  Future<List<RobotFirewall>> templates() => _list(
    '/firewall/template',
    (e) => _firewall(_unwrap(e, 'firewall_template')),
  );

  /// `GET /firewall/template/{id}`.
  Future<RobotFirewall> template(int id) async => _firewall(
    _unwrap(await _get('/firewall/template/$id'), 'firewall_template'),
  );

  /// `POST /firewall/template` creates, `POST .../{id}` changes.
  Future<RobotFirewall> saveTemplate({
    required String name,
    required bool filterIpv6,
    required bool whitelistHos,
    required bool isDefault,
    required FirewallRules rules,
    int? id,
  }) async => _firewall(
    _unwrap(
      await _call(
        'POST',
        id == null ? '/firewall/template' : '/firewall/template/$id',
        [
          ('name', name),
          ('filter_ipv6', '$filterIpv6'),
          ('whitelist_hos', '$whitelistHos'),
          ('is_default', '$isDefault'),
          ...rulesForm(rules),
        ],
      ),
      'firewall_template',
    ),
  );

  /// `DELETE /firewall/template/{id}`.
  Future<void> deleteTemplate(int id) =>
      _call('DELETE', '/firewall/template/$id');
}
