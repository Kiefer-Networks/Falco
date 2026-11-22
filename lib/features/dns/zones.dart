// SPDX-License-Identifier: GPL-3.0-or-later
/// DNS zones and their RRSets in the Cloud API: model, providers,
/// operations and record rules (DNS-001 to DNS-031, BUG-003 to BUG-006).
// Generated model names of nested paths exceed 80 characters.
// ignore_for_file: lines_longer_than_80_chars
library;

import 'dart:convert' show utf8;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'zones.g.dart';

/// Every record type of the spec (DNS-008). SOA is managed by Hetzner and
/// not offered for new RRSets.
final List<String> rrTypes = [
  for (final t in cloud.ZonesIdOrNameRrsetsPostBodyBodyTypeModel.values)
    if (t != cloud.ZonesIdOrNameRrsetsPostBodyBodyTypeModel.unknown &&
        t.toJson() != 'SOA')
      t.toJson(),
];

/// TTL limits of the spec, one rule for every TTL field (BUG-003).
const minTtl = 60;
const maxTtl = 2147483647;

/// A TTL: empty when [optional], else a whole number in the limits.
bool validTtl(String? text, {bool optional = true}) {
  final t = text?.trim() ?? '';
  if (t.isEmpty) return optional;
  final n = int.tryParse(t);
  return n != null && n >= minTtl && n <= maxTtl;
}

/// A primary nameserver of a secondary zone (DNS-017); the TSIG key and
/// algorithm are null without zone transfer signing.
typedef Nameserver = ({
  String address,
  int port,
  String? tsigKey,
  String? tsigAlgorithm,
});

/// TSIG algorithms of the spec.
const tsigAlgorithms = ['hmac-md5', 'hmac-sha1', 'hmac-sha256'];

/// A zone as Falco shows it.
@immutable
class Zone {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.ttl,
    required this.created,
    this.secondary = false,
    this.status = 'ok',
    this.recordCount = 0,
    this.primaries = const [],
    this.nameservers = const [],
    this.protectDelete = false,
    this.labels = const {},
  });

  factory fromJson(Json z, String projectId) => Zone(
    id: z['id']! as int,
    projectId: projectId,
    name: z['name']! as String,
    ttl: z['ttl'] as int? ?? 3600,
    created: DateTime.parse(z['created']! as String),
    secondary: z['mode'] == 'secondary',
    status: z['status'] as String? ?? 'ok',
    recordCount: z['record_count'] as int? ?? 0,
    primaries: [
      for (final p in jsonList(z['primary_nameservers']))
        (
          address: p['address']! as String,
          port: p['port'] as int? ?? 53,
          tsigKey: p['tsig_key'] as String?,
          tsigAlgorithm: p['tsig_algorithm'] as String?,
        ),
    ],
    nameservers: [
      ...?(json(z['authoritative_nameservers'])['assigned'] as List?)
          ?.cast<String>(),
    ],
    protectDelete: json(z['protection'])['delete'] as bool? ?? false,
    labels: json(z['labels']).cast<String, String>(),
  );

  final int id;
  final String projectId;
  final String name;

  /// Default TTL of the zone's RRSets.
  final int ttl;
  final DateTime created;
  final bool secondary;

  /// `ok`, `updating` or `error`.
  final String status;
  final int recordCount;
  final List<Nameserver> primaries;

  /// Hetzner nameservers assigned to the zone.
  final List<String> nameservers;
  final bool protectDelete;
  final Map<String, String> labels;

  ResourceStatus get resourceStatus => switch (status) {
    'ok' => ResourceStatus.available,
    'updating' => ResourceStatus.inProgress,
    _ => ResourceStatus.error,
  };
}

/// One value of an RRSet with an optional comment.
typedef DnsRecord = ({String value, String comment});

/// A resource record set: all values of one name and type (DNS-023,
/// BUG-005).
@immutable
class RRSet {
  const new({
    required this.name,
    required this.type,
    this.ttl,
    this.records = const [],
    this.protectChange = false,
    this.labels = const {},
  });

