// SPDX-License-Identifier: GPL-3.0-or-later
/// Uploads and downloads of Object Storage that keep running when Falco
/// is in the background or closed (OBJ-007, OBJ-009, OBJ-012, OBJ-021,
/// OBJ-022).
///
/// background_downloader hands each transfer to the platform: on Android
/// 14+ a User Initiated Data Transfer job (no time limit, visible
/// notification), WorkManager before that; on iOS a background
/// `URLSession`. Native transfers cannot use Dart's pinned TLS, so they
/// get presigned links (no keys leave Falco) and the native pins of
/// `network_security_config.xml` and `NSPinnedDomains`. Large files upload
/// as S3 multipart: one native task per part, joined when all are done.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transfers.g.dart';

/// Files above this size upload in parts of this size (OBJ-022).
const int defaultPartSize = 64 * 1024 * 1024;

/// Validity of the links native transfers use; a queued task may wait.
const transferLinkExpiry = Duration(hours: 24);

/// A finished transfer for the screen's snackbar.
typedef TransferEvent = ({bool upload, bool ok, String name});

/// Starts and finishes background transfers.
class ObjectTransfers {
  new(S3Access s3, {this.onUploaded, this.partSize = defaultPartSize})
    : _s3 = s3;

  /// Size of upload parts; larger files upload in parts (OBJ-022).
  final int partSize;

  final S3Access _s3;

  /// Called after an upload landed (refreshes listings).
  final VoidCallback? onUploaded;

  final _events = StreamController<TransferEvent>.broadcast();

  /// Multipart uploads already joined or aborted.
  final _completing = <String>{};

  /// Part events per upload, handled one after the other so two parts
  /// finishing together neither join twice nor both see the other
  /// missing.
  final _joins = <String, Future<void>>{};
  Future<void>? _started;

  /// Finished transfers.
  Stream<TransferEvent> get events => _events.stream;

  /// Connects to the platform's transfers, including those that finished
  /// while Falco was closed. Safe to call more than once.
  Future<void> start() => _started ??= _start();

  Future<void> _start() async {
    final l10n = lookupAppLocalizations(
      AppLocalizations.supportedLocales.firstWhere(
        (l) =>
            l.languageCode == PlatformDispatcher.instance.locale.languageCode,
        orElse: () => const Locale('en'),
      ),
    );
    final d = FileDownloader()
      ..configureNotification(
        running: TaskNotification(l10n.transferRunning, '{displayName}'),
        complete: TaskNotification(l10n.transferDone, '{displayName}'),
        error: TaskNotification(l10n.transferFailed, '{displayName}'),
        progressBar: true,
      );
    d.updates.listen((u) {
      if (u is TaskStatusUpdate) unawaited(onStatus(u));
    });
    await d.start(autoCleanDatabase: true);
  }

  /// Hands [tasks] to the platform.
  @protected
  Future<void> enqueue(List<Task> tasks) async {
    await start();
    await FileDownloader().permissions.request(PermissionType.notifications);
    final ok = await FileDownloader().enqueueAll(tasks);
    if (ok.contains(false)) throw StateError('enqueue failed');
  }

  /// Puts a finished download where the user finds it: Downloads on
  /// Android, Falco's folder in the Files app on iOS (OBJ-012).
  @protected
  Future<void> keep(DownloadTask task) async {
    if (Platform.isAndroid) {
      await FileDownloader().moveToSharedStorage(task, SharedStorage.downloads);
    }
  }

  /// Uploads [file] to [key] in the background (OBJ-007, OBJ-022).
  Future<void> upload({
    required String projectId,
    required String location,
    required String bucket,
    required String key,
    required File file,
    required String contentType,
  }) async {
    final size = await file.length();
    final meta = {'p': projectId, 'l': location, 'b': bucket, 'k': key};
    Future<UploadTask> task(
      File f,
      Map<String, String>? query,
      Object m,
    ) async => UploadTask.fromFile(
      file: f,
      url: '${await _link(projectId, location, bucket, key, query)}',
      httpRequestMethod: 'PUT',
      mimeType: contentType,
      headers: {'Content-Type': contentType},
      displayName: baseName(key),
      metaData: jsonEncode(m),
      group: 'upload',
      retries: 3,
      transferHints: const {
        TransferHint.binaryUpload,
        TransferHint.userInitiated,
      },
    );
    if (size <= partSize) {
      await enqueue([await task(file, null, meta)]);
      return;
    }
    final uploadId = await _s3.run(
      projectId,
      location,
      (c) => c.createMultipart(bucket, key, contentType),
    );
    final parts = (size / partSize).ceil();
    final dir = await Directory(
      '${Directory.systemTemp.path}/falco-parts/${uploadId.hashCode}',
    ).create(recursive: true);
    // ponytail: parts are copies, so a large upload needs its size again
    // in temporary space until it is joined.
    await enqueue([
      for (var n = 1; n <= parts; n++)
        await task(
          await _part(file, n, dir),
          {'partNumber': '$n', 'uploadId': uploadId},
          {...meta, 'u': uploadId, 'n': parts, 'd': dir.path},
        ),
    ]);
  }

