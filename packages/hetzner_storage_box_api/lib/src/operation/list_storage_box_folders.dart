// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:dio/dio.dart' as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_folders_get200_body_model.dart'
    as _i7;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_folders_get4xx_body_model.dart'
    as _i8;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_folders_get5xx_body_model.dart'
    as _i9;
import 'package:hetzner_storage_box_api/src/operation/dio_operation.dart'
    as _i1;
import 'package:hetzner_storage_box_api/src/response_wrapper/list_storage_box_folders_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class ListStorageBoxFolders
    extends _i1.DioOperation<_i2.ListStorageBoxFoldersResponse> {
  ListStorageBoxFolders(super.baseUrl, super.clientAccessor);

  static const _i3.String pathDefault = r'.';

  _i3.Future<
    _i4.TonikResult<
      _i2.ListStorageBoxFoldersResponse,
      _i5.Response<_i3.Object?>
    >
  >
  call({
    required _i3.int id,
    _i3.String path = pathDefault,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.DioOperationRequest(
        path: _path(id: id),
        query: _queryParameters(path: path),
        data: _data(),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path({required _i3.int id}) {
    return [
      r'storage_boxes',
      id.toSimple(explode: false, allowEmpty: false),
      r'folders',
    ];
  }

  _i3.Object? _data() {
    return null;
  }

  _i3.String? _queryParameters({_i3.String? path}) {
    final _$entries = <_i4.ParameterEntry>[];
    if (path != null) {
      _$entries.addAll(
        path.toForm(
          r'path',
          explode: true,
          allowEmpty: false,
          textEncoding: _i6.utf8,
        ),
      );
    }
    if (_$entries.isEmpty) {
      return null;
    }
    return _$entries
        .map((e) => e.name.isEmpty ? e.value : '${e.name}=${e.value}')
        .join('&');
  }

  _i5.Options _options() {
    final _$headers = <_i3.String, _i3.dynamic>{};
    _$headers['Accept'] = r'application/json';
    return _i5.Options(
      method: 'GET',
      headers: _$headers,
      responseType: _i5.ResponseType.bytes,
      validateStatus: (_) => true,
    );
  }

  _i2.ListStorageBoxFoldersResponse _parseResponse(
    _i5.Response<_i3.List<_i3.int>> response,
  ) {
    final _$mediaType = _i4.extractMediaType(
      response.headers.value('content-type'),
    );
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.data);
        final _$body = _i7.StorageBoxesIdFoldersGet200BodyModel.fromJson(
          _$json,
        );
        return _i2.ListStorageBoxFoldersResponse200(body: _$body);
      case (200, _):
        final _$content =
            response.headers.value('content-type') ?? 'not specified';
        final _$matched = _$mediaType ?? 'none';
        final _$status = response.statusCode;
        throw _i4.ResponseDecodingException(
          'Unexpected content type: ${_$content} (matched as: ${_$matched}) for status code: ${_$status}',
        );
      case (var status, r'application/json')
          when status != null && status >= 400 && status <= 499:
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.data);
        final _$body = _i8.StorageBoxesIdFoldersGet4xxBodyModel.fromJson(
          _$json,
        );
        return _i2.ListStorageBoxFoldersResponse4XX(body: _$body);
      case (var status, _)
          when status != null && status >= 400 && status <= 499:
        final _$content =
            response.headers.value('content-type') ?? 'not specified';
        final _$matched = _$mediaType ?? 'none';
        final _$status = response.statusCode;
        throw _i4.ResponseDecodingException(
          'Unexpected content type: ${_$content} (matched as: ${_$matched}) for status code: ${_$status}',
        );
      case (var status, r'application/json')
          when status != null && status >= 500 && status <= 599:
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.data);
        final _$body = _i9.StorageBoxesIdFoldersGet5xxBodyModel.fromJson(
          _$json,
        );
        return _i2.ListStorageBoxFoldersResponse5XX(body: _$body);
      default:
        final _$content =
            response.headers.value('content-type') ?? 'not specified';
        final _$matched = _$mediaType ?? 'none';
        final _$status = response.statusCode;
        throw _i4.ResponseDecodingException(
          'Unexpected content type: ${_$content} (matched as: ${_$matched}) for status code: ${_$status}',
        );
    }
  }
}
