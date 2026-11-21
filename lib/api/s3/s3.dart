// SPDX-License-Identifier: GPL-3.0-or-later
/// S3 (Object Storage) on dio: AWS Signature Version 4, presigned links,
/// the pinned dio and the operations Falco uses, parsed from S3's XML.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:xml/xml.dart';

/// SHA-256 of an empty body.
const emptyPayloadHash =
    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

/// Payload hash of a presigned request: the body is not signed.
const unsignedPayload = 'UNSIGNED-PAYLOAD';

/// Signs a request with AWS SigV4 and returns the headers to add
/// (`x-amz-date`, `Authorization`). [headers] are signed as given; `host`
/// is taken from [uri].
Map<String, String> signV4({
  required String method,
  required Uri uri,
  required Map<String, String> headers,
  required String payloadHash,
  required String accessKey,
  required String secretKey,
  required String region,
  required DateTime now,
  String service = 's3',
}) {
  final amzDate = _amzDate(now.toUtc());
  final signed = <String, String>{
    for (final MapEntry(:key, :value) in headers.entries)
      key.toLowerCase(): value.trim().replaceAll(RegExp(r'\s+'), ' '),
    'host': _host(uri),
    'x-amz-date': amzDate,
  };
  final (scope, signature) = _sign(
    method: method,
    uri: uri,
    query: uri.queryParametersAll,
    headers: signed,
    payloadHash: payloadHash,
    secretKey: secretKey,
    region: region,
    amzDate: amzDate,
    service: service,
  );
  final names = signed.keys.toList()..sort();
  return {
    'x-amz-date': amzDate,
    'Authorization':
        'AWS4-HMAC-SHA256 Credential=$accessKey/$scope, '
        'SignedHeaders=${names.join(';')}, Signature=$signature',
  };
}

/// A presigned link for [method] on [uri], valid for [expires] (at most
/// 7 days): anyone holding it can make that one request without keys
/// (OBJ-011, OBJ-025, background transfers). Only `host` is signed.
Uri presignV4({
  required String method,
  required Uri uri,
  required String accessKey,
  required String secretKey,
  required String region,
  required DateTime now,
  required Duration expires,
}) {
  final amzDate = _amzDate(now.toUtc());
  final day = amzDate.substring(0, 8);
  final query = {
    ...uri.queryParametersAll,
    'X-Amz-Algorithm': ['AWS4-HMAC-SHA256'],
    'X-Amz-Credential': ['$accessKey/$day/$region/s3/aws4_request'],
    'X-Amz-Date': [amzDate],
    'X-Amz-Expires': ['${expires.inSeconds}'],
    'X-Amz-SignedHeaders': ['host'],
  };
  final (_, signature) = _sign(
    method: method,
    uri: uri,
    query: query,
    headers: {'host': _host(uri)},
    payloadHash: unsignedPayload,
    secretKey: secretKey,
    region: region,
    amzDate: amzDate,
    service: 's3',
  );
  return Uri.parse(
    '${uri.scheme}://${_host(uri)}${_path(uri)}?'
    '${_query({
      ...query,
      'X-Amz-Signature': [signature],
    })}',
  );
}

(String scope, String signature) _sign({
  required String method,
  required Uri uri,
  required Map<String, List<String>> query,
  required Map<String, String> headers,
  required String payloadHash,
  required String secretKey,
  required String region,
  required String amzDate,
  required String service,
}) {
  final day = amzDate.substring(0, 8);
  final names = headers.keys.toList()..sort();
  final canonical = [
    method.toUpperCase(),
    _path(uri),
    _query(query),
    for (final n in names) '$n:${headers[n]}',
    '',
    names.join(';'),
    payloadHash,
  ].join('\n');
  final scope = '$day/$region/$service/aws4_request';
  final toSign = [
    'AWS4-HMAC-SHA256',
    amzDate,
    scope,
    sha256.convert(utf8.encode(canonical)).toString(),
  ].join('\n');
  List<int> key = utf8.encode('AWS4$secretKey');
  for (final part in [day, region, service, 'aws4_request']) {
    key = Hmac(sha256, key).convert(utf8.encode(part)).bytes;
  }
  return (scope, Hmac(sha256, key).convert(utf8.encode(toSign)).toString());
}