  Future<Uri> _link(
    String projectId,
    String location,
    String bucket,
    String key,
    Map<String, String>? query,
  ) => _s3.presign(
    projectId,
    location,
    'PUT',
    bucket,
    key,
    expires: transferLinkExpiry,
    query: query,
  );

  Future<File> _part(File file, int n, Directory dir) async {
    final part = File('${dir.path}/$n');
    final start = (n - 1) * partSize;
    await file.openRead(start, start + partSize).pipe(part.openWrite());
    return part;
  }

  /// Downloads [key] (or one version of it) in the background (OBJ-012,
  /// OBJ-021, OBJ-023).
  Future<void> download({
    required String projectId,
    required String location,
    required String bucket,
    required String key,
    String? versionId,
  }) async {
    final url = await _s3.presign(
      projectId,
      location,
      'GET',
      bucket,
      key,
      expires: transferLinkExpiry,
      query: versionId == null ? null : {'versionId': versionId},
    );
    await enqueue([
      DownloadTask(
        url: '$url',
        filename: baseName(key),
        displayName: baseName(key),
        group: 'download',
        updates: Updates.statusAndProgress,
        retries: 3,
        metaData: jsonEncode({'k': key}),
        transferHints: const {
          TransferHint.userInitiated,
          TransferHint.largeFile,
        },
      ),
    ]);
  }

  /// Handles a status change: joins finished multipart uploads, keeps
  /// downloads and reports finished transfers.
  @visibleForTesting
  Future<void> onStatus(TaskStatusUpdate u) async {
    if (!u.status.isFinalState) return;
    final ok = u.status == TaskStatus.complete;
    final meta = (jsonDecode(u.task.metaData) as Map).cast<String, Object?>();
    final name = baseName(meta['k']! as String);
    final task = u.task;
    if (task is DownloadTask) {
      if (ok) await keep(task);
      _events.add((upload: false, ok: ok, name: name));
      return;
    }
    if (meta['u'] case final String uploadId) {
      final next = (_joins[uploadId] ?? Future<void>.value()).then(
        (_) => _joinParts(meta, uploadId, ok: ok),
      );
      _joins[uploadId] = next;
      await next;
      return;
    }
    if (ok) onUploaded?.call();
    _events.add((upload: true, ok: ok, name: name));
  }

  Future<void> _joinParts(
    Map<String, Object?> m,
    String uploadId, {
    required bool ok,
  }) async {
    if (_completing.contains(uploadId)) return;
    final (p, l, b, k) = (
      m['p']! as String,
      m['l']! as String,
      m['b']! as String,
      m['k']! as String,
    );
    var done = false;
    try {
      if (!ok) {
        _completing.add(uploadId);
        await _s3.run(p, l, (c) => c.abortMultipart(b, k, uploadId));
      } else {
        final parts = await _s3.run(p, l, (c) => c.parts(b, k, uploadId));
        if (parts.length < (m['n']! as int)) return;
        _completing.add(uploadId);
        await _s3.run(p, l, (c) => c.completeMultipart(b, k, uploadId, parts));
        done = true;
      }
    } on Object {
      done = false;
    }
    await Directory(m['d']! as String)
        .delete(recursive: true)
        .catchError((Object _) => Directory(''));
    if (done) onUploaded?.call();
    _events.add((upload: true, ok: done, name: baseName(k)));
  }
}

/// The app's transfers; finished uploads refresh the listings.
@Riverpod(keepAlive: true)
ObjectTransfers transfers(Ref ref) => ObjectTransfers(
  ref.watch(s3AccessProvider),
  onUploaded: () => ref.invalidate(objectsProvider),
);

/// Finished transfers, for the snackbar of the object browser.
@riverpod
Stream<TransferEvent> transferEvents(Ref ref) =>
    ref.watch(transfersProvider).events;
