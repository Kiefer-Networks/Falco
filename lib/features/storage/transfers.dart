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

import 'package:android_file_picker/android_file_picker.dart'
    show FilePickerAndroid;
import 'package:background_downloader/background_downloader.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/files/text_files.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart' show FilePickerPlatform;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transfers.g.dart';

/// Files above this size upload in parts of this size (OBJ-022).
const int defaultPartSize = 64 * 1024 * 1024;

/// Validity of the links native transfers use; a queued task may wait.
const transferLinkExpiry = Duration(hours: 24);

/// Time after the first refusal after which a join S3 keeps refusing
/// (rotated or removed keys) is given up: an abort is tried, the parts
/// that stay go with S3's lifecycle, the local copies and the job go.
const refusedJoinLimit = Duration(days: 4);

/// A finished transfer for the screen's snackbar.
typedef TransferEvent = ({bool upload, bool ok, String name});

/// Starts and finishes background transfers.
class ObjectTransfers {
  new(
    S3Access s3, {
    this.onUploaded,
    this.partSize = defaultPartSize,
    this._partsRoot,
    this._jobsRoot,
  }) : _s3 = s3;

  final String? _partsRoot;
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

  /// Multipart uploads whose kept join failure was reported already.
  final _keptReported = <String>{};

  /// Buckets with an object browser open, with their count.
  final _open = <String, int>{};

  /// Part events per upload, handled one after the other so two parts
  /// finishing together neither join twice nor both see the other
  /// missing.
  final _joins = <String, Future<void>>{};
  Future<void>? _started;

  /// Finished transfers.
  Stream<TransferEvent> get events => _events.stream;

  /// Finished transfers no screen showed yet, oldest first, with their
  /// bucket: the object browser of that bucket on top takes them, a sheet
  /// over it defers them. One that finished while no browser of its bucket
  /// was open has no bucket, so the next object browser shows it: a failed
  /// upload joined in the background is never silent.
  final _unseen = <({String? bucket, TransferEvent event})>[];

  /// Whether [bucket]'s object browser has transfers to show.
  bool hasUnseen(String bucket) =>
      _unseen.any((u) => u.bucket == null || u.bucket == bucket);

  /// Takes the transfers [bucket]'s object browser shows.
  List<TransferEvent> takeUnseen(String bucket) {
    final taken = [
      for (final u in _unseen)
        if (u.bucket == null || u.bucket == bucket) u.event,
    ];
    _unseen.removeWhere((u) => u.bucket == null || u.bucket == bucket);
    return taken;
  }

  /// Marks an object browser of [bucket] as open until [closeBucket].
  void openBucket(String bucket) => _open[bucket] = (_open[bucket] ?? 0) + 1;

  /// Marks one object browser of [bucket] as closed.
  void closeBucket(String bucket) {
    final n = (_open[bucket] ?? 1) - 1;
    if (n > 0) {
      _open[bucket] = n;
    } else {
      _open.remove(bucket);
    }
  }

  void _report(TransferEvent e, String? bucket) {
    final shown = _open.containsKey(bucket);
    _unseen.add((bucket: shown ? bucket : null, event: e));
    // ponytail: bounded, the oldest go first; nobody reads more.
    if (_unseen.length > 20) _unseen.removeAt(0);
    _events.add(e);
  }

  /// The app's language for the notifications; null follows the system.
  String? get language => _language;
  String? _language;
  set language(String? value) {
    _language = value;
    if (_started != null) _notifications();
  }

  void _notifications() {
    final code = _language ?? PlatformDispatcher.instance.locale.languageCode;
    final l10n = lookupAppLocalizations(
      AppLocalizations.supportedLocales.firstWhere(
        (l) => l.languageCode == code,
        orElse: () => const Locale('en'),
      ),
    );
    FileDownloader().configureNotification(
      running: TaskNotification(l10n.transferRunning, '{displayName}'),
      complete: TaskNotification(l10n.transferDone, '{displayName}'),
      error: TaskNotification(l10n.transferFailed, '{displayName}'),
      progressBar: true,
    );
  }

  /// Folder of the multipart jobs (`<name>.json`) until they are joined
  /// or aborted. Application support, not temporary space: the system
  /// clears that, and a job lost there leaves billed parts behind.
  Future<String> jobsRoot() async =>
      _jobsRoot ??
      '${await Task.baseDirectoryPath(BaseDirectory.applicationSupport)}'
          '/falco-uploads';