String _host(Uri uri) =>
    uri.hasPort && !_defaultPort(uri) ? '${uri.host}:${uri.port}' : uri.host;

String _path(Uri uri) => '/${uri.pathSegments.map(_encode).join('/')}';

String _query(Map<String, List<String>> query) => ([
  for (final MapEntry(:key, :value) in query.entries)
    for (final v in value) '${_encode(key)}=${_encode(v)}',
]..sort()).join('&');

/// Creates a pinned dio for an S3 [endpoint] (e.g.
/// `https://fsn1.your-objectstorage.com`) that signs every request.
/// Plain `http` endpoints are rejected (QRS-019).
Dio createS3Dio({
  required String endpoint,
  required String region,
  required String accessKey,
  required String secretKey,
  required String userAgent,
}) {
  final dio = createDio(baseUrl: endpoint, userAgent: userAgent);
  dio.interceptors.insert(
    0,
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final data = options.data;
        final hash = switch (data) {
          null => emptyPayloadHash,
          List<int>() => sha256.convert(data).toString(),
          String() => sha256.convert(utf8.encode(data)).toString(),
          _ => unsignedPayload,
        };
        options.headers['x-amz-content-sha256'] = hash;
        options.headers.addAll(
          signV4(
            method: options.method,
            uri: options.uri,
            headers: {'x-amz-content-sha256': hash},
            payloadHash: hash,
            accessKey: accessKey,
            secretKey: secretKey,
            region: region,
            now: DateTime.now(),
          ),
        );
        handler.next(options);
      },
    ),
  );
  return dio;
}

String _amzDate(DateTime t) =>
    '${t.toIso8601String().replaceAll(RegExp('[-:]'), '').split('.').first}Z';

bool _defaultPort(Uri uri) =>
    (uri.scheme == 'https' && uri.port == 443) ||
    (uri.scheme == 'http' && uri.port == 80);

/// RFC 3986 encoding as SigV4 wants it: only `A-Za-z0-9-_.~` stay.
String _encode(String s) => Uri.encodeComponent(s).replaceAllMapped(
  RegExp("[!*'()]"),
  (m) => '%${m[0]!.codeUnitAt(0).toRadixString(16).toUpperCase()}',
);

/// Code of the [Invalid] for a key with a `.` or `..` segment.
const dotSegmentKey = 'dot_segment_key';

/// Whether [key] has a `.` or `..` segment. Every URL normalizes these
/// away, so such a key cannot be addressed by path: a request would hit
/// another key.
bool hasDotSegment(String key) =>
    key.split('/').any((s) => s == '.' || s == '..');

/// Path and query of [key] in [bucket] (path style), encoded exactly as
/// it is signed, so keys with any character work. Throws [Invalid] for a
/// key with a dot segment.
String s3Path(String bucket, [String key = '', Map<String, String>? query]) {
  if (hasDotSegment(key)) throw const Invalid(code: dotSegmentKey);
  final path =
      '/${[bucket, if (key.isNotEmpty) ...key.split('/')].map(_encode).join('/')}';
  return query == null || query.isEmpty
      ? path
      : '$path?${_query({
          for (final MapEntry(:key, :value) in query.entries) key: [value],
        })}';
}

/// An object as a listing or `HeadObject` shows it.
typedef S3Object = ({
  String key,
  int size,
  DateTime? modified,
  String? etag,
  String? contentType,
});

/// One version of an object (OBJ-023); a delete marker has no data.
typedef S3Version = ({
  String versionId,
  bool latest,
  bool deleteMarker,
  int size,
  DateTime? modified,
});

/// The S3 operations Falco uses, on a signing dio from [createS3Dio].
/// Errors arrive as `FalcoError` from the dio's interceptor.
class S3Client {
  const new(this._dio);

