// SPDX-License-Identifier: GPL-3.0-or-later
// End to end on a device (Phase 6): a Storage Box flow and an upload in
// the background. HTTP, the file dialog and the platform transfer are
// faked below the app, everything above is the real app.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/steps.dart';
import '../test/storage_steps.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('STB-004 STB-014 STB-016 STB-018 STB-024 create a Storage '
      'Box, snapshot, subaccount, rollback, delete', (tester) async {
    final cloud = await openStorage(tester, 'Storage Boxes');

    await tap(tester, 'Create Storage Box');
    await tap(tester, 'fsn1');
    await tap(tester, 'Next');
    await tap(tester, 'bx11 · 1 TiB · €3.20');
    await tap(tester, 'Next');
    await enter(tester, 'name', 'offsite');
    await passwords(tester);
    await tap(tester, 'Next');
    await tap(tester, 'Create');
    await settleAction(tester);
    await tap(tester, 'offsite');

    await tile(tester, 'Snapshot');
    await enter(tester, 'description', 'first');
    await tap(tester, 'Save');
    await settleAction(tester);
    expect(find.text('first'), findsOneWidget);

    await tile(tester, 'Add subaccount');
    await chip(tester, 'folder', 'photos');
    await passwords(tester);
    await tap(tester, 'Save');
    await settleAction(tester);
    expect(find.textContaining('photos'), findsWidgets);

    await tap(tester, 'first');
    await tap(tester, 'Roll back');
    final name = cloud.storage.snapshots.values.last.last['name']! as String;
    await typeName(tester, name);
    await confirm(tester, 'Roll back');
    await settleAction(tester);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tap(tester, 'Delete');
    await typeName(tester, 'offsite');
    await confirm(tester, 'Delete');
    await settleAction(tester);
    expect(find.text('offsite'), findsNothing);
    expect(cloud.calls, contains('POST /storage_boxes'));
  });

  testWidgets('OBJ-007 OBJ-009 OBJ-022 upload in the background in parts', (
    tester,
  ) async {
    final cloud = await openStorage(tester, 'Object Storage');
    await tap(tester, 'media');
    final dir = Directory.systemTemp.createTempSync('falco-it');
    cloud.files.pickedFile = File('${dir.path}/report.csv')
      ..writeAsStringSync('a,b\n1,2\n3,4\n5,6\n');
    await tap(tester, 'Upload');
    await pumpFrames(tester);
    await tester.pumpAndSettle();
    final object = cloud.storage.buckets['fsn1']!['media']!.objects;
    expect(object['report.csv']!.size, 16);
    expect(cloud.storage.uploads, isEmpty, reason: 'parts were joined');
    expect(find.text('report.csv'), findsOneWidget);
  });
}
