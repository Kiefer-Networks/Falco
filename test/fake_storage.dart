// SPDX-License-Identifier: GPL-3.0-or-later
// A fake Storage Box API (api.hetzner.com) and a fake Object Storage
// (S3) for the fake Cloud API, plus background transfers without the
// platform. Data is made up.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:falco/features/storage/transfers.dart';

import 'fake_http.dart';
import 'fake_network.dart';

const _created = '2026-02-01T10:00:00Z';

String _bucketXml(String name) =>
    '<Bucket><Name>$name</Name>'
    '<CreationDate>2026-02-01T10:00:00.000Z</CreationDate></Bucket>';

/// A complete `storage_box_type` object; [price] is monthly in fsn1.
Map<String, Object?> boxTypeJson({
  int id = 1,
  String name = 'bx11',
  int size = 1099511627776,
  String price = '3.2000',
}) => {
  'id': id,
  'name': name,
  'description': name.toUpperCase(),
  'snapshot_limit': 10,
  'automatic_snapshot_limit': 10,
  'subaccounts_limit': 100,
  'size': size,
  'prices': [
    for (final l in ['fsn1', 'hel1'])
      {
        'location': l,
        'price_hourly': {'net': '0.0050', 'gross': '0.0050'},
        'price_monthly': {'net': price, 'gross': price},
        'setup_fee': {'net': '0.0000', 'gross': '0.0000'},
      },
  ],
  'deprecation': null,
};

/// A complete `storage_box` object.
Map<String, Object?> storageBoxJson({
  required int id,
  required String name,
  String status = 'active',
  bool protect = false,
  Map<String, Object?>? plan,
}) => {
  'id': id,
  'name': name,
  'storage_box_type': boxTypeJson(),
  'location': fakeLocation,
  'access_settings': {
    'reachable_externally': false,
    'samba_enabled': false,
    'ssh_enabled': true,
    'webdav_enabled': false,
    'zfs_enabled': false,
  },
  'snapshot_plan': plan,
  'protection': {'delete': protect},
  'labels': <String, Object?>{},
  'status': status,
  'username': 'u$id',
  'server': 'u$id.your-storagebox.de',
  'system': 'FSN1-BX355',
  'stats': {
    'size': 274877906944,
    'size_data': 214748364800,
    'size_snapshots': 60129542144,
  },
  'created': _created,
};

/// A complete storage box `snapshot` object.
Map<String, Object?> boxSnapshotJson({
  required int id,
  required int box,
  String description = '',
  bool automatic = false,
}) => {
  'id': id,
  'storage_box': box,
  'name': '2026-02-0${id % 9 + 1}T03-00-00',
  'description': description,
  'labels': <String, Object?>{},
  'stats': {'size': 1073741824, 'size_filesystem': 1073741824},
  'is_automatic': automatic,
  'created': '2026-02-0${id % 9 + 1}T03:00:00Z',
};

/// A complete storage box `subaccount` object.
Map<String, Object?> subaccountJson({
  required int id,
  required int box,
  String home = 'backup',
  bool readonly = false,
  String description = '',
}) => {
  'storage_box': box,
  'id': id,
  'name': 'sub$id',
  'home_directory': home,
  'access_settings': {
    'reachable_externally': false,
    'samba_enabled': false,
    'ssh_enabled': true,
    'webdav_enabled': false,
    'readonly': readonly,
  },
  'description': description,
  'labels': <String, Object?>{},
  'username': 'u$box-sub$id',
  'server': 'u$box-sub$id.your-storagebox.de',
  'created': _created,
};

Map<String, Object?> _meta(int n) => {
  'pagination': {
    'page': 1,
    'per_page': 50,
    'previous_page': null,
    'next_page': null,
    'last_page': 1,
    'total_entries': n,
  },
};

/// One object of the fake S3.
class FakeObject {
  new(this.size, {this.version = 'v1'});

  int size;
  String version;

  /// ETag when not the default, e.g. `"j-2"` of a joined upload.
  String? etag;
  final DateTime modified = DateTime.utc(2026, 2, 3, 10);

  /// Older versions as (id, size).
  final older = <(String, int)>[];
}

/// One bucket of the fake S3.
class FakeBucket {
  new({Map<String, FakeObject>? objects}) : objects = objects ?? {};

