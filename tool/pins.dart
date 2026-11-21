// SPDX-License-Identifier: GPL-3.0-or-later
// Computes the certificate pins of all Hetzner API hosts.
//
//   dart run tool/pins.dart [--ca-bundle path] [--today YYYY-MM-DD]
//
// For each host the served chain is read with `openssl s_client`. Every CA
// certificate of the chain and every root of the local CA bundle that can
// anchor it is recorded with its SPKI SHA-256. State lives in
// tool/pins.json; lib/core/pins/pins.g.dart is generated from it.
//
// Overlap: a pin that is no longer served is kept and marked `retired`; it
// is dropped 90 days later, so released app versions keep working across a
// CA change. An unchanged chain produces no diff.
//
// Backup anchors: roots marked `"backup": true` in tool/pins.json are kept
// forever, so a CA change of a host does not break installed versions. They
// are added by review (pin plus `"kind": "root", "backup": true`; this tool
// fills name and DER from the CA bundle) and must be self signed roots of
// the bundle. Let's Encrypt hosts carry none yet: ISRG Root YE and YR are
// not in the Mozilla bundle; add them once they are.
//
// Background transfers to Object Storage run in the platform HTTP stacks,
// so every CA pin of those hosts also goes into the Android network
// security config and the iOS NSPinnedDomains. Their roots also become the
// Android trust anchors (res/raw), since Android 7.0 lacks the ISRG roots.
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:falco/core/pins/x509.dart';

const hosts = [
  'api.hetzner.cloud',
  'api.hetzner.com',
  'robot-ws.your-server.de',
  'fsn1.your-objectstorage.com',
  'nbg1.your-objectstorage.com',
  'hel1.your-objectstorage.com',
];
const retention = Duration(days: 90);
const statePath = 'tool/pins.json';
const outputPath = 'lib/core/pins/pins.g.dart';
const androidPath = 'android/app/src/main/res/xml/network_security_config.xml';
const iosPath = 'ios/Runner/Info.plist';
const rawPath = 'android/app/src/main/res/raw';

Future<void> main(List<String> args) async {
  String? option(String name) {
    final i = args.indexOf(name);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final today = option('--today') ?? _date(DateTime.now().toUtc());
  final bundle = await _caBundle(option('--ca-bundle'));
  final stateFile = File(statePath);
  final state = stateFile.existsSync()
      ? (jsonDecode(stateFile.readAsStringSync()) as Map)
            .cast<String, Object?>()
      : <String, Object?>{};

  final next = <String, Object?>{};
  for (final host in hosts) {
    final previous =
        ((state[host] as Map?)?.cast<String, Object?>() ?? const {}).map(
          (k, v) => MapEntry(k, (v! as Map).cast<String, Object?>()),
        );
    final merged = hostPins(
      host,
      await _servedChain(host),
      bundle,
      previous,
      today,
    );
    next[host] = merged;

    stdout.writeln(host);
    for (final MapEntry(:key, :value) in merged.entries) {
      final flag = value['retired'] != null
          ? ' (retired)'
          : value['backup'] == true
          ? ' (backup)'
          : '';
      stdout.writeln('  ${value['kind']} $key ${value['name']}$flag');
    }
  }

  stateFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(next)}\n',
  );
  File(outputPath).writeAsStringSync(_generate(next));
  final pins = nativePins(next);
  final roots = nativeRoots(next);
  for (final (path, write) in [
    (androidPath, (String xml) => androidPins(xml, pins, roots.keys)),
    (iosPath, (String plist) => iosPins(plist, pins)),
  ]) {
    final file = File(path);
    file.writeAsStringSync(write(file.readAsStringSync()));
  }
  final raw = Directory(rawPath)..createSync(recursive: true);
  for (final f in raw.listSync().whereType<File>()) {
    if (f.uri.pathSegments.last.startsWith('pin_')) f.deleteSync();
  }
  for (final MapEntry(:key, :value) in roots.entries) {
    File('$rawPath/$key.der').writeAsBytesSync(base64.decode(value));
  }
}