  /// Folder of the part copies, one folder per multipart upload until it
  /// is joined or aborted. Application support too: Android empties
  /// temporary space on each app update, while parts still upload.
  Future<String> partsRoot() async =>
      _partsRoot ??
      '${await Task.baseDirectoryPath(BaseDirectory.applicationSupport)}'
          '/falco-parts';

  /// Connects to the platform's transfers, including those that finished
  /// while Falco was closed. Safe to call more than once.
  Future<void> start() => _started ??= _start();

  Future<void> _start() async {
    _notifications();
    final d = FileDownloader();
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
    if (size == 0) {
      // The platform refuses to send an empty file: put directly.
      await _s3.run(
        projectId,
        location,
        (c) => c.put(bucket, key, const [], contentType: contentType),
      );
      await dropUploadCopy(file.path);
      onUploaded?.call();
      _report((upload: true, ok: true, name: baseName(key)), bucket);
      return;
    }
    if (size <= partSize) {
      // With its source, to drop the picker's copy once it finished.
      await enqueue([
        await task(file, null, {...meta, 's': file.path}),
      ]);
      return;
    }
    final created = DateTime.now().millisecondsSinceEpoch;
    // The object at the key before: a vanished upload counts as joined
    // only when the key holds another one since.
    final before = <String, Object?>{};
    try {
      final o = await _s3.run(projectId, location, (c) => c.head(bucket, key));
      before['pe'] = o.etag;
      before['pm'] = o.modified?.millisecondsSinceEpoch;
    } on NotFound catch (_) {
      before['pe'] = null;
    } on Object catch (_) {
      // Unknown: a vanished upload then counts as joined only by an
      // object written since it started.
      before['pu'] = true;
    }
    final uploadId = await _s3.run(
      projectId,
      location,
      (c) => c.createMultipart(bucket, key, contentType),
    );
    final name = '${uploadId.hashCode}';
    final parts = (size / partSize).ceil();
    final job = {
      ...meta,
      ...before,
      'u': uploadId,
      'n': parts,
      'd': name,
      't': created,
    };
    final jobFile = await _jobFile(name);
    _starting.add(uploadId);
    try {
      // What a later join or abort needs (S3 keys stay in the store).
      // Without the enqueued mark retryJoins aborts it: Falco was closed
      // before the parts were handed over.
      await jobFile.parent.create(recursive: true);
      await _write(jobFile, job);
      final dir = await Directory('${await partsRoot()}/$name')
          .create(recursive: true);
      // ponytail: parts are copies, so a large upload needs its size again
      // in app storage until it is joined.
      await enqueue([
        for (var n = 1; n <= parts; n++)
          await task(await _part(file, n, dir), {
            'partNumber': '$n',
            'uploadId': uploadId,
          }, job),
      ]);
      // The parts are copies: the picked file is no longer needed.
      await dropUploadCopy(file.path);
      // In line with the part events: a job already joined stays gone.
      await _queue(uploadId, () async {
        if (jobFile.existsSync()) {
          await _write(jobFile, {...await _readJob(jobFile), 'e': true});
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

  /// Writes job [m] to [file] whole or not at all: a job cut short by the
  /// app ending would stop every later retry.
  Future<void> _write(File file, Map<String, Object?> m) async {
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(jsonEncode(m), flush: true);
    await tmp.rename(file.path);
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
        metaData: jsonEncode({'b': bucket, 'k': key}),
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
      _report((upload: false, ok: kept, name: name), meta['b'] as String?);
      return;
    }
    // The file a finished upload sent is no longer needed: a part copy,
    // or the picker's copy of the picked file.
    if (meta['u'] case final String uploadId) {
      final part = Uri.parse(task.url).queryParameters['partNumber'];
      final dir = meta['d'];
      if (part != null && dir is String) {
        try {
          await File('${await partsRoot()}/$dir/$part').delete();
        } on FileSystemException catch (_) {}
      }
      await _queue(uploadId, () => _joinParts(meta, uploadId, ok: ok));
      return;
    }
    await dropUploadCopy(meta['s'] as String?);
    if (ok) onUploaded?.call();
    _report((upload: true, ok: ok, name: name), meta['b'] as String?);
  }

  /// Runs [f] after the work queued for [uploadId] before it; one that
  /// failed does not stop the next.
  Future<void> _queue(String uploadId, Future<void> Function() f) {
    final next = (_joins[uploadId] ?? Future<void>.value()).then((_) => f());
    final tail = next.catchError((Object _) {});
    _joins[uploadId] = tail;
    unawaited(
      tail.then((_) => _joins.removeWhere((_, v) => identical(v, tail))),
    );
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
      // One unreadable job must not hold up the others.
      try {
        final id = (await _readJob(file))['u']! as String;
        if (_starting.contains(id)) continue;
        // Read again in line with the upload: it may have handed its parts
        // over (or been joined) since.
        await _queue(id, () async {
          if (_starting.contains(id) || !file.existsSync()) return;
          final job = await _readJob(file);
          final abort = job['abort'] == true || job['e'] != true;
          await _joinParts(
            job,
            id,
            ok: !abort,
            report: !abort,
            reportKept: false,
          );
        });
      } on Object catch (_) {
        continue;
      }
    }
  }

  Future<Map<String, Object?>> _readJob(File file) async =>
      (jsonDecode(await file.readAsString()) as Map).cast<String, Object?>();

  /// Joins or aborts upload [m]. [report] tells its outcome; a failure
  /// that keeps the job for a retry only when [reportKept] too, so a
  /// parked join does not report a failure on each retry.
  Future<void> _joinParts(
    Map<String, Object?> m,
    String uploadId, {
    required bool ok,
    bool report = true,
    bool reportKept = true,
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
    // Whether S3 listed every part: the upload could be complete then.
    var listed = false;
    final bool joined;
    try {
      final j = ok ? await _join(m, uploadId, () => listed = true) : false;
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
      // Kept for retryJoins: offline, locked, refused (rotated keys, a
      // wrong clock), a server error. Without keys (Unauthorized) or while
      // the app is locked (Locked) the job waits silently until they are
      // back.
      // ponytail: a server error that never ends keeps the parts in app
      // storage; add a retry limit if that shows up.
      _completing.remove(uploadId);
      final file = await _jobFile(m['d']! as String);
      if (aborting && file.existsSync()) {
        await _write(file, {...m, 'abort': true});
      }
      final error = toFalcoError(e);
      if (error is Forbidden && await _refusedTooLong(file, error)) {
        // Refused for good: give up once, the local copies go.
        _completing.add(uploadId);
        try {
          await _s3.run(p, l, (c) => c.abortMultipart(b, k, uploadId));
        } on Object catch (_) {
          // Refused too, most likely: S3's lifecycle drops the parts.
        }
        await _remove(m['d']! as String);
        _keptReported.remove(uploadId);
        if (report) _report((upload: true, ok: false, name: baseName(k)), b);
        return;
      }
      // A parked join reports once, not on each part event, and only once
      // the upload could be complete: a part listing failing while other
      // parts still upload stays silent.
      if (report &&
          reportKept &&
          error is! Unauthorized &&
          error is! Locked &&
          (aborting || listed || !await _partsLeft(m['d']! as String)) &&
          _keptReported.add(uploadId)) {
        _report((upload: true, ok: false, name: baseName(k)), b);
      }
      return;
    }
    await _remove(m['d']! as String);
    _keptReported.remove(uploadId);
    if (joined) onUploaded?.call();
    if (report) _report((upload: true, ok: joined, name: baseName(k)), b);
  }

  /// Joins the parts of [m]: true once joined, null while parts are
  /// still coming, false when S3 refused for good.
  /// [onListed] is called once S3 lists every part.
  Future<bool?> _join(
    Map<String, Object?> m,
    String uploadId,
    void Function() onListed,
  ) async {
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
      onListed();
      await _s3.run(p, l, (c) => c.completeMultipart(b, k, uploadId, parts));
      return true;
    } on NotFound catch (_) {
      // Gone: joined by a join whose answer was lost, or dropped. The
      // object tells: the multipart ETag of its part count (`"…-n"`) and
      // not the object the key held before the upload. The same content
      // again has the same ETag, then a later date tells. Without the one
      // before known, only an object written since the upload started
      // counts.
      try {
        final o = await _s3.run(p, l, (c) => c.head(b, k));
        final count = RegExp(r'-(\d+)"?$').firstMatch(o.etag ?? '')?[1];
        if (count != '${m['n']}') return false;
        final modified = o.modified?.millisecondsSinceEpoch;
        if (m.containsKey('pe')) {
          return o.etag != m['pe'] ||
              (modified != null &&
                  m['pm'] is int &&
                  modified > (m['pm']! as int));
        }
        // Last-Modified has whole seconds.
        return m['pu'] == true &&
            modified != null &&
            created != null &&
            modified ~/ 1000 >= created.millisecondsSinceEpoch ~/ 1000;
      } on NotFound catch (_) {
        return false;
      }
    } on Invalid catch (_) {
      return false;
    } on Conflict catch (_) {
      return false;
    }
  }

  /// Whether S3 has refused the join of [file] for [refusedJoinLimit]:
  /// measured from the first refusal, which the job keeps, so a device
  /// clock off by days does not count. A refusal for the device clock
  /// itself (`RequestTimeTooSkewed`) never gives up: the clock gets fixed.
  Future<bool> _refusedTooLong(File file, Forbidden error) async {
    if (error.code == 'RequestTimeTooSkewed' || !file.existsSync()) {
      return false;
    }
    final job = await _readJob(file);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (job['r'] case final int first) {
      return now - first > refusedJoinLimit.inMilliseconds;
    }
    await _write(file, {...job, 'r': now});
    return false;
  }

  /// Whether part copies of upload folder [name] wait to be sent.
  Future<bool> _partsLeft(String name) async {
    try {
      return await Directory('${await partsRoot()}/$name')
          .list()
          .any((e) => e is File);
    } on FileSystemException catch (_) {
      return false;
    }
  }

  /// Deletes picker copies an ended process left behind (a pick or save
  /// cut short, an upload source of a finished transfer), except those a
  /// transfer still sends. Run once at start.
  Future<void> dropStaleCopies() async {
    await start();
    // The folders now: a pick made while this waits is not stale.
    final stale = [
      ...await copyFolders([
        Directory('${Directory.systemTemp.path}/flutter_file_picker'),
        if (Platform.isAndroid)
          Directory(
            '${await Task.baseDirectoryPath(BaseDirectory.temporary)}'
            '/file_picker',
          ),
        await uploadCopyRoot(),
      ]),
      // Where Falco copied them before.
      ...await copyFolders([Directory.systemTemp], prefix: uploadCopyPrefix),
    ];
    if (Platform.isAndroid) {
      // Takes a pick cut short by the process end out of the plugin's
      // store, so nothing hands out its deleted copy later.
      try {
        if (FilePickerPlatform.instance case final FilePickerAndroid a) {
          await a.retrieveLostData();
        }
      } on Object catch (_) {}
    }
    // With the tasks the platform lost but background_downloader still
    // has unfinished: it enqueues them again a few seconds after start.
    final d = FileDownloader();
    final inUse = <String>{
      for (final t in [
        ...await d.allTasks(allGroups: true),
        for (final r in await d.database.allRecords())
          if (!r.status.isFinalState) r.task,
      ])
        if (t is UploadTask) await t.filePath(),
    };
    await dropUnusedCopies(stale, inUse);
  }

  Future<void> _remove(String name) async {
    for (final e in <FileSystemEntity>[
      Directory('${await partsRoot()}/$name'),
      await _jobFile(name),
    ]) {
      try {
        await e.delete(recursive: true);
      } on FileSystemException catch (_) {}
    }
  }
}

/// [name] as a file or folder name: no `\` (a path separator to
/// background_downloader) and at most 255 bytes, the extension and [tag]
/// (put before the extension) kept.
String _safeName(String name, [String tag = '']) {
  final s = name.replaceAll(r'\', '_');
  final dot = s.lastIndexOf('.');
  final ext = dot > 0 && s.length - dot <= 16 ? s.substring(dot) : '';
  final base = s.substring(0, s.length - ext.length).runes.toList();
  final end = tag.replaceAll(r'\', '_') + ext;
  while (base.isNotEmpty &&
      utf8.encode(String.fromCharCodes(base) + end).length > 255) {
    base.removeLast();
  }
  return String.fromCharCodes(base) + end;
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
  return _safeName(name, versionId == null ? '' : ' ($versionId)');
}

/// The app's transfers; finished uploads refresh the listings.
@Riverpod(keepAlive: true)
ObjectTransfers transfers(Ref ref) => connectTransfers(
  ref,
  ObjectTransfers(
    ref.watch(s3AccessProvider),
    onUploaded: () => ref.invalidate(objectsProvider),
  ),
);

/// Ties [transfers] to the app: notifications in the app's language, and
/// parked joins retried whenever the app is unlocked: at start, after each
/// unlock and on each return to the foreground. Fakes in tests use it too.
ObjectTransfers connectTransfers(Ref ref, ObjectTransfers transfers) {
  ref.listen(
    appSettingsProvider.select((s) => s.language),
    (_, language) => transfers.language = language,
    fireImmediately: true,
  );
  void retry() {
    if (ref.read(appLockProvider) != AppLockState.unlocked) return;
    unawaited(transfers.retryJoins().catchError((Object _) {}));
  }

  ref.listen(appLockProvider, (_, _) => retry(), fireImmediately: true);
  final lifecycle = AppLifecycleListener(onResume: retry);
  ref.onDispose(lifecycle.dispose);
  return transfers;
}