  final Dio _dio;

  /// S3 XML namespace of request bodies.
  static const xmlns = 'http://s3.amazonaws.com/doc/2006-03-01/';

  /// Absolute URL of [path]: dio collapses `//` only in relative paths,
  /// so keys with empty segments reach S3 as signed.
  String _url(String path) =>
      '${_dio.options.baseUrl.replaceFirst(RegExp(r'/+$'), '')}$path';

  Future<Response<String>> _send(
    String method,
    String path, {
    String? body,
    Map<String, String> headers = const {},
  }) => _dio.request<String>(
    _url(path),
    data: body,
    options: Options(
      method: method,
      headers: {
        ...headers,
        if (body != null) Headers.contentTypeHeader: 'application/xml',
      },
      responseType: ResponseType.plain,
    ),
  );

  Future<XmlDocument> _xml(String method, String path, {String? body}) async {
    final r = await _send(method, path, body: body);
    return XmlDocument.parse(r.data ?? '');
  }

  /// Buckets at this endpoint (OBJ-001).
  Future<List<({String name, DateTime? created})>> buckets() async => [
    for (final b in (await _xml('GET', '/')).findAllElements('Bucket'))
      (name: _text(b, 'Name') ?? '', created: _date(_text(b, 'CreationDate'))),
  ];

  /// The location constraint of [bucket], e.g. `fsn1`; null when S3 does
  /// not say.
  Future<String?> location(String bucket) async {
    final text = (await _xml(
      'GET',
      s3Path(bucket, '', {'location': ''}),
    )).rootElement.innerText.trim();
    return text.isEmpty ? null : text;
  }

  /// Creates [bucket], readable by everyone when [public] (OBJ-002).
  Future<void> createBucket(String bucket, {bool public = false}) => _send(
    'PUT',
    s3Path(bucket),
    headers: {if (public) 'x-amz-acl': 'public-read'},
  );

  /// Deletes an empty [bucket] (OBJ-003).
  Future<void> deleteBucket(String bucket) => _send('DELETE', s3Path(bucket));

  /// `Enabled`, `Suspended`, or null when never turned on (OBJ-004).
  Future<String?> versioning(String bucket) async => _text(
    (await _xml('GET', s3Path(bucket, '', {'versioning': ''}))).rootElement,
    'Status',
  );

  /// Turns versioning on or suspends it (OBJ-005).
  Future<void> setVersioning(String bucket, {required bool enabled}) => _send(
    'PUT',
    s3Path(bucket, '', {'versioning': ''}),
    body:
        '<VersioningConfiguration xmlns="$xmlns"><Status>'
        '${enabled ? 'Enabled' : 'Suspended'}'
        '</Status></VersioningConfiguration>',
  );

  /// Whether everyone may read [bucket] (a READ grant to all users).
  Future<bool> isPublic(String bucket) async =>
      (await _xml('GET', s3Path(bucket, '', {'acl': ''})))
          .findAllElements('Grant')
          .any(
            (g) =>
                (_text(g, 'URI') ?? '').endsWith('/global/AllUsers') &&
                _text(g, 'Permission') == 'READ',
          );

  /// Makes [bucket] public (read for everyone) or private.
  Future<void> setPublic(String bucket, {required bool public}) => _send(
    'PUT',
    s3Path(bucket, '', {'acl': ''}),
    headers: {'x-amz-acl': public ? 'public-read' : 'private'},
  );

