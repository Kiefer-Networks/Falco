// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';

import 'package:falco/api/s3/s3.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/files/text_files.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/features/storage/object_pages.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/features/storage/transfers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Writes job [name] of a new multipart upload of `media/x` in fsn1,
/// changed by [extra]; returns its file.
Future<File> job(
  ProviderContainer c,
  String name,
  Map<String, Object?> extra,
) async {
  final id = await c
      .read(s3AccessProvider)
      .run('p1', 'fsn1', (s) => s.createMultipart('media', 'x', 'a/b'));
  final root = await c.read(transfersProvider).jobsRoot();
  return File('$root/$name.json')
    ..createSync(recursive: true)
    ..writeAsStringSync(
      jsonEncode({
        'p': 'p1',
        'l': 'fsn1',
        'b': 'media',
        'k': 'x',
        'u': id,
        'n': 2,
        'd': name,
        ...extra,
      }),
    );
}

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

    testWidgets('a failing location leaves the others standing', (
      tester,
    ) async {
      final cloud = storageCloud()..storage.failing.add('hel1');
      await openStorage(tester, 'Object Storage', cloud: cloud);
      expect(find.text('media'), findsOneWidget);
      expect(find.textContaining('Could not load: '), findsOneWidget);
      expect(find.textContaining(' hel1.'), findsOneWidget);
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

    test(
      'a bucket whose location stays unknown is named, not guessed',
      () async {
        final cloud = storageCloud()..storage.failLocation = true;
        // Listed by two endpoints: only the bucket itself knows where it is.
        cloud.storage.buckets['nbg1'] = {'media': FakeBucket()};
        final c = await fakeContainer(cloud, s3: true);
        final buckets = await c.read(
          bucketsProvider(const ProjectScope('a1', 'p1')).future,
        );
        expect([for (final b in buckets!) b.name], ['logs']);
        expect(
          (buckets as PartialList<Bucket>).failed.single.name,
          endsWith(' media'),
        );
      },
    );

    test('a bucket whose location is refused stays listed', () async {
      final cloud = storageCloud()..storage.forbidLocation = true;
      cloud.storage.buckets['nbg1'] = {'media': FakeBucket()};
      final c = await fakeContainer(cloud, s3: true);
      final buckets = await c.read(
        bucketsProvider(const ProjectScope('a1', 'p1')).future,
      );
      expect([
        for (final b in buckets!) b.name,
      ], containsAll(['media', 'logs']));
      expect(buckets, isNot(isA<PartialList<Bucket>>()));
    });

    test('with a location failing, single seen buckets are asked', () async {
      final cloud = storageCloud()..storage.failing.add('hel1');
      final c = await fakeContainer(cloud, s3: true);
      await c.read(bucketsProvider(const ProjectScope('a1', 'p1')).future);
      expect(
        s3Calls(cloud).where(
          (c) => c.startsWith('GET fsn1 /media') && c.contains('location'),
        ),
        isNotEmpty,
      );
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

    testWidgets('each finished transfer shows, a sheet defers it', (
      tester,
    ) async {
      await openBucket(tester);
      final page = tester.element(find.byType(BucketPage));
      final transfers = ProviderScope.containerOf(page).read(transfersProvider);
      final messenger = ScaffoldMessenger.of(page);
      Future<void> finish() async {
        await transfers.onStatus(
          TaskStatusUpdate(
            UploadTask(
              url: 'https://fsn1.your-objectstorage.com/media/a.txt',
              filename: 'a.txt',
              metaData: jsonEncode({'k': 'a.txt'}),
            ),
            TaskStatus.complete,
          ),
        );
        await tester.pumpAndSettle();
      }

      await finish();
      expect(find.text('Uploaded: a.txt'), findsOneWidget);
      messenger.hideCurrentSnackBar();
      await tester.pumpAndSettle();
      // The same event again still shows.
      await finish();
      expect(find.text('Uploaded: a.txt'), findsOneWidget);
      messenger.hideCurrentSnackBar();
      await tester.pumpAndSettle();
      // Under a sheet it waits until the sheet closes.
      await tap(tester, 'notes.txt');
      await finish();
      expect(find.text('Uploaded: a.txt'), findsNothing);
      Navigator.of(page).pop();
      await tester.pumpAndSettle();
      expect(find.text('Uploaded: a.txt'), findsOneWidget);
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

    testWidgets('SET-025 without notifications a transfer still runs and '
        'says so', (tester) async {
      final cloud = storageCloud();
      // A failing request counts as not granted.
      cloud.notifications.error = PlatformException(code: 'busy');
      await openBucket(tester, cloud);
      final c = ProviderScope.containerOf(tester.element(find.text('docs')));
      (c.read(transfersProvider) as FakeTransfers).hold = true;
      await objectMenu(tester, 'logo.png', 'Download');
      expect(cloud.notifications.requests, 1);
      expect(cloud.storage.downloads.single.path, '/media/logo.png');
      expect(
        find.text(
          'Downloading logo.png in the background\n'
          'Notifications are off: the transfer runs anyway, its progress '
          'shows only in Falco.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('a finished transfer is shown once, by the folder on top', (
      tester,
    ) async {
      final cloud = storageCloud();
      cloud.storage.buckets['fsn1']!['media']!.objects['docs/b.txt'] =
          FakeObject(1);
      await openBucket(tester, cloud);
      await tap(tester, 'docs');
      await objectMenu(tester, 'a.txt', 'Download');
      await objectMenu(tester, 'b.txt', 'Download');
      // Every snackbar shown: with one per listening folder level the
      // second would follow the first.
      final shown = <SnackBar>{};
      for (var i = 0; i < 400; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        shown.addAll(tester.widgetList<SnackBar>(find.byType(SnackBar)));
      }
      expect(
        shown.where((s) => (s.content as Text).data == 'Download saved: b.txt'),
        hasLength(1),
      );
    });

    testWidgets('a transfer finished while locked shows after the unlock', (
      tester,
    ) async {
      await openBucket(tester);
      final c = ProviderScope.containerOf(tester.element(find.text('docs')));
      final transfers = (c.read(transfersProvider) as FakeTransfers)
        ..hold = true;
      await objectMenu(tester, 'logo.png', 'Download');
      await tester.pumpAndSettle();
      final lock = c.read(appLockProvider.notifier)..paused();
      final later = DateTime.now().add(const Duration(hours: 1));
      lock
        ..now = (() => later)
        ..resumed();
      expect(c.read(appLockProvider), AppLockState.locked);
      await transfers.onStatus(
        TaskStatusUpdate(transfers.downloadTasks.single, TaskStatus.complete),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Download saved: logo.png'), findsNothing);
      await lock.unlock('test');
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Download saved: logo.png'), findsOneWidget);
    });

    testWidgets('a download the platform refuses shows an error', (
      tester,
    ) async {
      await openBucket(tester);
      final c = ProviderScope.containerOf(tester.element(find.text('docs')));
      (c.read(transfersProvider) as FakeTransfers).refuse = true;
      await objectMenu(tester, 'logo.png', 'Download');
      await tester.pumpAndSettle();
      expect(
        find.text('The server reported an error. Try again later.'),
        findsOneWidget,
      );
    });

    testWidgets('a share link of a dot segment key shows why not', (
      tester,
    ) async {
      final cloud = storageCloud();
      cloud.storage.buckets['fsn1']!['media']!.objects['..'] = FakeObject(1);
      await openBucket(tester, cloud);
      await objectMenu(tester, '..', 'Share link');
      await tap(tester, '24 hours');
      expect(find.textContaining('Falco cannot open this object'), findsOne);
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

    testWidgets('copy and move refuse a key ending in /', (tester) async {
      await openBucket(tester);
      await objectMenu(tester, 'notes.txt', 'Move');
      await enter(tester, 'key', 'archive/');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
      );
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
      final transfers = c.read(transfersProvider);
      final dir = Directory('${transfers.partsRoot}/x1')..createSync();
      final events = transfers.events.first;
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
                  'd': 'x1',
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

  group('transfers', () {
    test('a failed join keeps the parts and is retried', () async {
      final cloud = storageCloud();
      cloud.storage.failJoin = 1;
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      var event = transfers.events.first;
      await transfers.upload(
        projectId: 'p1',
        location: 'fsn1',
        bucket: 'media',
        key: 'big.bin',
        file: tempFile('big.bin', 'x' * 20),
        contentType: 'application/octet-stream',
      );
      expect(await event, (upload: true, ok: false, name: 'big.bin'));
      expect(cloud.storage.uploads, hasLength(1));
      expect(Directory(transfers.partsRoot).listSync(), hasLength(1));
      // The job is kept apart from the part copies in temporary space.
      final jobs = Directory(await transfers.jobsRoot());
      expect(jobs.listSync(), hasLength(1));
      expect(s3Calls(cloud).where((c) => c.startsWith('DELETE')), isEmpty);
      event = transfers.events.first;
      await transfers.retryJoins();
      expect(await event, (upload: true, ok: true, name: 'big.bin'));
      expect(
        cloud.storage.buckets['fsn1']!['media']!.objects['big.bin']!.size,
        20,
      );
      expect(Directory(transfers.partsRoot).listSync(), isEmpty);
      expect(jobs.listSync(), isEmpty);
    });

    test(
      'a refused join is parked and retried without repeated failures',
      () async {
        final cloud = storageCloud()..storage.forbidParts = 100;
        final c = await fakeContainer(cloud, s3: true);
        // The parts land, their events stay out: retryJoins joins.
        final transfers = (c.read(transfersProvider) as FakeTransfers)
          ..hold = true;
        final events = <TransferEvent>[];
        transfers.events.listen(events.add);
        await transfers.upload(
          projectId: 'p1',
          location: 'fsn1',
          bucket: 'media',
          key: 'big.bin',
          file: tempFile('big.bin', 'x' * 20),
          contentType: 'application/octet-stream',
        );
        final jobs = Directory(await transfers.jobsRoot());
        await transfers.retryJoins();
        await transfers.retryJoins();
        // Still refused: kept quietly, not aborted.
        expect(events, isEmpty);
        final job = jsonDecode(
          (jobs.listSync().single as File).readAsStringSync(),
        );
        expect(job, isNot(contains('abort')));
        expect(s3Calls(cloud).where((c) => c.startsWith('DELETE')), isEmpty);
        cloud.storage.forbidParts = 0;
        await transfers.retryJoins();
        expect(events.last, (upload: true, ok: true, name: 'big.bin'));
        expect(jobs.listSync(), isEmpty);
      },
    );

    test('a parked join reports once and keeps no finished part', () async {
      final cloud = storageCloud()..storage.forbidParts = 100;
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      final events = <TransferEvent>[];
      transfers.events.listen(events.add);
      final source = Directory.systemTemp.createTempSync(uploadCopyPrefix);
      await transfers.upload(
        projectId: 'p1',
        location: 'fsn1',
        bucket: 'media',
        key: 'big.bin',
        file: File('${source.path}/big.bin')..writeAsStringSync('x' * 20),
        contentType: 'application/octet-stream',
      );
      await pumpEventQueue();
      // Three part events, one failure.
      expect(events, [(upload: true, ok: false, name: 'big.bin')]);
      expect(
        Directory(transfers.partsRoot)
            .listSync(recursive: true)
            .whereType<File>(),
        isEmpty,
      );
      // The picked copy went once the parts were copied.
      expect(source.existsSync(), isFalse);
    });

    test('a join refused for days is given up once', () async {
      final cloud = storageCloud()..storage.forbidParts = 100;
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      final events = <TransferEvent>[];
      transfers.events.listen(events.add);
      final old = DateTime.now().subtract(
        transferLinkExpiry + refusedJoinLimit + const Duration(hours: 1),
      );
      final file = await job(c, 'x1', {
        'e': true,
        't': old.millisecondsSinceEpoch,
      });
      final parts = Directory('${transfers.partsRoot}/x1')..createSync();
      await transfers.retryJoins();
      await transfers.retryJoins();
      expect(events, [(upload: true, ok: false, name: 'x')]);
      expect(file.existsSync(), isFalse);
      expect(parts.existsSync(), isFalse);
    });

    test('a finished single upload drops the picked copy', () async {
      final c = await fakeContainer(storageCloud(), s3: true);
      final transfers = c.read(transfersProvider);
      final done = transfers.events.first;
      final source = Directory.systemTemp.createTempSync(uploadCopyPrefix);
      await transfers.upload(
        projectId: 'p1',
        location: 'fsn1',
        bucket: 'media',
        key: 'a.txt',
        file: File('${source.path}/a.txt')..writeAsStringSync('hi'),
        contentType: 'text/plain',
      );
      expect(source.existsSync(), isTrue);
      await done;
      await pumpEventQueue();
      expect(source.existsSync(), isFalse);
    });

    test(
      'finished transfers wait for their bucket, unwatched ones for any',
      () async {
        final c = await fakeContainer(storageCloud(), s3: true);
        final transfers = c.read(transfersProvider);
        Future<void> upload(String key) async {
          await transfers.upload(
            projectId: 'p1',
            location: 'fsn1',
            bucket: 'media',
            key: key,
            file: tempFile(key, 'hi'),
            contentType: 'text/plain',
          );
          await pumpEventQueue();
        }

        await upload('a.txt');
        await upload('b.txt');
        // Nobody listened: both kept, in order, for any bucket.
        expect(transfers.takeUnseen('logs'), [
          (upload: true, ok: true, name: 'a.txt'),
          (upload: true, ok: true, name: 'b.txt'),
        ]);
        // Only another bucket open: still for any bucket.
        transfers.openBucket('logs');
        await upload('c.txt');
        expect(transfers.takeUnseen('logs'), [
          (upload: true, ok: true, name: 'c.txt'),
        ]);
        transfers.openBucket('media');
        await upload('d.txt');
        expect(transfers.hasUnseen('logs'), isFalse);
        expect(transfers.takeUnseen('media'), [
          (upload: true, ok: true, name: 'd.txt'),
        ]);
        transfers
          ..closeBucket('media')
          ..closeBucket('logs');
        await upload('e.txt');
        expect(transfers.hasUnseen('logs'), isTrue);
      },
    );

    test('uploads send no Content-Disposition', () async {
      final c = await fakeContainer(storageCloud(), s3: true);
      final transfers = c.read(transfersProvider) as FakeTransfers;
      final done = transfers.events.first;
      await transfers.upload(
        projectId: 'p1',
        location: 'fsn1',
        bucket: 'media',
        key: 'a.txt',
        file: tempFile('a.txt', 'hi'),
        contentType: 'text/plain',
      );
      expect(transfers.uploadTasks.single.headers, {
        'Content-Type': 'text/plain',
        'Content-Disposition': '',
      });
      await done;
    });

    test('a multipart upload the platform refuses is aborted', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final transfers = (c.read(transfersProvider) as FakeTransfers)
        ..refuse = true;
      await expectLater(
        transfers.upload(
          projectId: 'p1',
          location: 'fsn1',
          bucket: 'media',
          key: 'big.bin',
          file: tempFile('big.bin', 'x' * 20),
          contentType: 'application/octet-stream',
        ),
        throwsStateError,
      );
      expect(cloud.storage.uploads, isEmpty);
      expect(Directory(transfers.partsRoot).listSync(), isEmpty);
      expect(Directory(await transfers.jobsRoot()).listSync(), isEmpty);
    });

    test('jobs never enqueued or past the link expiry are aborted', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      final events = <TransferEvent>[];
      transfers.events.listen(events.add);
      final old = DateTime.now().subtract(const Duration(hours: 25));
      await job(c, 'x1', {});
      await job(c, 'x2', {'e': true, 't': old.millisecondsSinceEpoch});
      await transfers.retryJoins();
      expect(cloud.storage.uploads, isEmpty);
      expect(Directory(await transfers.jobsRoot()).listSync(), isEmpty);
      expect(events, [(upload: true, ok: false, name: 'x')]);
    });

    test('without keys a job waits silently', () async {
      final c = await fakeContainer(storageCloud(), s3: true);
      final transfers = c.read(transfersProvider);
      final events = <TransferEvent>[];
      transfers.events.listen(events.add);
      final file = await job(c, 'x1', {'e': true, 'p': 'nokeys'});
      await transfers.retryJoins();
      await transfers.retryJoins();
      expect(events, isEmpty);
      expect(file.existsSync(), isTrue);
    });

    test('a job is dropped only once its abort went through', () async {
      final cloud = storageCloud()..storage.failAbort = true;
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      final old = DateTime.now().subtract(const Duration(hours: 25));
      final file = await job(c, 'x1', {
        'e': true,
        't': old.millisecondsSinceEpoch,
      });
      await transfers.retryJoins();
      expect(cloud.storage.uploads, hasLength(1));
      expect(jsonDecode(file.readAsStringSync()), containsPair('abort', true));
      cloud.storage.failAbort = false;
      await transfers.retryJoins();
      expect(cloud.storage.uploads, isEmpty);
      expect(file.existsSync(), isFalse);
    });

    test('a join whose answer was lost is found by the object', () async {
      final cloud = storageCloud()..storage.loseJoin = 1;
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      var event = transfers.events.first;
      await transfers.upload(
        projectId: 'p1',
        location: 'fsn1',
        bucket: 'media',
        key: 'big.bin',
        file: tempFile('big.bin', 'x' * 20),
        contentType: 'application/octet-stream',
      );
      expect(await event, (upload: true, ok: false, name: 'big.bin'));
      event = transfers.events.first;
      await transfers.retryJoins();
      expect(await event, (upload: true, ok: true, name: 'big.bin'));
      expect(Directory(await transfers.jobsRoot()).listSync(), isEmpty);
    });

    test('a lost join is found with the device clock off', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      final events = <TransferEvent>[];
      transfers.events.listen(events.add);
      final ahead = DateTime.now().add(const Duration(days: 3));
      await job(c, 'x1', {
        'e': true,
        't': ahead.millisecondsSinceEpoch,
        'pe': null,
      });
      cloud.storage.uploads.clear();
      cloud.storage.buckets['fsn1']!['media']!.objects['x'] = FakeObject(1)
        ..etag = '"j-2"'
        ..modified = DateTime.now().toUtc();
      await transfers.retryJoins();
      expect(events, [(upload: true, ok: true, name: 'x')]);
    });

    test('an older multipart object does not pass for a lost join', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      final events = <TransferEvent>[];
      transfers.events.listen(events.add);
      for (final before in [
        {'pe': '"old-2"'},
        // Unknown what the key held: not taken as joined.
        <String, Object?>{},
      ]) {
        await job(c, 'x1', {
          'e': true,
          't': DateTime.now().millisecondsSinceEpoch,
          ...before,
        });
        // The upload is gone; at the key is an object of an earlier one,
        // written just now (a lifecycle rule may touch it).
        cloud.storage.uploads.clear();
        cloud.storage.buckets['fsn1']!['media']!.objects['x'] = FakeObject(1)
          ..etag = '"old-2"'
          ..modified = DateTime.now().toUtc();
        await transfers.retryJoins();
      }
      expect(events, [
        (upload: true, ok: false, name: 'x'),
        (upload: true, ok: false, name: 'x'),
      ]);
    });

    test('an unreadable job does not hold up the others', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider);
      final root = await transfers.jobsRoot();
      File('$root/a.json')
        ..createSync(recursive: true)
        ..writeAsStringSync('{"u":');
      await job(c, 'x1', {});
      await transfers.retryJoins();
      expect(cloud.storage.uploads, isEmpty);
      expect(File('$root/a.json').existsSync(), isTrue);
    });

    test('a parked join is retried after the unlock', () async {
      final cloud = storageCloud()..storage.failJoin = 1;
      final c = await fakeContainer(
        cloud,
        s3: true,
        overrides: [authenticatorProvider.overrideWithValue((_) async => true)],
      );
      final transfers = c.read(transfersProvider);
      var event = transfers.events.first;
      await transfers.upload(
        projectId: 'p1',
        location: 'fsn1',
        bucket: 'media',
        key: 'big.bin',
        file: tempFile('big.bin', 'x' * 20),
        contentType: 'application/octet-stream',
      );
      expect(await event, (upload: true, ok: false, name: 'big.bin'));
      event = transfers.events.first;
      await c.read(appLockProvider.notifier).unlock('test');
      expect(await event, (upload: true, ok: true, name: 'big.bin'));
    });

    test('download names have no backslash and fit the file system', () {
      expect(downloadName(r'a\b.txt', null), 'a_b.txt');
      expect(downloadDirectory('media', r'x\y/a.txt'), 'media/x_y');
      final long = downloadName('${'ä' * 300}.txt', 'v1');
      expect(utf8.encode(long).length, lessThanOrEqualTo(255));
      expect(long, endsWith('.txt'));
      final tagged = downloadName('${'a' * 300}.txt', 'v1');
      expect(tagged, endsWith(' (v1).txt'));
      expect(utf8.encode(tagged).length, 255);
    });

    test('downloads of the same name do not replace each other', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final transfers = c.read(transfersProvider) as FakeTransfers;
      for (final (key, version) in [
        ('a.txt', null),
        ('docs/a.txt', null),
        ('docs/a.txt', 'v0'),
      ]) {
        await transfers.download(
          projectId: 'p1',
          location: 'fsn1',
          bucket: 'media',
          key: key,
          versionId: version,
        );
      }
      expect(
        [
          for (final t in transfers.downloadTasks)
            '${t.directory}/${t.filename}',
        ],
        ['media/a.txt', 'media/docs/a.txt', 'media/docs/a (v0).txt'],
      );
    });

    test('a download that cannot be kept is reported as failed', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud, s3: true);
      final transfers = (c.read(transfersProvider) as FakeTransfers)
        ..keeps = false;
      final event = transfers.events.first;
      await transfers.download(
        projectId: 'p1',
        location: 'fsn1',
        bucket: 'media',
        key: 'logo.png',
      );
      expect(await event, (upload: false, ok: false, name: 'logo.png'));
    });
  });

  group('S3', () {
    Future<T> s3<T>(FakeCloud cloud, Future<T> Function(S3Client c) f) async {
      final c = await fakeContainer(cloud, s3: true);
      return await c.read(s3AccessProvider).run('p1', 'fsn1', f);
    }

    test('keys with empty segments reach S3 as signed', () async {
      final cloud = storageCloud();
      await s3(cloud, (c) async {
        await c.put('media', 'a//b.txt', [1]);
        await c.head('media', 'a//b.txt');
      });
      final objects = cloud.storage.buckets['fsn1']!['media']!.objects;
      expect(objects['a//b.txt']!.size, 1);
      expect([
        for (final r in cloud.adapter.requests) r.uri.path,
      ], everyElement('/media/a//b.txt'));
    });

    test('keys with dot segments are refused or deleted by name', () async {
      expect(validKey('a/../b'), isFalse);
      expect(validKey('a/./b'), isFalse);
      expect(validKey('/a'), isFalse);
      expect(validKey('a..b/.c'), isTrue);
      final cloud = storageCloud();
      final objects = cloud.storage.buckets['fsn1']!['media']!.objects
        ..['x/../notes.txt'] = FakeObject(1);
      await expectLater(
        s3(cloud, (c) => c.head('media', 'x/../notes.txt')),
        throwsA(isA<Invalid>().having((e) => e.code, 'code', dotSegmentKey)),
      );
      expect(cloud.adapter.requests, isEmpty);
      await s3(cloud, (c) => c.delete('media', 'x/../notes.txt'));
      expect(objects, isNot(contains('x/../notes.txt')));
      expect(objects, contains('notes.txt'));
    });

    test('an empty body is sent as the bytes that were hashed', () async {
      final cloud = storageCloud();
      await s3(cloud, (c) => c.put('media', 'new/', const []));
      expect(cloud.adapter.bodies.single, isEmpty);
      expect(cloud.storage.buckets['fsn1']!['media']!.objects['new/']!.size, 0);
    });

    test('versions are read from every page', () async {
      final cloud = storageCloud();
      cloud.storage.versionPage = 1;
      final media = cloud.storage.buckets['fsn1']!['media']!;
      media.objects['notes.txt']!.older.addAll([('v0b', 2), ('v0a', 1)]);
      media.objects['notes.txt.bak'] = FakeObject(5);
      media.objects['notes.txt.old'] = FakeObject(5);
      final versions = await s3(cloud, (c) => c.versions('media', 'notes.txt'));
      expect([for (final v in versions) v.size], [64, 2, 1]);
      // Stops at the first other key.
      expect(cloud.adapter.requests, hasLength(4));
    });

    test('a copy failing in a 200 body throws', () async {
      final cloud = storageCloud();
      cloud.storage.failCopy = true;
      await expectLater(
        s3(cloud, (c) => c.copy('media', 'notes.txt', 'media', 'n.txt')),
        throwsA(isA<Server>()),
      );
    });

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
