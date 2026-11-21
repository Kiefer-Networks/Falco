// SPDX-License-Identifier: GPL-3.0-or-later
// The native Object Storage pins (Android, iOS) follow tool/pins.json, so
// the pins PR of pins.yml covers them.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/pins.dart';

void main() {
  final state = (jsonDecode(File(statePath).readAsStringSync()) as Map)
      .cast<String, Object?>();
  final pins = nativePins(state);

  test('QRS-017 the native pins are the Object Storage roots', () {
    expect(pins, isNotEmpty);
    final android = File(androidPath).readAsStringSync();
    final ios = File(iosPath).readAsStringSync();
    expect(androidPins(android, pins), android);
    expect(iosPins(ios, pins), ios);
  });

  test('tool/pins.dart rewrites changed native pins', () {
    final android = androidPins(File(androidPath).readAsStringSync(), [
      'new-pin=',
    ]);
    expect(android, contains('<pin digest="SHA-256">new-pin=</pin>'));
    expect(android, isNot(contains(pins.first)));
    final ios = iosPins(File(iosPath).readAsStringSync(), ['new-pin=']);
    expect(ios, contains('<string>new-pin=</string>'));
    expect(ios, isNot(contains(pins.first)));
  });
}