  factory fromJson(Json r) => RRSet(
    name: r['name']! as String,
    type: r['type']! as String,
    ttl: r['ttl'] as int?,
    records: [
      for (final v in jsonList(r['records']))
        (value: v['value']! as String, comment: v['comment'] as String? ?? ''),
    ],
    protectChange: json(r['protection'])['change'] as bool? ?? false,
    labels: json(r['labels']).cast<String, String>(),
  );

  /// Relative name, `@` for the zone apex.
  final String name;
  final String type;

  /// Null uses the zone's default.
  final int? ttl;
  final List<DnsRecord> records;
  final bool protectChange;
  final Map<String, String> labels;

  /// `name/TYPE`, the key of an RRSet within its zone.
  String get key => '$name/$type';
}

/// All zones of [scope], every project of "All projects" too (DNS-001,
/// BUG-006).
@riverpod
Future<List<Zone>> zones(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAllJson(
    (page) => cloud.ZonesApi(api).listZones(page: page, perPage: maxPerPage),
    'zones',
    (j) => Zone.fromJson(j, projectId),
  ),
);

/// One zone (DNS-005).
@riverpod
Future<Zone> zone(Ref ref, ProjectScope scope, int zoneId) =>
    getZone(ref.watch(cloudApiProvider(scope.projectId)), scope, zoneId);

/// One zone as the server has it now.
Future<Zone> getZone(cloud.Server api, ProjectScope scope, int zoneId) async {
  final body = await cloudJson(
    cloud.ZonesApi(api).getZone(idOrName: '$zoneId'),
  );
  return Zone.fromJson(json(body['zone']), scope.projectId);
}

/// The RRSets of a zone (DNS-006, DNS-023).
@riverpod
Future<List<RRSet>> rrsets(Ref ref, ProjectScope scope, int zoneId) =>
    fetchAllJson(
      (page) => cloud.ZoneRrSetsApi(
        ref.watch(cloudApiProvider(scope.projectId)),
      ).listZoneRrsets(idOrName: '$zoneId', page: page, perPage: maxPerPage),
      'rrsets',
      RRSet.fromJson,
    );

/// One RRSet (DNS-027).
@riverpod
Future<RRSet> rrset(
  Ref ref,
  ProjectScope scope,
  int zoneId,
  String name,
  String type,
) => getRrset(ref.watch(cloudApiProvider(scope.projectId)), zoneId, name, type);

/// One RRSet as the server has it now.
Future<RRSet> getRrset(
  cloud.Server api,
  int zone,
  String name,
  String type,
) async {
  final body = await cloudJson(
    cloud.ZoneRrSetsApi(api).getZoneRrset(
      idOrName: '$zone',
      rrName: name,
      rrType: cloud.ZonesIdOrNameRrsetsRrNameRrTypeParametersModel3.fromJson(
        type,
      ),
    ),
  );
  return RRSet.fromJson(json(body['rrset']));
}

Json _primary(Nameserver n) => {
  'address': n.address,
  'port': n.port,
  'tsig_key': ?n.tsigKey,
  'tsig_algorithm': ?n.tsigAlgorithm,
};

Json _records(List<DnsRecord> records) => {
  'records': [
    for (final r in records)
      {'value': r.value, if (r.comment.isNotEmpty) 'comment': r.comment},
  ],
};

/// Creates a primary or secondary zone (DNS-002, DNS-022). Returns its id
/// and action.
Future<({int id, int action})> createZone(
  cloud.Server api, {
  required String name,
  bool secondary = false,
  int? ttl,
  List<Nameserver> primaries = const [],
  Map<String, String> labels = const {},
}) async {
  final body = await cloudJson(
    cloud.ZonesApi(api).createZone(
      body: cloud.ZonesPostBodyBodyModel.fromJson({
        'name': name,
        'mode': secondary ? 'secondary' : 'primary',
        'ttl': ?ttl,
        if (secondary)
          'primary_nameservers': [for (final p in primaries) _primary(p)],
        'labels': labels,
      }),
    ),
  );
  return (
    id: json(body['zone'])['id']! as int,
    action: json(body['action'])['id']! as int,
  );
}

