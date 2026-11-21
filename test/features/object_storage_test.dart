// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';

import 'package:falco/api/s3/s3.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/features/storage/transfers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../steps.dart';
import '../storage_steps.dart';

/// Requests to S3 as `METHOD host-location /path?query`.
List<String> s3Calls(FakeCloud cloud) => [
  for (final r in cloud.adapter.requests)
    if (r.uri.host.endsWith('your-objectstorage.com')) _call(r.method, r.uri),
];

String _call(String method, Uri u) {
  final query = u.query.isEmpty ? '' : '?${Uri.decodeFull(u.query)}';
  return '$method ${u.host.split('.').first} ${Uri.decodeFull(u.path)}$query';
}

Future<FakeCloud> openBucket(WidgetTester tester, [FakeCloud? cloud]) async {
  final c = await openStorage(tester, 'Object Storage', cloud: cloud);
  await tap(tester, 'media');
  return c;
}

Future<void> objectMenu(WidgetTester tester, String name, String item) async {
  await tap(tester, name);
  await tap(tester, item);
}

File tempFile(String name, String content) =>
    File('${Directory.systemTemp.createTempSync('falco-test').path}/$name')
      ..writeAsStringSync(content);

void main() {
  group('buckets', () {
    testWidgets('OBJ-001 OBJ-020 buckets of all locations', (tester) async {
      final cloud = await openStorage(tester, 'Object Storage');
      expect(find.text('media'), findsOneWidget);
      expect(find.text('logs'), findsOneWidget);
      expect(find.textContaining('hel1 · '), findsOneWidget);
      final calls = s3Calls(cloud);
      for (final l in ['fsn1', 'nbg1', 'hel1']) {
        expect(calls, contains('GET $l /'));
      }
      await tap(tester, 'hel1');
      expect(find.text('media'), findsNothing);
    });

    testWidgets('OBJ-019 without S3 keys the project points to them', (
      tester,
    ) async {
      await openStorage(tester, 'Object Storage', s3: false);
      expect(
        find.text(
          'This project has no S3 keys. Add them to the project to use '
          'Object Storage.',
        ),
        findsOneWidget,
      );
      await tap(tester, 'Manage account');
      expect(find.text('Acme'), findsWidgets);
    });

    test('OBJ-019 one key pair of the project for every location', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final buckets = await c.read(
        bucketsProvider(const ProjectScope('a1', 'p1')).future,
      );
      expect(
        {for (final b in buckets!) b.name: b.location},
        {'media': 'fsn1', 'logs': 'hel1'},
      );
      for (final r in cloud.adapter.requests) {
        expect('${r.headers['Authorization']}', contains('FAKEACCESSKEY/'));
      }
    });

    testWidgets('OBJ-002 BUG-016 create checks the name, sets visibility and '
        'versioning', (tester) async {
      final cloud = await openStorage(tester, 'Object Storage');
      await tap(tester, 'Create bucket');
      await tap(tester, 'nbg1');
      await tap(tester, 'Next');
      await enter(tester, 'name', 'Bad_Name');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'name', 'new-bucket');
      await chip(tester, 'public', 'Public');
      await chip(tester, 'versioning', 'Yes');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(s3Calls(cloud), contains('PUT nbg1 /new-bucket'));
      expect(s3Calls(cloud), contains('PUT nbg1 /new-bucket?versioning='));
      final at = cloud.storage.buckets['nbg1']!['new-bucket']!;
      expect(at.public, isTrue);
      expect(at.versioning, 'Enabled');
      expect(find.text('new-bucket'), findsOneWidget);
    });

    test('OBJ-002 OBJ-008 S3 name, key and type rules', () {
      expect(validBucketName('media-2026'), isTrue);
      for (final bad in ['ab', 'Upper', 'a..b', '-start', '192.168.1.1']) {
        expect(validBucketName(bad), isFalse, reason: bad);
      }
      expect(validKey('a/b.txt'), isTrue);
      expect(validKey(''), isFalse);
      expect(validKey('ä' * 513), isFalse);
      expect(validMime(mimeOf('x.png')), isTrue);
      expect(mimeOf('archive.unknown'), 'application/octet-stream');
      expect(validMime('text'), isFalse);
    });

    testWidgets('OBJ-003 delete needs an empty bucket and the name', (
      tester,
    ) async {
      final cloud = await openBucket(tester);
      await more(tester, 'Delete bucket');
      await typeName(tester, 'media');
      await confirm(tester, 'Delete');
      expect(
        find.text('The bucket is not empty. Delete its objects first.'),
        findsOneWidget,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tap(tester, 'logs');
      await more(tester, 'Delete bucket');
      await typeName(tester, 'logs');
      await confirm(tester, 'Delete');
      expect(s3Calls(cloud), contains('DELETE hel1 /logs'));
      expect(find.text('logs'), findsNothing);
    });

    testWidgets('OBJ-004 OBJ-005 settings with versioning and visibility', (
      tester,
    ) async {
      final cloud = await openBucket(tester);
      await more(tester, 'Bucket settings');
      expect(find.text('Never enabled'), findsOneWidget);
      await chip(tester, 'versioning', 'Enabled');
      await chip(tester, 'public', 'Public');
      await tap(tester, 'Save');
      final media = cloud.storage.buckets['fsn1']!['media']!;
      expect(media.versioning, 'Enabled');
      expect(media.public, isTrue);
      await more(tester, 'Bucket settings');
      expect(find.text('Never enabled'), findsNothing);
      await chip(tester, 'versioning', 'Suspended');
      await tap(tester, 'Save');
      expect(media.versioning, 'Suspended');
    });
  });

  group('browser', () {
    testWidgets('OBJ-006 folders and objects with size, into a folder', (
      tester,
    ) async {
      await openBucket(tester);
      expect(find.text('docs'), findsOneWidget);
      expect(find.text('logo.png'), findsOneWidget);
      expect(find.textContaining('2 KiB · '), findsOneWidget);
      await tap(tester, 'docs');
      expect(find.text('a.txt'), findsOneWidget);
      expect(find.text('logo.png'), findsNothing);
    });

    testWidgets('empty folder offers upload', (tester) async {
      final cloud = storageCloud();
      cloud.storage.buckets['fsn1']!['media']!.objects.clear();
      await openBucket(tester, cloud);
      expect(find.text('This folder is empty.'), findsOneWidget);
    });

    testWidgets('OBJ-018 OBJ-010 menu and info', (tester) async {
      await openBucket(tester);
      await tap(tester, 'notes.txt');
      for (final item in [
        'Info',
        'Share link',
        'Download',
        'Versions',
        'Copy',
        'Move',
        'Delete',
      ]) {
        expect(find.text(item), findsWidgets);
      }
      await tap(tester, 'Info');
      expect(find.text('64 B'), findsOneWidget);
      expect(find.text('text/plain'), findsOneWidget);
      expect(find.text('"enotes.txt"'), findsOneWidget);
    });

    testWidgets('OBJ-007 OBJ-008 OBJ-009 upload in the background', (
      tester,
    ) async {
      final cloud = await openBucket(tester);
      cloud.files.pickedFile = tempFile('new.txt', 'hello');
      await tester.runAsync(() async {
        await tester.tap(find.text('Upload'));
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await tester.pumpAndSettle();
      expect(
        cloud.storage.buckets['fsn1']!['media']!.objects['new.txt']!.size,
        5,
      );
      expect(find.text('Uploaded: new.txt'), findsOneWidget);
      expect(find.text('new.txt'), findsOneWidget);
    });

    testWidgets('OBJ-011 QRS-024 share link with expiry', (tester) async {
      await openBucket(tester);
      await objectMenu(tester, 'notes.txt', 'Share link');
      await tap(tester, '24 hours');
      final link = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data ?? '')
          .firstWhere((t) => t.startsWith('https://'));
      final uri = Uri.parse(link);
      expect(uri.host, 'fsn1.your-objectstorage.com');
      expect(uri.path, '/media/notes.txt');
      expect(uri.queryParameters['X-Amz-Expires'], '86400');
      expect(
        uri.queryParameters['X-Amz-Credential'],
        startsWith('FAKEACCESSKEY/'),
      );
      expect(find.text('Share'), findsOneWidget);

      // QRS-024: the system share sheet gets the link.
      final shared = <Object?>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('dev.fluttercommunity.plus/share'),
        (call) async {
          shared.add((call.arguments as Map)['uri']);
          return 'dev.fluttercommunity.plus/share/unavailable';
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          null,
        ),
      );
      await tap(tester, 'Share');
      expect(shared, [link]);
    });

    testWidgets('OBJ-012 OBJ-021 download in the background', (tester) async {
      final cloud = await openBucket(tester);
      await objectMenu(tester, 'logo.png', 'Download');
      await tester.pumpAndSettle();
      expect(cloud.storage.downloads.single.path, '/media/logo.png');
      expect(find.text('Download saved: logo.png'), findsOneWidget);
    });

    testWidgets('OBJ-013 copy to another key', (tester) async {
      final cloud = await openBucket(tester);
      await objectMenu(tester, 'notes.txt', 'Copy');
      await enter(tester, 'key', 'docs/notes-copy.txt');
      await tap(tester, 'Save');
      final objects = cloud.storage.buckets['fsn1']!['media']!.objects;
      expect(objects['docs/notes-copy.txt']!.size, 64);
      expect(objects, contains('notes.txt'));
    });

    testWidgets('OBJ-014 move is copy and delete', (tester) async {
      final cloud = await openBucket(tester);
      await objectMenu(tester, 'notes.txt', 'Move');
      await enter(tester, 'key', 'moved.txt');
      await tap(tester, 'Save');
      final objects = cloud.storage.buckets['fsn1']!['media']!.objects;
      expect(objects, contains('moved.txt'));
      expect(objects, isNot(contains('notes.txt')));
      expect(find.text('moved.txt'), findsOneWidget);
    });

    testWidgets('OBJ-015 delete with the name', (tester) async {
      final cloud = await openBucket(tester);
      await objectMenu(tester, 'notes.txt', 'Delete');
      await typeName(tester, 'notes.txt');
      await confirm(tester, 'Delete');
      expect(s3Calls(cloud), contains('DELETE fsn1 /media/notes.txt'));
      expect(find.text('notes.txt'), findsNothing);
    });

    testWidgets('OBJ-016 OBJ-017 select several, delete, partial failure', (
      tester,
    ) async {
      final cloud = storageCloud();
      cloud.storage.buckets['fsn1']!['media']!.objects['locked.bin'] =
          FakeObject(1);
      await openBucket(tester, cloud);
      await tester.longPress(find.text('notes.txt'));
      await tester.pumpAndSettle();
      await tap(tester, 'locked.bin');
      expect(find.text('2 selected'), findsOneWidget);
      await more(tester, 'Clear selection');
      expect(find.text('2 selected'), findsNothing);
      await tester.longPress(find.text('notes.txt'));
      await tester.pumpAndSettle();
      await tap(tester, 'locked.bin');
      await more(tester, 'Delete');
      expect(find.text('Delete 2 objects?'), findsOneWidget);
      await confirm(tester, 'Delete');
      expect(
        find.text('1 deleted, 1 failed and stay selected'),
        findsOneWidget,
      );
      expect(find.text('1 selected'), findsOneWidget);
      expect(find.text('notes.txt'), findsNothing);
    });

    testWidgets('OBJ-023 versions listed and restored', (tester) async {
      final cloud = storageCloud();
      final media = cloud.storage.buckets['fsn1']!['media']!
        ..versioning = 'Enabled';
      media.objects['notes.txt']!
        ..older.add(('v0', 32))
        ..version = 'v2';
      await openBucket(tester, cloud);
      await objectMenu(tester, 'notes.txt', 'Versions');
      expect(find.textContaining('current'), findsOneWidget);
      expect(find.textContaining('v0'), findsOneWidget);
      await tester.tap(find.byTooltip('Restore'));
      await tester.pumpAndSettle();
      await confirm(tester, 'Restore');
      expect(media.objects['notes.txt']!.size, 32);
      expect(media.objects['notes.txt']!.older.first.$2, 64);
    });

    testWidgets('OBJ-024 create a folder', (tester) async {
      final cloud = await openBucket(tester);
      await more(tester, 'Create folder');
      await enter(tester, 'name', 'photos');
      await tap(tester, 'Save');
      expect(s3Calls(cloud), contains('PUT fsn1 /media/photos/'));
      expect(find.text('photos'), findsOneWidget);
    });

    testWidgets('OBJ-025 upload link for a key', (tester) async {
      await openBucket(tester);
      await more(tester, 'Upload link');
      await enter(tester, 'key', 'inbox/drop.zip');
      await tap(tester, 'Save');
      final link = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data ?? '')
          .firstWhere((t) => t.startsWith('https://'));
      expect(Uri.parse(link).path, '/media/inbox/drop.zip');
      expect(Uri.parse(link).queryParameters['X-Amz-Expires'], '3600');
    });
  });

  group('transfers', () {
    test('OBJ-022 a large file uploads in parts and is joined', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      final done = transfers.events.first;
      await transfers.upload(
        projectId: 'p1',
        location: 'fsn1',
        bucket: 'media',
        key: 'big.bin',
        file: tempFile('big.bin', 'x' * 20),
        contentType: 'application/octet-stream',
      );
      expect(await done, (upload: true, ok: true, name: 'big.bin'));
      expect(
        cloud.storage.buckets['fsn1']!['media']!.objects['big.bin']!.size,
        20,
      );
      final calls = s3Calls(cloud);
      expect(calls.where((c) => c.contains('?uploads=')), hasLength(1));
      expect(
        calls.where((c) => c.startsWith('POST fsn1 /media/big.bin?uploadId=')),
        hasLength(1),
      );
      expect(cloud.storage.uploads, isEmpty);
    });

    test('a failed part aborts the multipart upload', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final id = await c
          .read(s3AccessProvider)
          .run('p1', 'fsn1', (s) => s.createMultipart('media', 'x', 'a/b'));
      final dir = Directory.systemTemp.createTempSync('falco-parts');
      final events = c.read(transfersProvider).events.first;
      await c
          .read(transfersProvider)
          .onStatus(
            TaskStatusUpdate(
              UploadTask(
                url: 'https://fsn1.your-objectstorage.com/media/x',
                filename: '1',
                metaData: jsonEncode({
                  'p': 'p1',
                  'l': 'fsn1',
                  'b': 'media',
                  'k': 'x',
                  'u': id,
                  'n': 2,
                  'd': dir.path,
                }),
              ),
              TaskStatus.failed,
            ),
          );
      expect(await events, (upload: true, ok: false, name: 'x'));
      expect(dir.existsSync(), isFalse);
      expect(cloud.storage.uploads, isEmpty);
      expect(s3Calls(cloud), contains('DELETE fsn1 /media/x?uploadId=$id'));
    });
  });

  group('S3', () {
    test('presigned GET matches the AWS example', () {
      final uri = presignV4(
        method: 'GET',
        uri: Uri.parse('https://examplebucket.s3.amazonaws.com/test.txt'),
        accessKey: 'AKIAIOSFODNN7EXAMPLE',
        secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
        region: 'us-east-1',
        now: DateTime.utc(2013, 5, 24),
        expires: const Duration(days: 1),
      );
      expect(
        uri.queryParameters['X-Amz-Signature'],
        'aeeed9bbccd4d02ee5c0109b86d86835f995330da4c265957d157751f604d404',
      );
    });

    test('paths are encoded as signed', () {
      expect(s3Path('b', 'a b/c+d(1).txt'), '/b/a%20b/c%2Bd%281%29.txt');
      expect(
        s3Path('b', '', {'prefix': 'x y/', 'list-type': '2'}),
        '/b?list-type=2&prefix=x%20y%2F',
      );
    });
  });
}
