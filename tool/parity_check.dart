// SPDX-License-Identifier: GPL-3.0-or-later
// Checks that every row of docs/target/PARITY.md is proven by a test.
//
//   dart run tool/parity_check.dart
//
// A row counts as covered when its id appears in a test name under test/
// or integration_test/ (`test('CMP-012 ...')`, or a name map of a golden
// loop: any string literal, never a comment), or as deferred when the
// section "Zurückgestellt" of PARITY.md lists it with a reason. Exits 1
// and names the open rows otherwise.
import 'dart:io';

final _id = RegExp('[A-Z]{3}-[0-9]{3}');
final _row = RegExp(r'^\| ([A-Z]{3}-[0-9]{3}) \|');
// A string literal or a comment, whichever starts first.
final _token = RegExp(
  r"'(?:[^'\\\n]|\\.)*'|"
  r'"(?:[^"\\\n]|\\.)*"|//[^\n]*',
);

void main() {
  final lines = File('docs/target/PARITY.md').readAsLinesSync();
  final rows = <String>{};
  final deferred = <String, String>{};
  var inDeferred = false;
  for (final line in lines) {
    if (line.startsWith('## ')) inDeferred = line == '## Zurückgestellt';
    final id = _row.firstMatch(line)?.group(1);
    if (id == null) continue;
    if (!inDeferred) {
      rows.add(id);
    } else {
      deferred[id] = line.split('|')[2].trim();
    }
  }

  final named = <String>{};
  for (final dir in ['test', 'integration_test']) {
    for (final f in Directory(dir).listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      for (final t in _token.allMatches(f.readAsStringSync())) {
        if (t[0]!.startsWith('//')) continue;
        named.addAll(_id.allMatches(t[0]!).map((m) => m[0]!));
      }
    }
  }

  final errors = [
    for (final id in rows)
      if (!named.contains(id) && (deferred[id]?.isEmpty ?? true))
        '$id: no test names it and it is not deferred with a reason',
    for (final id in deferred.keys)
      if (!rows.contains(id)) '$id: deferred, but no such row',
  ];
  final covered = rows.where(named.contains).length;
  stdout.writeln(
    'PARITY: ${rows.length} rows, $covered covered by tests, '
    '${deferred.length} deferred.',
  );
  for (final MapEntry(:key, :value) in deferred.entries) {
    stdout.writeln('  deferred $key: $value');
  }
  if (errors.isEmpty) return;
  errors.forEach(stderr.writeln);
  exitCode = 1;
}