  final Map<String, FakeObject> objects;
  String? versioning;
  bool public = false;
}

/// Storage Boxes and Object Storage in memory. Box actions start
/// `running` and end `success` on their second poll; their effect is
/// applied right away.
class FakeStorage {
  new({
    List<Map<String, Object?>>? boxes,
    Map<int, List<Map<String, Object?>>>? snapshots,
    Map<int, List<Map<String, Object?>>>? subaccounts,
    Map<String, Map<String, FakeBucket>>? buckets,
  }) : boxes = boxes ?? [],
       snapshots = snapshots ?? {},
       subaccounts = subaccounts ?? {},
       buckets = buckets ?? {};

  final List<Map<String, Object?>> boxes;
  final Map<int, List<Map<String, Object?>>> snapshots;
  final Map<int, List<Map<String, Object?>>> subaccounts;
  final actions = <Map<String, Object?>>[];
  final List<Map<String, Object?>> types = [
    boxTypeJson(),
    boxTypeJson(id: 2, name: 'bx21', size: 5497558138880, price: '10.9000'),
  ];
  final folders = ['backup', 'photos'];

  /// Buckets per location, e.g. `buckets['fsn1']['media']`.
  final Map<String, Map<String, FakeBucket>> buckets;

  /// Unfinished multipart uploads: id to (bucket, key, part sizes).
  final uploads = <String, (String, String, Map<int, int>)>{};

  /// Part size of uploads; larger files go up in parts.
  int partSize = 8;

  /// Downloads the transfers started, as presigned links.
  final downloads = <Uri>[];

  /// Joins that answer 200 with an error body before one succeeds.
  int failJoin = 0;

  /// Whether copies answer 200 with an error body.
  bool failCopy = false;

  /// Joins that succeed but whose answer is lost (a server error).
  int loseJoin = 0;

  /// Whether aborting a multipart upload fails with a server error.
  bool failAbort = false;

  /// Locations whose every S3 request fails with a server error.
  final failing = <String>{};

  /// Versions per page of a version listing.
  int versionPage = 1000;

  final _polls = <int, int>{};
  var _next = 500;

  Map<String, Object?> _action(String command, int id, [String? type]) {
    final a = {
      'id': 700 + actions.length,
      'command': command,
      'status': 'running',
      'progress': 0,
      'started': DateTime.now().toUtc().toIso8601String(),
      'finished': null,
      'resources': [
        {'id': id, 'type': type ?? 'storage_box'},
      ],
      'error': null,
    };
    actions.insert(0, a);
    return a;
  }

  (int, Object?) _started(String command, int id) =>
      (201, {'action': _action(command, id)});

