// SPDX-License-Identifier: GPL-3.0-or-later
// Complete Cloud API objects of the Network area and DNS for the fake
// Cloud API. Data is made up (documentation ranges, example.com).

const Map<String, Object?> fakeLocation = {
  'id': 1,
  'name': 'fsn1',
  'description': 'Falkenstein DC Park 1',
  'country': 'DE',
  'city': 'Falkenstein',
  'latitude': 50.47612,
  'longitude': 12.370071,
  'network_zone': 'eu-central',
};

const _created = '2026-02-01T10:00:00Z';

/// A subnet of a network.
Map<String, Object?> networkSubnetJson({
  String ipRange = '10.0.1.0/24',
  String type = 'cloud',
  String gateway = '10.0.0.1',
  int? vswitch,
}) => {
  'type': type,
  'ip_range': ipRange,
  'network_zone': 'eu-central',
  'gateway': gateway,
  'vswitch_id': vswitch,
};

/// A complete `network` object.
Map<String, Object?> networkJson({
  required int id,
  required String name,
  String ipRange = '10.0.0.0/16',
  List<Map<String, Object?>>? subnets,
  List<Map<String, Object?>> routes = const [],
  List<int> servers = const [],
  List<int> loadBalancers = const [],
}) => {
  'id': id,
  'name': name,
  'ip_range': ipRange,
  'subnets': subnets ?? [networkSubnetJson()],
  'routes': routes,
  'servers': servers,
  'load_balancers': loadBalancers,
  'protection': {'delete': false},
  'labels': <String, Object?>{},
  'created': _created,
  'expose_routes_to_vswitch': false,
};

/// A firewall rule as the API sends it.
Map<String, Object?> ruleJson({
  String direction = 'in',
  String protocol = 'tcp',
  String? port = '22',
  List<String> ips = const ['0.0.0.0/0', '::/0'],
  String? description,
}) => {
  'description': description,
  'direction': direction,
  'source_ips': direction == 'in' ? ips : <String>[],
  'destination_ips': direction == 'out' ? ips : <String>[],
  'protocol': protocol,
  'port': port,
};

/// A complete `firewall` object applied to [servers].
Map<String, Object?> firewallJson({
  required int id,
  required String name,
  List<Map<String, Object?>>? rules,
  List<int> servers = const [],
}) => {
  'id': id,
  'name': name,
  'labels': <String, Object?>{},
  'created': _created,
  'rules': rules ?? [ruleJson()],
  'applied_to': [
    for (final s in servers)
      {
        'type': 'server',
        'server': {'id': s},
      },
  ],
};

/// A complete `floating_ip` object.
Map<String, Object?> floatingIpJson({
  required int id,
  required String name,
  String ip = '198.51.100.10',
  int? server,
  bool ipv6 = false,
}) => {
  'id': id,
  'name': name,
  'description': null,
  'ip': ip,
  'type': ipv6 ? 'ipv6' : 'ipv4',
  'server': server,
  'dns_ptr': [
    {'ip': ip, 'dns_ptr': 'static.example.com'},
  ],
  'home_location': fakeLocation,
  'blocked': false,
  'protection': {'delete': false},
  'labels': <String, Object?>{},
  'created': _created,
};

/// A complete `primary_ip` object.
Map<String, Object?> primaryIpJson({
  required int id,
  required String name,
  String ip = '198.51.100.20',
  int? server,
  bool ipv6 = false,
}) => {
  'id': id,
  'name': name,
  'labels': <String, Object?>{},
  'created': _created,
  'blocked': false,
  'location': fakeLocation,
  'ip': ip,
  'dns_ptr': <Object?>[],
  'protection': {'delete': false},
  'type': ipv6 ? 'ipv6' : 'ipv4',
  'auto_delete': false,
  'assignee_type': 'server',
  'assignee_id': server,
};

Map<String, Object?> _price(String v) => {'net': v, 'gross': v};

/// A complete `load_balancer_type` object; lb11 costs 5.39 in fsn1.
Map<String, Object?> lbTypeJson({
  int id = 1,
  String name = 'lb11',
  int services = 5,
  String price = '5.3900000000',
}) => {
  'id': id,
  'name': name,
  'description': name.toUpperCase(),
  'max_connections': 10000 * id,
  'max_services': services,
  'max_targets': 25 * id,
  'max_assigned_certificates': 10,
  'deprecation': null,
  'prices': [
    {
      'location': 'fsn1',
      'price_hourly': _price('0.0090000000'),
      'price_monthly': _price(price),
      'included_traffic': 21990232555520,
      'price_per_tb_traffic': _price('1.0000000000'),
    },
  ],
};

/// A load balancer service; http and https have `http` options.
Map<String, Object?> lbServiceJson({
  String protocol = 'http',
  int listen = 80,
  int destination = 80,
  List<int> certificates = const [],
}) => {
  'protocol': protocol,
  'listen_port': listen,
  'destination_port': destination,
  'proxyprotocol': false,
  'health_check': {
    'protocol': 'http',
    'port': destination,
    'interval': 15,
    'timeout': 10,
    'retries': 3,
    'http': {
      'domain': null,
      'path': '/',
      'response': '',
      'status_codes': ['2??', '3??'],
      'tls': false,
    },
  },
  if (protocol != 'tcp')
    'http': {
      'cookie_name': 'HCLBSTICKY',
      'cookie_lifetime': 300,
      'timeout_idle': 50,
      'sticky_sessions': false,
      if (protocol == 'https') ...{
        'certificates': certificates,
        'redirect_http': false,
      },
    },
};

