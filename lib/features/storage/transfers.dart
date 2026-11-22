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
import 'package:falco/core/errors/falco_error.dart';
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
  new(
    S3Access s3, {
    this.onUploaded,
    this.partSize = defaultPartSize,
    String? partsRoot,
    this._jobsRoot,
  }) : _s3 = s3,
       partsRoot = partsRoot ?? '${Directory.systemTemp.path}/falco-parts';

  /// Folder of the part copies, one folder per multipart upload until it
  /// is joined or aborted.
  final String partsRoot;

  final String? _jobsRoot;

  /// Size of upload parts; larger files upload in parts (OBJ-022).
  final int partSize;

  final S3Access _s3;

  /// Called after an upload landed (refreshes listings).
  final VoidCallback? onUploaded;

  final _events = StreamController<TransferEvent>.broadcast();

  /// Multipart uploads already joined or aborted.
  final _completing = <String>{};

  /// Multipart uploads still being handed to the platform.
  final _starting = <String>{};

  /// Part events per upload, handled one after the other so two parts
  /// finishing together neither join twice nor both see the other
  /// missing.
  final _joins = <String, Future<void>>{};
  Future<void>? _started;

  /// Finished transfers.
  Stream<TransferEvent> get events => _events.stream;

  /// Folder of the multipart jobs (`<name>.json`) until they are joined
  /// or aborted. Application support, not temporary space: the system
  /// clears that, and a job lost there leaves billed parts behind.
  Future<String> jobsRoot() async =>
      _jobsRoot ??
      '${await Task.baseDirectoryPath(BaseDirectory.applicationSupport)}'
          '/falco-uploads';

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
    // The notification permission is asked by the screen (SET-025).
    await start();
    final ok = await FileDownloader().enqueueAll(tasks);
    if (ok.contains(false)) throw StateError('enqueue failed');
  }

  /// Puts a finished download where the user finds it: Downloads on
  /// Android, Falco's folder in the Files app on iOS (OBJ-012). False when
  /// it could not be moved.
  @protected
  Future<bool> keep(DownloadTask task) async =>
      !Platform.isAndroid ||
      await FileDownloader().moveToSharedStorage(
            task,
            SharedStorage.downloads,
          ) !=
          null;

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
      // An empty Content-Disposition keeps background_downloader from
      // sending `attachment`, which S3 would store with the object.
      headers: {'Content-Type': contentType, 'Content-Disposition': ''},
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
    final created = DateTime.now().millisecondsSinceEpoch;
    final uploadId = await _s3.run(
      projectId,
      location,
      (c) => c.createMultipart(bucket, key, contentType),
    );
    final name = '${uploadId.hashCode}';
    final parts = (size / partSize).ceil();
    final job = {...meta, 'u': uploadId, 'n': parts, 'd': name, 't': created};
    final jobFile = await _jobFile(name);
    _starting.add(uploadId);
    try {
      // What a later join or abort needs (S3 keys stay in the store).
      // Without the enqueued mark retryJoins aborts it: Falco was closed
      // before the parts were handed over.
      await jobFile.parent.create(recursive: true);
      await jobFile.writeAsString(jsonEncode(job));
      final dir = await Directory('$partsRoot/$name').create(recursive: true);
      // ponytail: parts are copies, so a large upload needs its size again
      // in temporary space until it is joined.
      await enqueue([
        for (var n = 1; n <= parts; n++)
          await task(await _part(file, n, dir), {
            'partNumber': '$n',
            'uploadId': uploadId,
          }, job),
      ]);
      // In line with the part events: a job already joined stays gone.
      await _queue(uploadId, () async {
        if (jobFile.existsSync()) {
          await jobFile.writeAsString(jsonEncode({...job, 'e': true}));
        }
      });
    } on Object {
      await _queue(
        uploadId,
        () => _joinParts(job, uploadId, ok: false, report: false),
      );
      rethrow;
    } finally {
      _starting.remove(uploadId);
    }
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

  Future<File> _jobFile(String name) async =>
      File('${await jobsRoot()}/$name.json');

  /// Downloads [key] (or one version of it) in the background (OBJ-012,
  /// OBJ-021, OBJ-023).
  Future<void> download({
    required String projectId,
    required String location,
    required String bucket,
    required String key,
    String? versionId,
  }) async {
    // Android 9 and older need the storage permission to move it to
    // Downloads; asked now, while the user is here.
    if (Platform.isAndroid) {
      await FileDownloader().permissions.request(
        PermissionType.androidSharedStorage,
      );
    }
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
        directory: downloadDirectory(bucket, key),
        filename: downloadName(key, versionId),
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
      final kept = ok && await keep(task);
      _events.add((upload: false, ok: kept, name: name));
      return;
    }
    if (meta['u'] case final String uploadId) {
      await _queue(uploadId, () => _joinParts(meta, uploadId, ok: ok));
      return;
    }
    if (ok) onUploaded?.call();
    _events.add((upload: true, ok: ok, name: name));
  }

  Future<void> _queue(String uploadId, Future<void> Function() f) {
    final next = (_joins[uploadId] ?? Future<void>.value()).then((_) => f());
    _joins[uploadId] = next;
    return next;
  }

  /// Joins (or aborts) multipart uploads whose join failed before, e.g.
  /// offline or before the unlock, and aborts those Falco never handed to
  /// the platform (OBJ-022).
  Future<void> retryJoins() async {
    final root = Directory(await jobsRoot());
    if (!root.existsSync()) return;
    await for (final file in root.list()) {
      if (file is! File || !file.path.endsWith('.json')) continue;
      final job = (jsonDecode(await file.readAsString()) as Map)
          .cast<String, Object?>();
      final id = job['u']! as String;
      if (_starting.contains(id)) continue;
      final abort = job['abort'] == true || job['e'] != true;
      await _queue(id, () => _joinParts(job, id, ok: !abort, report: !abort));
    }
  }

  Future<void> _joinParts(
    Map<String, Object?> m,
    String uploadId, {
    required bool ok,
    bool report = true,
  }) async {
    if (_completing.contains(uploadId)) return;
    final (p, l, b, k) = (
      m['p']! as String,
      m['l']! as String,
      m['b']! as String,
      m['k']! as String,
    );
    _completing.add(uploadId);
    var aborting = false;
    final bool joined;
    try {
      final j = ok ? await _join(m, uploadId) : false;
      if (j == null) {
        _completing.remove(uploadId);
        return;
      }
      joined = j;
      if (!joined) {
        // Giving up: abort first, so S3 keeps no billed parts. The job
        // stays until S3 dropped them.
        aborting = true;
        try {
          await _s3.run(p, l, (c) => c.abortMultipart(b, k, uploadId));
        } on NotFound catch (_) {}
      }
    } on Object catch (e) {
      // Kept for retryJoins: offline, locked, a server error. Without
      // keys (Unauthorized) the job waits silently until they are back.
      // ponytail: a server error that never ends keeps the parts in
      // temporary space; add a retry limit if that shows up.
      _completing.remove(uploadId);
      final file = await _jobFile(m['d']! as String);
      if (aborting && file.existsSync()) {
        await file.writeAsString(jsonEncode({...m, 'abort': true}));
      }
      if (report && e is! Unauthorized) {
        _events.add((upload: true, ok: false, name: baseName(k)));
      }
      return;
    }
    await _remove(m['d']! as String);
    if (joined) onUploaded?.call();
    if (report) _events.add((upload: true, ok: joined, name: baseName(k)));
  }

  /// Joins the parts of [m]: true once joined, null while parts are
  /// still coming, false when S3 refused for good.
  Future<bool?> _join(Map<String, Object?> m, String uploadId) async {
    final (p, l, b, k) = (
      m['p']! as String,
      m['l']! as String,
      m['b']! as String,
      m['k']! as String,
    );
    final created = switch (m['t']) {
      final int t => DateTime.fromMillisecondsSinceEpoch(t),
      _ => null,
    };
    try {
      final parts = await _s3.run(p, l, (c) => c.parts(b, k, uploadId));
      if (parts.length < (m['n']! as int)) {
        // Past the link expiry the missing parts never come.
        return created != null &&
                DateTime.now().difference(created) > transferLinkExpiry
            ? false
            : null;
      }
      await _s3.run(p, l, (c) => c.completeMultipart(b, k, uploadId, parts));
      return true;
    } on NotFound catch (_) {
      // Gone: joined by a join whose answer was lost, or dropped. The
      // object tells: a multipart ETag (`"…-n"`) or written after the job.
      try {
        final o = await _s3.run(p, l, (c) => c.head(b, k));
        return (o.etag ?? '').contains('-') ||
            (created != null && (o.modified?.isAfter(created) ?? false));
      } on NotFound catch (_) {
        return false;
      }
    } on Invalid catch (_) {
      return false;
    } on Forbidden catch (_) {
      return false;
    } on Conflict catch (_) {
      return false;
    }
  }

  Future<void> _remove(String name) async {
    for (final e in <FileSystemEntity>[
      Directory('$partsRoot/$name'),
      await _jobFile(name),
    ]) {
      try {
        await e.delete(recursive: true);
      } on FileSystemException catch (_) {}
    }
  }
}