  /// Folders and objects directly below [prefix], every page (OBJ-006).
  Future<({List<String> folders, List<S3Object> objects})> list(
    String bucket,
    String prefix,
  ) async {
    final folders = <String>[];
    final objects = <S3Object>[];
    String? token;
    do {
      final doc = await _xml(
        'GET',
        s3Path(bucket, '', {
          'list-type': '2',
          'delimiter': '/',
          'prefix': prefix,
          'continuation-token': ?token,
        }),
      );
      for (final p in doc.findAllElements('CommonPrefixes')) {
        folders.add(_text(p, 'Prefix') ?? '');
      }
      for (final c in doc.findAllElements('Contents')) {
        final key = _text(c, 'Key') ?? '';
        // The folder's own marker object.
        if (key == prefix) continue;
        objects.add((
          key: key,
          size: int.tryParse(_text(c, 'Size') ?? '') ?? 0,
          modified: _date(_text(c, 'LastModified')),
          etag: _text(c, 'ETag'),
          contentType: null,
        ));
      }
      token = _text(doc.rootElement, 'IsTruncated') == 'true'
          ? _text(doc.rootElement, 'NextContinuationToken')
          : null;
    } while (token != null);
    return (folders: folders, objects: objects);
  }

  /// Size, date, type and ETag of [key] (OBJ-010).
  Future<S3Object> head(String bucket, String key) async {
    final h = (await _send('HEAD', s3Path(bucket, key))).headers;
    return (
      key: key,
      size: int.tryParse(h.value(Headers.contentLengthHeader) ?? '') ?? 0,
      modified: switch (h.value('last-modified')) {
        final s? => HttpDate.parse(s),
        _ => null,
      },
      etag: h.value('etag'),
      contentType: h.value(Headers.contentTypeHeader),
    );
  }

  /// Stores [bytes] at [key]; an empty `name/` key is a folder (OBJ-024).
  /// Sent as [Uint8List], the only list dio sends as is (others it
  /// encodes as JSON), so the body is what was hashed.
  Future<void> put(String bucket, String key, List<int> bytes) {
    final data = Uint8List.fromList(bytes);
    return _dio.request<String>(
      _url(s3Path(bucket, key)),
      data: data,
      options: Options(
        method: 'PUT',
        headers: {Headers.contentLengthHeader: data.length},
        responseType: ResponseType.plain,
      ),
    );
  }

  /// Copies an object, or one version of it, to [toBucket]/[toKey]
  /// (OBJ-013, OBJ-023).
  Future<void> copy(
    String bucket,
    String key,
    String toBucket,
    String toKey, {
    String? versionId,
  }) async => _result(
    await _send(
      'PUT',
      s3Path(toBucket, toKey),
      headers: {
        'x-amz-copy-source':
            s3Path(bucket, key) +
            (versionId == null ? '' : '?versionId=${_encode(versionId)}'),
      },
    ),
    'CopyObjectResult',
  );

  /// Deletes [key] (OBJ-015). A key with a dot segment goes by name in a
  /// `DeleteObjects` body, as no path reaches it.
  Future<void> delete(String bucket, String key) async {
    if (!hasDotSegment(key)) {
      await _send('DELETE', s3Path(bucket, key));
    } else if ((await deleteMany(bucket, [key])).isNotEmpty) {
      throw const Forbidden();
    }
  }

  /// Deletes [keys] at once; returns those S3 could not delete (OBJ-017).
  Future<List<String>> deleteMany(String bucket, List<String> keys) async {
    final body =
        '<Delete xmlns="$xmlns"><Quiet>true</Quiet>'
        '${keys.map((k) => '<Object><Key>${_esc(k)}</Key></Object>').join()}'
        '</Delete>';
    final r = await _send(
      'POST',
      s3Path(bucket, '', {'delete': ''}),
      body: body,
      headers: {
        'content-md5': base64.encode(md5.convert(utf8.encode(body)).bytes),
      },
    );
    return [
      for (final e in XmlDocument.parse(
        r.data ?? '<r/>',
      ).findAllElements('Error'))
        _text(e, 'Key') ?? '',
    ];
  }