  /// Answers a request to api.hetzner.com.
  (int, Object?) box(RequestOptions o) {
    final seg = o.uri.path
        .replaceFirst('/v1', '')
        .split('/')
        .skip(1)
        .map(Uri.decodeComponent)
        .toList();
    final body = o.data is String
        ? (jsonDecode(o.data as String) as Map).cast<String, Object?>()
        : const <String, Object?>{};
    Map<String, Object?>? find(String id) =>
        boxes.where((b) => '${b['id']}' == id).firstOrNull;
    List<Map<String, Object?>> of(
      Map<int, List<Map<String, Object?>>> m,
      String id,
    ) => m[int.parse(id)] ??= [];
    const notFound = (
      404,
      {
        'error': {'code': 'not_found', 'message': 'not found', 'details': null},
      },
    );
    switch ((o.method, seg)) {
      case ('GET', ['storage_box_types']):
        return (200, {'storage_box_types': types, 'meta': _meta(types.length)});
      case ('GET', ['storage_box_types', final id]):
        return (200, {'storage_box_type': types[int.parse(id) - 1]});
      case ('GET', ['storage_boxes']):
        return (200, {'storage_boxes': boxes, 'meta': _meta(boxes.length)});
      case ('GET', ['storage_boxes', 'actions']):
        return (200, {'actions': actions, 'meta': _meta(actions.length)});
      case ('GET', ['storage_boxes', 'actions', final id]):
        final a = actions.where((a) => '${a['id']}' == id).firstOrNull;
        if (a == null) return notFound;
        final n = _polls[a['id']! as int] = (_polls[a['id']! as int] ?? 0) + 1;
        if (n >= 2) {
          a
            ..['status'] = 'success'
            ..['progress'] = 100;
        }
        return (200, {'action': a});
      case ('POST', ['storage_boxes']):
        final id = _next++;
        boxes.add(
          storageBoxJson(
            id: id,
            name: body['name']! as String,
            status: 'initializing',
          ),
        );
        return (
          201,
          {'storage_box': boxes.last, 'action': _action('create', id)},
        );
      case ('GET', ['storage_boxes', final id]):
        final b = find(id);
        return b == null ? notFound : (200, {'storage_box': b});
      case ('PUT', ['storage_boxes', final id]):
        final b = find(id);
        if (b == null) return notFound;
        b.addAll(body);
        return (200, {'storage_box': b});
      case ('DELETE', ['storage_boxes', final id]):
        final b = find(id);
        if (b == null) return notFound;
        boxes.remove(b);
        return _started('delete', b['id']! as int);
      case ('GET', ['storage_boxes', final id, 'actions']):
        final mine = [
          for (final a in actions)
            if ((a['resources']! as List).any(
              (r) => '${(r as Map)['id']}' == id,
            ))
              a,
        ];
        return (200, {'actions': mine, 'meta': _meta(mine.length)});
      case ('GET', ['storage_boxes', _, 'folders']):
        return (200, {'folders': folders});
      case ('POST', ['storage_boxes', final id, 'actions', final cmd]):
        final b = find(id);
        if (b == null) return notFound;
        switch (cmd) {
          case 'change_protection':
            b['protection'] = {'delete': body['delete']};
          case 'change_type':
            b['storage_box_type'] = types.firstWhere(
              (t) => t['name'] == body['storage_box_type'],
            );
          case 'update_access_settings':
            (b['access_settings']! as Map).addAll(body);
          case 'enable_snapshot_plan':
            b['snapshot_plan'] = {
              'day_of_week': null,
              'day_of_month': null,
              ...body,
            };
          case 'disable_snapshot_plan':
            b['snapshot_plan'] = null;
        }
        return _started(cmd, b['id']! as int);
      case ('GET', ['storage_boxes', final id, 'snapshots']):
        return (200, {'snapshots': of(snapshots, id)});
      case ('POST', ['storage_boxes', final id, 'snapshots']):
        final s = boxSnapshotJson(
          id: _next++,
          box: int.parse(id),
          description: body['description'] as String? ?? '',
        );
        of(snapshots, id).add(s);
        return (
          201,
          {
            'snapshot': {'id': s['id'], 'storage_box': int.parse(id)},
            'action': _action('create_snapshot', int.parse(id)),
          },
        );
      case ('GET', ['storage_boxes', final id, 'snapshots', final sid]):
        final s = of(
          snapshots,
          id,
        ).where((s) => '${s['id']}' == sid).firstOrNull;
        return s == null ? notFound : (200, {'snapshot': s});
      case ('PUT', ['storage_boxes', final id, 'snapshots', final sid]):
        final s = of(snapshots, id).firstWhere((s) => '${s['id']}' == sid)
          ..addAll(body);
        return (200, {'snapshot': s});
      case ('DELETE', ['storage_boxes', final id, 'snapshots', final sid]):
        of(snapshots, id).removeWhere((s) => '${s['id']}' == sid);
        return _started('delete_snapshot', int.parse(id));
      case ('GET', ['storage_boxes', final id, 'subaccounts']):
        return (200, {'subaccounts': of(subaccounts, id)});
      case ('POST', ['storage_boxes', final id, 'subaccounts']):
        final s = subaccountJson(
          id: _next++,
          box: int.parse(id),
          home: body['home_directory']! as String,
          description: body['description'] as String? ?? '',
        )..['access_settings'] = body['access_settings'];
        of(subaccounts, id).add(s);
        return (
          201,
          {
            'subaccount': {'id': s['id'], 'storage_box': int.parse(id)},
            'action': _action('create_subaccount', int.parse(id)),
          },
        );
      case ('GET', ['storage_boxes', final id, 'subaccounts', final sid]):
        final s = of(
          subaccounts,
          id,
        ).where((s) => '${s['id']}' == sid).firstOrNull;
        return s == null ? notFound : (200, {'subaccount': s});
      case ('PUT', ['storage_boxes', final id, 'subaccounts', final sid]):
        final s = of(subaccounts, id).firstWhere((s) => '${s['id']}' == sid)
          ..addAll(body);
        return (200, {'subaccount': s});
      case ('DELETE', ['storage_boxes', final id, 'subaccounts', final sid]):
        of(subaccounts, id).removeWhere((s) => '${s['id']}' == sid);
        return _started('delete_subaccount', int.parse(id));
      case (
        'POST',
        [
          'storage_boxes',
          final id,
          'subaccounts',
          final sid,
          'actions',
          final cmd,
        ],
      ):
        final s = of(subaccounts, id).firstWhere((s) => '${s['id']}' == sid);
        switch (cmd) {
          case 'change_home_directory':
            s['home_directory'] = body['home_directory'];
          case 'update_access_settings':
            (s['access_settings']! as Map).addAll(body);
        }
        return _started(cmd, int.parse(id));
    }
    return notFound;
  }

