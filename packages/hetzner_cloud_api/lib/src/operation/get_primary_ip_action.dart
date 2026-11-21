// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i1;

import 'package:dio/dio.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_action_id_get200_body_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_action_id_get4xx_body_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_action_id_get5xx_body_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/operation/dio_operation.dart' as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/get_primary_ip_action_response.dart'
    as _i3;
import 'package:tonik_util/tonik_util.dart' as _i4;

@_i1.Deprecated('This operation is deprecated.')
final class GetPrimaryIpAction
    extends _i2.DioOperation<_i3.GetPrimaryIpActionResponse> {
  GetPrimaryIpAction(super.baseUrl, super.clientAccessor);

  _i1.Future<
    _i4.TonikResult<_i3.GetPrimaryIpActionResponse, _i5.Response<_i1.Object?>>
  >
  call({
    required _i1.int id,
    required _i1.int actionId,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i2.DioOperationRequest(
        path: _path(id: id, actionId: actionId),
        query: null,
        data: _data(),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i1.List<_i1.String> _path({required _i1.int id, required _i1.int actionId}) {
    return [
      r'primary_ips',
      id.toSimple(explode: false, allowEmpty: false),
      r'actions',
      actionId.toSimple(explode: false, allowEmpty: false),
    ];
  }

  _i1.Object? _data() {
    return null;
  }

  _i5.Options _options() {
    final _$headers = <_i1.String, _i1.dynamic>{};
    _$headers['Accept'] = r'application/json';
    return _i5.Options(
      method: 'GET',
      headers: _$headers,
      responseType: _i5.ResponseType.bytes,
      validateStatus: (_) => true,
    );
  }

  _i3.GetPrimaryIpActionResponse _parseResponse(
    _i5.Response<_i1.List<_i1.int>> response,
  ) {
    final _$mediaType = _i4.extractMediaType(
      response.headers.value('content-type'),
    );
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i1.Object?>(response.data);
        final _$body = _i6.PrimaryIpsIdActionsActionIdGet200BodyModel.fromJson(
          _$json,
        );
        return _i3.GetPrimaryIpActionResponse200(body: _$body);
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
        final _$json = _i4.decodeResponseJson<_i1.Object?>(response.data);
        final _$body = _i7.PrimaryIpsIdActionsActionIdGet4xxBodyModel.fromJson(
          _$json,
        );
        return _i3.GetPrimaryIpActionResponse4XX(body: _$body);
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
        final _$json = _i4.decodeResponseJson<_i1.Object?>(response.data);
        final _$body = _i8.PrimaryIpsIdActionsActionIdGet5xxBodyModel.fromJson(
          _$json,
        );
        return _i3.GetPrimaryIpActionResponse5XX(body: _$body);
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