/// [name] as a file or folder name: no `\` (a path separator to
/// background_downloader) and at most 255 bytes, the extension kept.
String _safeName(String name) {
  final s = name.replaceAll(r'\', '_');
  final dot = s.lastIndexOf('.');
  final ext = dot > 0 && s.length - dot <= 16 ? s.substring(dot) : '';
  final base = s.substring(0, s.length - ext.length).runes.toList();
  while (utf8.encode(String.fromCharCodes(base) + ext).length > 255) {
    base.removeLast();
  }
  return String.fromCharCodes(base) + ext;
}

/// Folder of a download below Falco's documents: one per bucket and
/// prefix, so objects of the same name do not replace each other.
String downloadDirectory(String bucket, String key) => [
  bucket,
  ...(key.split('/')..removeLast()),
].where((s) => s.isNotEmpty).map(_safeName).join('/');

/// File name of a download; an older version gets its id, so it does not
/// replace the current one.
String downloadName(String key, String? versionId) {
  final name = baseName(key);
  if (versionId == null) return _safeName(name);
  final dot = name.lastIndexOf('.');
  return _safeName(
    dot <= 0
        ? '$name ($versionId)'
        : '${name.substring(0, dot)} ($versionId)${name.substring(dot)}',
  );
}

/// The app's transfers; finished uploads refresh the listings.
@Riverpod(keepAlive: true)
ObjectTransfers transfers(Ref ref) => ObjectTransfers(
  ref.watch(s3AccessProvider),
  onUploaded: () => ref.invalidate(objectsProvider),
);

/// Finished transfers, for the snackbar of the object browser.
/// Watching them (the object browser, after the unlock) also retries
/// pending joins.
@riverpod
Stream<TransferEvent> transferEvents(Ref ref) {
  final transfers = ref.watch(transfersProvider);
  unawaited(transfers.retryJoins().catchError((Object _) {}));
  return transfers.events;
}