  /// Answers an S3 request; [auth] is its Authorization header.
  (int, Object?) s3(RequestOptions o, String auth, String accessKey) {
    // Presigned links carry the credential in the query.
    final signed =
        auth.contains('Credential=$accessKey/') ||
        (o.uri.queryParameters['X-Amz-Credential'] ?? '').startsWith(
          '$accessKey/',
        );
    if (!signed) return (403, '<Error><Code>AccessDenied</Code></Error>');
    final location = o.uri.host.split('.').first;
    if (failing.contains(location)) {
      return (500, '<Error><Code>InternalError</Code></Error>');
    }
    final at = buckets[location] ??= {};
    final q = o.uri.queryParameters;
    final seg = o.uri.pathSegments;
    final bucket = seg.isEmpty ? '' : seg.first;
    final key = seg.length < 2 ? '' : seg.skip(1).join('/');
    final b = at[bucket];
    const noBucket = (404, '<Error><Code>NoSuchBucket</Code></Error>');
    String esc(String s) => const HtmlEscape(HtmlEscapeMode.element).convert(s);

    if (bucket.isEmpty) {
      return (
        200,
        '<ListAllMyBucketsResult><Buckets>'
            '${at.keys.map(_bucketXml).join()}'
            '</Buckets></ListAllMyBucketsResult>',
      );
    }
    if (key.isEmpty) {
      switch (o.method) {
        case 'PUT' when q.containsKey('versioning'):
          if (b == null) return noBucket;
          b.versioning = RegExp('<Status>(.*)</Status>')
              .firstMatch(o.data as String)!
              .group(1);
          return (200, null);
        case 'GET' when q.containsKey('versioning'):
          if (b == null) return noBucket;
          return (
            200,
            '<VersioningConfiguration>${b.versioning == null ? '' : '<Status>${b.versioning}</Status>'}</VersioningConfiguration>',
          );
        case 'GET' when q.containsKey('acl'):
          if (b == null) return noBucket;
          return (
            200,
            '<AccessControlPolicy><AccessControlList>${b.public ? '<Grant><Grantee><URI>http://acs.amazonaws.com/groups/global/AllUsers</URI></Grantee><Permission>READ</Permission></Grant>' : ''}</AccessControlList></AccessControlPolicy>',
          );
        case 'PUT' when q.containsKey('acl'):
          b?.public = o.headers['x-amz-acl'] == 'public-read';
          return (200, null);
        case 'GET' when q.containsKey('location'):
          return (200, '<LocationConstraint>$location</LocationConstraint>');
        case 'PUT':
          at[bucket] = FakeBucket()
            ..public = o.headers['x-amz-acl'] == 'public-read';
          return (200, null);
        case 'DELETE':
          if (b == null) return noBucket;
          if (b.objects.isNotEmpty) {
            return (409, '<Error><Code>BucketNotEmpty</Code></Error>');
          }
          at.remove(bucket);
          return (204, null);
        case 'POST' when q.containsKey('delete'):
          final keys = [
            for (final m in RegExp(
              '<Key>(.*?)</Key>',
            ).allMatches(o.data as String))
              m.group(1)!,
          ];
          final failed = keys.where((k) => k.startsWith('locked')).toList();
          for (final k in keys) {
            if (!failed.contains(k)) b?.objects.remove(k);
          }
          return (
            200,
            '<DeleteResult>${failed.map((k) => '<Error><Key>$k</Key><Code>AccessDenied</Code></Error>').join()}</DeleteResult>',
          );
        case 'GET' when q.containsKey('versions'):
          // Every version of every key below the prefix, keys in order.
          final all = [
            for (final k in (b?.objects.keys.toList() ?? <String>[])..sort())
              if (k.startsWith(q['prefix']!)) ...[
                (k, b!.objects[k]!.version, true, b.objects[k]!.size),
                for (final (v, size) in b.objects[k]!.older)
                  (k, v, false, size),
              ],
          ];
          var from = 0;
          if (q['key-marker'] case final km?) {
            from =
                all.indexWhere(
                  (e) => e.$1 == km && e.$2 == q['version-id-marker'],
                ) +
                1;
          }
          final page = all.skip(from).take(versionPage).toList();
          final more = from + page.length < all.length;
          final next = more
              ? '<NextKeyMarker>${esc(page.last.$1)}</NextKeyMarker>'
                    '<NextVersionIdMarker>${page.last.$2}</NextVersionIdMarker>'
              : '';
          String version((String, String, bool, int) e) =>
              '<Version><Key>${esc(e.$1)}</Key><VersionId>${e.$2}</VersionId>'
              '<IsLatest>${e.$3}</IsLatest><LastModified>'
              '2026-02-0${e.$3 ? 3 : 2}T10:00:00.000Z'
              '</LastModified><Size>${e.$4}</Size></Version>';
          final versions = page.map(version).join();
          return (
            200,
            '<ListVersionsResult><IsTruncated>$more</IsTruncated>'
                '$next$versions</ListVersionsResult>',
          );
        case 'GET':
          if (b == null) return noBucket;
          final prefix = q['prefix'] ?? '';
          final folders = <String>{};
          final objects = <String>[];
          for (final k in b.objects.keys.where((k) => k.startsWith(prefix))) {
            final rest = k.substring(prefix.length);
            final slash = rest.indexOf('/');
            if (slash >= 0) {
              folders.add('$prefix${rest.substring(0, slash + 1)}');
            } else {
              objects.add(k);
            }
          }
          return (
            200,
            '<ListBucketResult><IsTruncated>false</IsTruncated>${[for (final f in folders) '<CommonPrefixes><Prefix>${esc(f)}</Prefix></CommonPrefixes>', for (final k in objects) '<Contents><Key>${esc(k)}</Key><LastModified>2026-02-03T10:00:00.000Z</LastModified><ETag>"e$k"</ETag><Size>${b.objects[k]!.size}</Size></Contents>'].join()}</ListBucketResult>',
          );
      }
    }
    if (b == null) return noBucket;
    switch (o.method) {
      case 'POST' when q.containsKey('uploads'):
        final id = 'up${_next++}';
        uploads[id] = (bucket, key, {});
        return (
          200,
          '<InitiateMultipartUploadResult><UploadId>$id</UploadId></InitiateMultipartUploadResult>',
        );
      case 'GET' when q.containsKey('uploadId'):
        final u = uploads[q['uploadId']];
        if (u == null) return (404, '<Error><Code>NoSuchUpload</Code></Error>');
        return (
          200,
          '<ListPartsResult><IsTruncated>false</IsTruncated>${[for (final n in u.$3.keys) '<Part><PartNumber>$n</PartNumber><ETag>"p$n"</ETag></Part>'].join()}</ListPartsResult>',
        );
      case 'POST' when q.containsKey('uploadId'):
        final u = uploads.remove(q['uploadId']);
        if (u == null) return (404, '<Error><Code>NoSuchUpload</Code></Error>');
        if (failJoin > 0) {
          failJoin--;
          uploads[q['uploadId']!] = u;
          // S3 may fail a join with 200 and an error body.
          return (200, '<Error><Code>InternalError</Code></Error>');
        }
        _store(b, key, u.$3.values.fold(0, (a, s) => a + s));
        b.objects[key]!.etag = '"j-${u.$3.length}"';
        if (loseJoin > 0) {
          loseJoin--;
          return (500, '<Error><Code>InternalError</Code></Error>');
        }
        return (
          200,
          '<CompleteMultipartUploadResult><ETag>"j"</ETag></CompleteMultipartUploadResult>',
        );
      case 'DELETE' when q.containsKey('uploadId'):
        if (failAbort) {
          return (500, '<Error><Code>InternalError</Code></Error>');
        }
        uploads.remove(q['uploadId']);
        return (204, null);
      case 'HEAD':
        final obj = b.objects[key];
        if (obj == null) return (404, null);
        return (
          200,
          FakeResponse('', {
            'content-length': ['${obj.size}'],
            'last-modified': ['Tue, 03 Feb 2026 10:00:00 GMT'],
            'etag': [obj.etag ?? '"e$key"'],
            'content-type': ['text/plain'],
          }),
        );
      case 'PUT' when o.headers.containsKey('x-amz-copy-source'):
        final src = Uri.decodeFull('${o.headers['x-amz-copy-source']}');
        final from = Uri.parse(src);
        final parts = from.pathSegments;
        final source =
            buckets[location]![parts.first]!.objects[parts.skip(1).join('/')]!;
        final version = from.queryParameters['versionId'];
        final size = version == null
            ? source.size
            : source.older.firstWhere((v) => v.$1 == version).$2;
        if (failCopy) {
          return (200, '<Error><Code>InternalError</Code></Error>');
        }
        _store(b, key, size);
        return (200, '<CopyObjectResult><ETag>"c"</ETag></CopyObjectResult>');
      case 'PUT':
        _store(b, key, (o.data as List<int>?)?.length ?? 0);
        return (200, null);
      case 'DELETE':
        b.objects.remove(key);
        return (204, null);
    }
    return (400, '<Error><Code>NotImplemented</Code></Error>');
  }

