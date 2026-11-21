// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:falco/core/pins/x509.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/pins.dart';

void main() {
  // Real self signed roots from the committed state.
  final state = (jsonDecode(File(statePath).readAsStringSync()) as Map)
      .cast<String, Object?>();
  final robot = (state['robot-ws.your-server.de']! as Map)
      .cast<String, Map<String, Object?>>();
  final roots = [
    for (final p in robot.values)
      if (p['der'] != null) base64.decode(p['der']! as String),
  ];
  final a = roots[0];
  final b = roots[1];
  final pinA = X509Parts.parse(a).spkiPin;
  final pinB = X509Parts.parse(b).spkiPin;

  Map<String, Map<String, Object?>> run(
    List<List<int>> bundle, [
    Map<String, Map<String, Object?>> previous = const {},
    String today = '2026-01-01',
  ]) => hostPins('h', [b, a], bundle, previous, today, name: (_) => 'n');

  test('a served root is pinned when the CA bundle holds it', () {
    expect(run([a]), {
      pinA: {'kind': 'root', 'name': 'n', 'der': base64.encode(a)},
    });
  });

  test('a served self issued certificate outside the CA bundle fails', () {
    expect(() => run([b]), throwsStateError);
  });

  test('a backup anchor is kept from the CA bundle and never retired', () {
    final previous = {
      pinB: <String, Object?>{'kind': 'root', 'backup': true},
    };
    final pins = run([a, b], previous, '2030-01-01');
    expect(pins[pinB], {
      'kind': 'root',
      'name': 'n',
      'backup': true,
      'der': base64.encode(b),
    });
  });

  test('a backup anchor missing from the CA bundle fails', () {
    final previous = {
      pinB: <String, Object?>{'kind': 'root', 'backup': true},
    };
    expect(() => run([a], previous), throwsStateError);
  });

  test('a pin no longer served is retired, then dropped', () {
    final previous = {
      'old=': <String, Object?>{'kind': 'intermediate', 'name': 'x'},
    };
    expect(run([a], previous)['old='], containsPair('retired', '2026-01-01'));
    final retired = {
      'old=': <String, Object?>{
        'kind': 'intermediate',
        'name': 'x',
        'retired': '2025-01-01',
      },
    };
    expect(run([a], retired), isNot(contains('old=')));
  });

  test('the native pins hold every CA pin of Object Storage', () {
    final pins = nativePins(state);
    for (final host in hosts.where((h) => h.contains('objectstorage'))) {
      expect(pins, containsAll((state[host]! as Map).keys), reason: host);
    }
  });
}
