// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:dio/dio.dart' as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_put200_body_model.dart'
    as _i8;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_put4xx_body_model.dart'
    as _i9;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_put5xx_body_model.dart'
    as _i10;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_put_body_body_model.dart'
    as _i6;
import 'package:hetzner_storage_box_api/src/operation/dio_operation.dart'
    as _i1;
import 'package:hetzner_storage_box_api/src/response_wrapper/update_storage_box_snapshot_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class UpdateStorageBoxSnapshot
    extends _i1.DioOperation<_i2.UpdateStorageBoxSnapshotResponse> {
  UpdateStorageBoxSnapshot(super.baseUrl, super.clientAccessor);

  _i3.Future<
    _i4.TonikResult<
      _i2.UpdateStorageBoxSnapshotResponse,
      _i5.Response<_i3.Object?>
    >
  >
  call({
    required _i6.StorageBoxesIdSnapshotsSnapshotIdPutBodyBodyModel body,
    required _i3.int id,
    required _i3.int snapshotId,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.DioOperationRequest(
        path: _path(id: id, snapshotId: snapshotId),
        query: null,
        data: _data(body: body),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path({
    required _i3.int id,
    required _i3.int snapshotId,
  }) {
    return [
      r'storage_boxes',
      id.toSimple(explode: false, allowEmpty: false),
      r'snapshots',
      snapshotId.toSimple(explode: false, allowEmpty: false),
    ];
  }

  _i3.Object? _data({
    required _i6.StorageBoxesIdSnapshotsSnapshotIdPutBodyBodyModel body,
  }) {
    return _i7.jsonEncode(body.toJson());
  }

  _i5.Options _options() {
    final _$headers = <_i3.String, _i3.dynamic>{};
    _$headers['Accept'] = r'application/json';
    return _i5.Options(
      method: 'PUT',
      headers: _$headers,
      contentType: r'application/json',
      responseType: _i5.ResponseType.bytes,
      validateStatus: (_) => true,
    );
  }

  _i2.UpdateStorageBoxSnapshotResponse _parseResponse(
    _i5.Response<_i3.List<_i3.int>> response,
  ) {
    final _$mediaType = _i4.extractMediaType(
      response.headers.value('content-type'),
    );
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.data);
        final _$body = _i8
            .StorageBoxesIdSnapshotsSnapshotIdPut200BodyModel.fromJson(_$json);
        return _i2.UpdateStorageBoxSnapshotResponse200(body: _$body);
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
        final _$body = _i9
            .StorageBoxesIdSnapshotsSnapshotIdPut4xxBodyModel.fromJson(_$json);
        return _i2.UpdateStorageBoxSnapshotResponse4XX(body: _$body);
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
        final _$body = _i10
            .StorageBoxesIdSnapshotsSnapshotIdPut5xxBodyModel.fromJson(_$json);
        return _i2.UpdateStorageBoxSnapshotResponse5XX(body: _$body);
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