  void _store(FakeBucket b, String key, int size) {
    final old = b.objects[key];
    if (old != null && b.versioning == 'Enabled') {
      old
        ..older.insert(0, (old.version, old.size))
        ..version = 'v${old.older.length + 1}'
        ..size = size;
    } else {
      b.objects[key] = FakeObject(size);
    }
  }

  /// What a native transfer would do with presigned [url]: a part or a
  /// whole object of [size] bytes.
  void upload(Uri url, int size) {
    final q = url.queryParameters;
    final seg = url.pathSegments;
    if (q['uploadId'] case final id?) {
      uploads[id]!.$3[int.parse(q['partNumber']!)] = size;
      return;
    }
    final b = buckets[url.host.split('.').first]![seg.first]!;
    _store(b, seg.skip(1).join('/'), size);
  }
}

/// ObjectTransfers without the platform: uploads land in [storage] at once,
/// downloads are recorded; each then reports `complete`.
class FakeTransfers extends ObjectTransfers {
  new(super.s3, this.storage, {super.onUploaded})
    : super(
        partSize: storage.partSize,
        partsRoot: Directory.systemTemp.createTempSync('falco-parts').path,
        jobsRoot: Directory.systemTemp.createTempSync('falco-jobs').path,
      );

  final FakeStorage storage;

  /// Download tasks handed to the platform.
  final downloadTasks = <DownloadTask>[];

  /// Upload tasks handed to the platform.
  final uploadTasks = <UploadTask>[];

  /// Whether the platform refuses the next tasks.
  bool refuse = false;

  /// Whether tasks never report back, so the start message stays.
  bool hold = false;

  @override
  Future<void> start() async {}

  @override
  Future<void> enqueue(List<Task> tasks) async {
    if (refuse) throw StateError('enqueue failed');
    for (final t in tasks) {
      final url = Uri.parse(t.url);
      if (t is UploadTask) {
        uploadTasks.add(t);
        storage.upload(url, await File(await t.filePath()).length());
      } else {
        storage.downloads.add(url);
        downloadTasks.add(t as DownloadTask);
      }
    }
    if (hold) return;
    // Like the platform: updates arrive after enqueue returned.
    for (final t in tasks) {
      unawaited(
        Future<void>.delayed(
          Duration.zero,
          () => onStatus(TaskStatusUpdate(t, TaskStatus.complete)),
        ),
      );
    }
  }

  /// What keep answers: false when the move to Downloads failed.
  bool keeps = true;

  @override
  Future<bool> keep(DownloadTask task) async => keeps;
}