/// Relabels a zone (DNS-024).
Future<void> updateZone(cloud.Server api, int id, Map<String, String> labels) =>
    unwrap(
      cloud.ZonesApi(api).updateZone(
        idOrName: '$id',
        body: cloud.ZonesIdOrNamePutBodyBodyModel.fromJson({'labels': labels}),
      ),
    );

/// Deletes a zone with all its RRSets (DNS-004).
Future<int> deleteZone(cloud.Server api, int id) =>
    cloudAction(cloud.ZonesApi(api).deleteZone(idOrName: '$id'));

/// The zone in BIND format (DNS-016).
Future<String> exportZonefile(cloud.Server api, int id) async =>
    (await cloudJson(
          cloud.ZonesApi(api).getZoneZonefile(idOrName: '$id'),
        ))['zonefile']
        as String? ??
    '';

/// Zone actions; each starts one Hetzner action.
sealed class ZoneChange {
  const new();
}

final class ChangeZoneTtl extends ZoneChange {
  const new(this.ttl);

  final int ttl;
}

final class ProtectZone extends ZoneChange {
  const new({required this.delete});

  final bool delete;
}

final class SetPrimaries extends ZoneChange {
  const new(this.primaries);

  final List<Nameserver> primaries;
}

/// Replaces all RRSets with those of a BIND zone file (DNS-015).
final class ImportZonefile extends ZoneChange {
  const new(this.zonefile);

  final String zonefile;
}

/// Starts [change] on zone [id] (DNS-003, DNS-015, DNS-018 to DNS-020,
/// DNS-025).
Future<int> changeZone(cloud.Server api, int id, ZoneChange change) {
  final a = cloud.ZoneActionsApi(api);
  final z = '$id';
  return cloudAction(switch (change) {
    ChangeZoneTtl(:final ttl) => a.changeZoneTtl(
      idOrName: z,
      body: cloud.ZonesIdOrNameActionsChangeTtlPostBodyBodyModel.fromJson({
        'ttl': ttl,
      }),
    ),
    ProtectZone(:final delete) => a.changeZoneProtection(
      idOrName: z,
      body:
          cloud.ZonesIdOrNameActionsChangeProtectionPostBodyBodyModel.fromJson({
            'delete': delete,
          }),
    ),
    SetPrimaries(:final primaries) => a.changeZonePrimaryNameservers(
      idOrName: z,
      body:
          cloud
              .ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel.fromJson(
            {
              'primary_nameservers': [for (final p in primaries) _primary(p)],
            },
          ),
    ),
    ImportZonefile(:final zonefile) => a.importZoneZonefile(
      idOrName: z,
      body: cloud.ZonesIdOrNameActionsImportZonefilePostBodyBodyModel.fromJson({
        'zonefile': zonefile,
      }),
    ),
  });
}

/// Creates an RRSet with name, type, TTL, values and labels in one call
/// (DNS-007, DNS-026).
Future<int> createRrset(cloud.Server api, int zone, RRSet set) => cloudAction(
  cloud.ZoneRrSetsApi(api).createZoneRrset(
    idOrName: '$zone',
    body: cloud.ZonesIdOrNameRrsetsPostBodyBodyModel.fromJson({
      'name': set.name,
      'type': set.type,
      'ttl': ?set.ttl,
      ..._records(set.records),
      'labels': set.labels,
    }),
  ),
);

/// Relabels an RRSet (DNS-028).
Future<void> updateRrset(
  cloud.Server api,
  int zone,
  RRSet set,
  Map<String, String> labels,
) => unwrap(
  cloud.ZoneRrSetsApi(api).updateZoneRrset(
    idOrName: '$zone',
    rrName: set.name,
    rrType: cloud.ZonesIdOrNameRrsetsRrNameRrTypeParametersModel.fromJson(
      set.type,
    ),
    body: cloud.ZonesIdOrNameRrsetsRrNameRrTypePutBodyBodyModel.fromJson({
      'labels': labels,
    }),
  ),
);