/// A load balancer target of server [server].
Map<String, Object?> serverTargetJson(
  int server, {
  String health = 'healthy',
}) => {
  'type': 'server',
  'server': {'id': server, 'ip': '203.0.113.$server'},
  'health_status': [
    {'listen_port': 80, 'status': health},
  ],
  'use_private_ip': false,
};

/// A target as the API returns it after adding [body]: with health status,
/// the server's IP and the matched targets of a selector.
Map<String, Object?> lbTargetFromBody(Map<String, Object?> body) => {
  ...body,
  if (body['server'] case final Map<String, Object?> s)
    'server': {...s, 'ip': '203.0.113.${s['id']}'},
  if (body['type'] == 'label_selector') 'targets': <Object?>[],
  if (body['type'] != 'ip') 'use_private_ip': body['use_private_ip'] ?? false,
  'health_status': <Object?>[],
};

/// A complete `load_balancer` object.
Map<String, Object?> loadBalancerJson({
  required int id,
  required String name,
  List<Map<String, Object?>>? services,
  List<Map<String, Object?>>? targets,
  List<int> networks = const [],
}) => {
  'id': id,
  'name': name,
  'public_net': {
    'enabled': true,
    'ipv4': {
      'id': 3000 + id,
      'ip': '203.0.113.$id',
      'blocked': false,
      'dns_ptr': 'lb.example.com',
    },
    'ipv6': {
      'id': 4000 + id,
      'ip': '2001:db8:$id::1',
      'blocked': false,
      'dns_ptr': null,
    },
  },
  'private_net': [
    for (final n in networks) {'network': n, 'ip': '10.0.0.$id'},
  ],
  'location': fakeLocation,
  'load_balancer_type': lbTypeJson(),
  'protection': {'delete': false},
  'labels': <String, Object?>{},
  'created': _created,
  'services': services ?? [lbServiceJson()],
  'targets': targets ?? [serverTargetJson(1)],
  'algorithm': {'type': 'round_robin'},
  'outgoing_traffic': null,
  'ingoing_traffic': null,
  'included_traffic': 21990232555520,
};

/// A complete `certificate` object; managed ones may have [failed].
Map<String, Object?> certificateJson({
  required int id,
  required String name,
  List<String> domains = const ['example.com'],
  bool managed = false,
  bool failed = false,
  List<int> usedBy = const [],
}) => {
  'id': id,
  'name': name,
  'labels': <String, Object?>{},
  'type': managed ? 'managed' : 'uploaded',
  'certificate': failed ? null : '-----BEGIN CERTIFICATE-----\nFAKE\n',
  'created': _created,
  'not_valid_before': failed ? null : '2026-02-01T10:00:00Z',
  'not_valid_after': failed ? null : '2027-02-01T10:00:00Z',
  'domain_names': domains,
  'fingerprint': failed
      ? null
      : '03:c7:55:9b:2a:d1:04:17:09:f6:d0:7f:18:34:63:d4',
  'status': managed
      ? {
          'issuance': failed ? 'failed' : 'completed',
          'renewal': 'unavailable',
          'error': failed
              ? {'code': 'dns_zone_not_found', 'message': 'DNS zone not found'}
              : null,
        }
      : null,
  'used_by': [
    for (final lb in usedBy) {'id': lb, 'type': 'load_balancer'},
  ],
};

/// A complete `zone` object.
Map<String, Object?> zoneJson({
  required int id,
  required String name,
  int ttl = 3600,
  int records = 0,
  List<Map<String, Object?>>? primaries,
}) => {
  'id': id,
  'name': name,
  'created': _created,
  'mode': primaries == null ? 'primary' : 'secondary',
  'primary_nameservers': primaries ?? <Object?>[],
  'labels': <String, Object?>{},
  'protection': {'delete': false},
  'ttl': ttl,
  'status': 'ok',
  'record_count': records,
  'authoritative_nameservers': {
    'assigned': [
      'hydrogen.ns.hetzner.com.',
      'oxygen.ns.hetzner.com.',
      'helium.ns.hetzner.de.',
    ],
    'delegated': <Object?>[],
    'delegation_last_check': null,
    'delegation_status': 'unknown',
  },
  'registrar': 'other',
};

/// A complete `rrset` object of [zone].
Map<String, Object?> rrsetJson({
  required int zone,
  required String name,
  required String type,
  required List<String> values,
  int? ttl,
}) => {
  'id': '$name/$type',
  'name': name,
  'type': type,
  'ttl': ttl,
  'labels': <String, Object?>{},
  'protection': {'change': false},
  'records': [
    for (final v in values) {'value': v, 'comment': ''},
  ],
  'zone': zone,
};