  /// Versions and delete markers of [key], newest first, every page
  /// (OBJ-023).
  Future<List<S3Version>> versions(String bucket, String key) async {
    final found = <S3Version>[];
    String? keyMarker;
    String? versionMarker;
    do {
      final root = (await _xml(
        'GET',
        s3Path(bucket, '', {
          'versions': '',
          'prefix': key,
          'key-marker': ?keyMarker,
          'version-id-marker': ?versionMarker,
        }),
      )).rootElement;
      // Keys sort after their prefix: another key ends the versions.
      var past = false;
      for (final v in root.childElements) {
        if (v.localName != 'Version' && v.localName != 'DeleteMarker') continue;
        if (_text(v, 'Key') != key) {
          past = true;
          continue;
        }
        found.add((
          versionId: _text(v, 'VersionId') ?? '',
          latest: _text(v, 'IsLatest') == 'true',
          deleteMarker: v.localName == 'DeleteMarker',
          size: int.tryParse(_text(v, 'Size') ?? '') ?? 0,
          modified: _date(_text(v, 'LastModified')),
        ));
      }
      final more = !past && _text(root, 'IsTruncated') == 'true';
      keyMarker = more ? _text(root, 'NextKeyMarker') : null;
      versionMarker = more ? _text(root, 'NextVersionIdMarker') : null;
    } while (keyMarker != null);
    return found;
  }

  /// Starts a multipart upload of [key]; returns its upload id (OBJ-022).
  Future<String> createMultipart(
    String bucket,
    String key,
    String contentType,
  ) async {
    final r = await _send(
      'POST',
      s3Path(bucket, key, {'uploads': ''}),
      headers: {Headers.contentTypeHeader: contentType},
    );
    return _text(XmlDocument.parse(r.data ?? '').rootElement, 'UploadId') ?? '';
  }

  /// Uploaded parts of [uploadId] as (number, ETag), every page.
  Future<List<(int, String)>> parts(
    String bucket,
    String key,
    String uploadId,
  ) async {
    final parts = <(int, String)>[];
    String? marker;
    do {
      final doc = await _xml(
        'GET',
        s3Path(bucket, key, {
          'uploadId': uploadId,
          'part-number-marker': ?marker,
        }),
      );
      for (final p in doc.findAllElements('Part')) {
        parts.add((
          int.tryParse(_text(p, 'PartNumber') ?? '') ?? 0,
          _text(p, 'ETag') ?? '',
        ));
      }
      marker = _text(doc.rootElement, 'IsTruncated') == 'true'
          ? _text(doc.rootElement, 'NextPartNumberMarker')
          : null;
    } while (marker != null);
    return parts;
  }

  /// Joins [parts] into the object.
  Future<void> completeMultipart(
    String bucket,
    String key,
    String uploadId,
    List<(int, String)> parts,
  ) async => _result(
    await _send(
      'POST',
      s3Path(bucket, key, {'uploadId': uploadId}),
      body:
          '<CompleteMultipartUpload>'
          '${(parts..sort((a, b) => a.$1 - b.$1)).map(_part).join()}'
          '</CompleteMultipartUpload>',
    ),
    'CompleteMultipartUploadResult',
  );

  /// Drops an unfinished multipart upload and its parts.
  Future<void> abortMultipart(String bucket, String key, String uploadId) =>
      _send('DELETE', s3Path(bucket, key, {'uploadId': uploadId}));
}

/// Checks the body of a copy or a join: S3 may answer 200 and still fail,
/// with an `<Error>` body. Only [root] with an ETag is success.
void _result(Response<String> r, String root) {
  XmlElement? e;
  try {
    e = XmlDocument.parse(r.data ?? '').rootElement;
  } on XmlException {
    e = null;
  }
  if (e?.localName != root || _text(e!, 'ETag') == null) {
    throw Server(code: e == null ? null : _text(e, 'Code'));
  }
}

String _part((int, String) p) =>
    '<Part><PartNumber>${p.$1}</PartNumber><ETag>${_esc(p.$2)}</ETag></Part>';

String _esc(String s) => const HtmlEscape(HtmlEscapeMode.element).convert(s);

String? _text(XmlElement e, String name) =>
    e.findAllElements(name).firstOrNull?.innerText;

DateTime? _date(String? s) => s == null ? null : DateTime.tryParse(s);