/// Deletes a whole RRSet (DNS-029).
Future<int> deleteRrset(cloud.Server api, int zone, RRSet set) => cloudAction(
  cloud.ZoneRrSetsApi(api).deleteZoneRrset(
    idOrName: '$zone',
    rrName: set.name,
    rrType: cloud.ZonesIdOrNameRrsetsRrNameRrTypeParametersModel2.fromJson(
      set.type,
    ),
  ),
);

/// RRSet actions; each starts one Hetzner action.
sealed class RRSetChange {
  const new();
}

/// Adds values (DNS-007).
final class AddRecords extends RRSetChange {
  const new(this.records);

  final List<DnsRecord> records;
}

/// Replaces all values (DNS-010, DNS-013).
final class SetRecords extends RRSetChange {
  const new(this.records);

  final List<DnsRecord> records;
}

/// Removes values (DNS-011).
final class RemoveRecords extends RRSetChange {
  const new(this.records);

  final List<DnsRecord> records;
}

/// Changes the comments of values (DNS-031).
final class UpdateRecords extends RRSetChange {
  const new(this.records);

  final List<DnsRecord> records;
}

/// Sets the TTL; null uses the zone's default (DNS-010).
final class ChangeRRSetTtl extends RRSetChange {
  const new(this.ttl);

  final int? ttl;
}

final class ProtectRRSet extends RRSetChange {
  const new({required this.change});

  final bool change;
}

/// Starts [change] on RRSet [set] of [zone] (DNS-007, DNS-010, DNS-011,
/// DNS-013, DNS-030, DNS-031).
Future<int> changeRrset(
  cloud.Server api,
  int zone,
  RRSet set,
  RRSetChange change,
) {
  final a = cloud.ZoneRrSetActionsApi(api);
  final z = '$zone';
  final n = set.name;
  final t = set.type;
  return cloudAction(switch (change) {
    AddRecords(:final records) => a.addZoneRrsetRecords(
      idOrName: z,
      rrName: n,
      rrType: cloud
          .ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsParametersModel.fromJson(t),
      body:
          cloud
              .ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel.fromJson(
            _records(records),
          ),
    ),
    SetRecords(:final records) => a.setZoneRrsetRecords(
      idOrName: z,
      rrName: n,
      rrType: cloud
          .ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsParametersModel.fromJson(t),
      body:
          cloud
              .ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel.fromJson(
            _records(records),
          ),
    ),
    RemoveRecords(:final records) => a.removeZoneRrsetRecords(
      idOrName: z,
      rrName: n,
      rrType: cloud
          .ZonesIdOrNameRrsetsRrNameRrTypeActionsRemoveRecordsParametersModel.fromJson(t),
      body:
          cloud
              .ZonesIdOrNameRrsetsRrNameRrTypeActionsRemoveRecordsPostBodyBodyModel.fromJson(
            _records(records),
          ),
    ),
    UpdateRecords(:final records) => a.updateZoneRrsetRecords(
      idOrName: z,
      rrName: n,
      rrType: cloud
          .ZonesIdOrNameRrsetsRrNameRrTypeActionsUpdateRecordsParametersModel.fromJson(t),
      body:
          cloud
              .ZonesIdOrNameRrsetsRrNameRrTypeActionsUpdateRecordsPostBodyBodyModel.fromJson(
            {
              'records': [
                for (final r in records)
                  {'value': r.value, 'comment': r.comment},
              ],
            },
          ),
    ),
    ChangeRRSetTtl(:final ttl) => a.changeZoneRrsetTtl(
      idOrName: z,
      rrName: n,
      rrType: cloud
          .ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlParametersModel.fromJson(t),
      body:
          cloud
              .ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel.fromJson(
            {'ttl': ttl},
          ),
    ),
    ProtectRRSet(:final change) => a.changeZoneRrsetProtection(
      idOrName: z,
      rrName: n,
      rrType: cloud
          .ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeProtectionParametersModel.fromJson(t),
      body:
          cloud
              .ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeProtectionPostBodyBodyModel.fromJson(
            {'change': change},
          ),
    ),
  });
}