/// The pins of [host]: the CA certificates of its served [chain], the roots
/// of [bundle] anchoring them, the backup anchors of [previous] and the
/// retired pins of [previous] younger than [retention], sorted by pin.
///
/// A served self issued certificate counts as root only when [bundle] holds
/// it. A backup anchor (`"backup": true`, added by review) is never retired
/// and must be a self issued certificate of [bundle], otherwise the run
/// fails, so a distrusted backup gets a human decision.
Map<String, Map<String, Object?>> hostPins(
  String host,
  List<List<int>> chain,
  List<List<int>> bundle,
  Map<String, Map<String, Object?>> previous,
  String today, {
  String Function(List<int> der) name = _subject,
}) {
  final trusted = {for (final der in bundle) base64.encode(der)};
  final live = <String, Map<String, Object?>>{};
  void add(List<int> der, String kind, {bool backup = false}) {
    final parts = X509Parts.parse(der);
    // A served cross signed CA and its self signed root share the key;
    // the root entry wins, it is what anchors the chain.
    if (live[parts.spkiPin]?['kind'] == 'root' && !backup) return;
    live[parts.spkiPin] = {
      'kind': kind,
      'name': name(der),
      if (backup) 'backup': true,
      if (kind == 'root') 'der': base64.encode(der),
    };
  }

  // Skip the leaf: it rotates every few weeks.
  for (final der in chain.skip(1)) {
    final cert = X509Parts.parse(der);
    if (cert.selfIssued) {
      if (!trusted.contains(base64.encode(der))) {
        throw StateError('$host: served root ${name(der)} is not trusted');
      }
      add(der, 'root');
      continue;
    }
    add(der, 'intermediate');
    // Roots that anchor this certificate, and roots with the same subject
    // (cross signed CAs), so every valid path stays possible.
    for (final root in bundle) {
      final r = X509Parts.parse(root);
      if (_same(r.subject, cert.issuer) || _same(r.subject, cert.subject)) {
        add(root, 'root');
      }
    }
  }
  if (!live.values.any((p) => p['kind'] == 'root')) {
    throw StateError('$host: no root found in the CA bundle');
  }

  for (final MapEntry(:key, :value) in previous.entries) {
    if (value['backup'] != true) continue;
    final der = bundle.where((d) {
      final p = X509Parts.parse(d);
      return p.spkiPin == key && p.selfIssued;
    }).firstOrNull;
    if (der == null) {
      throw StateError('$host: backup anchor $key is not in the CA bundle');
    }
    add(der, 'root', backup: true);
  }

  final merged = <String, Map<String, Object?>>{};
  for (final MapEntry(:key, :value) in previous.entries) {
    if (live.containsKey(key)) continue;
    final retired = (value['retired'] as String?) ?? today;
    final age = DateTime.parse(today).difference(DateTime.parse(retired));
    if (age < retention) merged[key] = {...value, 'retired': retired};
  }
  merged.addAll(live);
  return Map.fromEntries(
    merged.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

/// Every CA pin of the Object Storage hosts (intermediates, roots, backup
/// anchors), retired ones included, sorted. The platform stacks accept a
/// match anywhere in the validated chain.
List<String> nativePins(Map<String, Object?> state) => {
  for (final host in hosts)
    if (host.endsWith('.your-objectstorage.com'))
      for (final key in (state[host]! as Map).keys) key as String,
}.toList()..sort();

/// The roots (base64 DER) of the Object Storage hosts, retired ones
/// included, by Android raw resource name (`pin_` plus the first pin bytes).
SplayTreeMap<String, String> nativeRoots(Map<String, Object?> state) =>
    SplayTreeMap.of({
      for (final host in hosts)
        if (host.endsWith('.your-objectstorage.com'))
          for (final MapEntry(:key, :value)
              in (state[host]! as Map)
                  .cast<String, Map<String, Object?>>()
                  .entries)
            if (value['der'] case final String der) 'pin_${_hex(key)}': der,
    });

String _hex(String pin) => [
  for (final b in base64.decode(pin).take(8))
    b.toRadixString(16).padLeft(2, '0'),
].join();

/// [xml] with its pin-set holding [pins] and its trust anchors holding the
/// raw certificates [roots] plus the system store.
String androidPins(String xml, List<String> pins, Iterable<String> roots) =>
    _replaceOnce(
      _replaceOnce(
        xml,
        RegExp(r'<pin-set>[\s\S]*?</pin-set>'),
        [
          '<pin-set>',
          for (final p in pins) '            <pin digest="SHA-256">$p</pin>',
          '        </pin-set>',
        ].join('\n'),
      ),
      RegExp(r'<trust-anchors>[\s\S]*?</trust-anchors>'),
      [
        '<trust-anchors>',
        for (final r in roots) '            <certificates src="@raw/$r" />',
        '            <certificates src="system" />',
        '        </trust-anchors>',
      ].join('\n'),
    );

/// [plist] with its NSPinnedCAIdentities holding [pins].
String iosPins(String plist, List<String> pins) => _replaceOnce(
  plist,
  RegExp(r'(<key>NSPinnedCAIdentities</key>\s*)<array>[\s\S]*?</array>'),
  [
    '<array>',
    for (final p in pins) ...[
      '${_tabs(5)}<dict>',
      '${_tabs(6)}<key>SPKI-SHA256-BASE64</key>',
      '${_tabs(6)}<string>$p</string>',
      '${_tabs(5)}</dict>',
    ],
    '${_tabs(4)}</array>',
  ].join('\n'),
  keepGroup: true,
);

String _tabs(int n) => '\t' * n;

String _replaceOnce(
  String text,
  RegExp pattern,
  String replacement, {
  bool keepGroup = false,
}) {
  if (pattern.allMatches(text).length != 1) {
    throw StateError('Expected one pin block for $pattern');
  }
  return text.replaceFirstMapped(
    pattern,
    (m) => keepGroup ? '${m[1]}$replacement' : replacement,
  );
}

String _generate(Map<String, Object?> state) {
  final roots = StringBuffer();
  final spki = StringBuffer();
  for (final host in hosts) {
    final pins = (state[host]! as Map).cast<String, Map<String, Object?>>();
    roots.writeln("  '$host': [");
    spki.writeln("  '$host': [");
    for (final MapEntry(:key, :value) in pins.entries) {
      spki.writeln("    '$key', // ${value['kind']}: ${value['name']}");
      if (value['kind'] == 'root') roots.writeln("    '${value['der']}',");
    }
    roots.writeln('  ],');
    spki.writeln('  ],');
  }
  return '''
// GENERATED by tool/pins.dart from tool/pins.json. Do not edit.
// SPDX-License-Identifier: GPL-3.0-or-later
// dart format off

/// Root certificates (base64 DER) trusted per host. Nothing else anchors a
/// TLS connection of Falco.
const pinnedRoots = <String, List<String>>{
$roots};

/// SPKI SHA-256 pins (base64) of the CA certificates per host.
const pinnedSpki = <String, List<String>>{
$spki};
''';
}

Future<List<List<int>>> _servedChain(String host) async {
  final process = await Process.start('openssl', [
    's_client',
    '-connect',
    '$host:443',
    '-servername',
    host,
    '-showcerts',
  ]);
  await process.stdin.close();
  final out = await process.stdout.transform(utf8.decoder).join();
  await process.stderr.drain<void>();
  await process.exitCode;
  final certs = pemCertificates(out);
  if (certs.length < 2) throw StateError('$host: no chain received');
  return certs;
}

String _subject(List<int> der) {
  final tmp = File(
    '${Directory.systemTemp.createTempSync('pins').path}/cert.der',
  )..writeAsBytesSync(der);
  final result = Process.runSync('openssl', [
    'x509',
    '-inform',
    'der',
    '-in',
    tmp.path,
    '-noout',
    '-subject',
    '-nameopt',
    'oneline',
  ]);
  tmp.parent.deleteSync(recursive: true);
  return (result.stdout as String).trim().replaceFirst('subject=', '').trim();
}

Future<List<List<int>>> _caBundle(String? path) async {
  final candidates = [
    ?path,
    '/etc/ssl/certs/ca-certificates.crt', // Debian, Ubuntu (CI)
    '/etc/ssl/cert.pem', // macOS
  ];
  for (final candidate in candidates) {
    final file = File(candidate);
    if (file.existsSync()) return pemCertificates(file.readAsStringSync());
  }
  throw StateError('No CA bundle found, pass --ca-bundle');
}

bool _same(List<int> a, List<int> b) =>
    a.length == b.length &&
    Iterable<int>.generate(a.length).every((i) => a[i] == b[i]);

String _date(DateTime t) => t.toIso8601String().substring(0, 10);