/// Types whose value ends in a host name, which must be absolute.
const _hostTypes = {'CNAME', 'NS', 'PTR', 'MX', 'SRV'};

/// TXT values typed as quoted strings: `"a" "b"`.
final _quotedTxt = RegExp(r'^"(?:[^"\\]|\\.)*"(?:\s+"(?:[^"\\]|\\.)*")*$');
final _quotedPart = RegExp(r'"((?:[^"\\]|\\.)*)"');

/// One byte (or character) of an escaped TXT string: `\DDD`, an escaped
/// or a plain character.
final _txtUnit = RegExp(r'\\\d{3}|\\.|.', unicode: true, dotAll: true);

/// The escaped TXT text [escaped] as quoted strings of at most 255 bytes,
/// the limit of one DNS character string; never splits an escape or a
/// character.
String _txtStrings(String escaped) {
  final out = <String>[];
  final chunk = StringBuffer();
  var bytes = 0;
  for (final m in _txtUnit.allMatches(escaped)) {
    final u = m[0]!;
    final n = u.length == 4 && u.startsWith(r'\')
        ? 1
        : utf8.encode(u.startsWith(r'\') ? u.substring(1) : u).length;
    if (bytes + n > 255) {
      out.add('"$chunk"');
      chunk.clear();
      bytes = 0;
    }
    chunk.write(u);
    bytes += n;
  }
  out.add('"$chunk"');
  return out.join(' ');
}

/// Normalizes [value] of [type] as the API expects it (DNS-009): TXT in
/// quotes (inner quotes escaped) as strings of at most 255 bytes, the
/// host name of CNAME, NS, PTR, MX and SRV absolute with a trailing dot.
String normalizeRecord(String type, String value) {
  final v = value.trim();
  if (type == 'TXT') {
    if (_quotedTxt.hasMatch(v)) {
      return [for (final m in _quotedPart.allMatches(v)) _txtStrings(m[1]!)]
          .join(' ');
    }
    if (v.length >= 2 && v.startsWith('"') && v.endsWith('"')) return v;
    return _txtStrings(v.replaceAll(r'\', r'\\').replaceAll('"', r'\"'));
  }
  if (!_hostTypes.contains(type) || v.isEmpty) return v;
  final parts = v.split(RegExp(r'\s+'));
  final host = parts.last;
  if (host.endsWith('.') || !host.contains('.')) return v;
  return [...parts.take(parts.length - 1), '$host.'].join(' ');
}

/// Where the hex data starts in types whose last fields are one hex
/// string that may be split by spaces and written in any case.
const _hexFrom = {'DS': 3, 'CDS': 3, 'TLSA': 3, 'SSHFP': 2};

/// [v] with runs of whitespace outside quoted strings as one space.
String _collapse(String v) => v.replaceAllMapped(
  RegExp(r'"(?:[^"\\]|\\.)*"|\s+'),
  (m) => m[0]!.startsWith('"') ? m[0]! : ' ',
);

/// What tells two values of [type] apart for the API: an address by its
/// bytes (`2001:DB8::1` is `2001:db8:0:0:0:0:0:1`), host names and hex
/// digests in any case, runs of spaces outside quotes as one, a digest
/// split by spaces as one. Compares values the user typed with those
/// the server sends back.
String recordKey(String type, String value) {
  final v = value.trim();
  if (type == 'TXT') return v;
  final spaced = _collapse(v);
  final hex = _hexFrom[type];
  if (hex != null) {
    final f = spaced.split(' ');
    if (f.length > hex) {
      return [...f.take(hex), f.skip(hex).join().toLowerCase()].join(' ');
    }
  }
  try {
    if (type == 'A') return Uri.parseIPv4Address(spaced).join('.');
    if (type == 'AAAA') return Uri.parseIPv6Address(spaced).join('.');
  } on FormatException {
    return spaced;
  }
  return _hostTypes.contains(type) ? spaced.toLowerCase() : spaced;
}
