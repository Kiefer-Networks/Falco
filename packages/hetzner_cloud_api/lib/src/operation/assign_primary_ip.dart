// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:dio/dio.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_assign_post201_body_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_assign_post4xx_body_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_assign_post5xx_body_model.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_assign_post_body_body_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/dio_operation.dart' as _i1;
import 'package:hetzner_cloud_api/src/response_wrapper/assign_primary_ip_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class AssignPrimaryIp
    extends _i1.DioOperation<_i2.AssignPrimaryIpResponse> {
  AssignPrimaryIp(super.baseUrl, super.clientAccessor);

  _i3.Future<
    _i4.TonikResult<_i2.AssignPrimaryIpResponse, _i5.Response<_i3.Object?>>
  >
  call({
    required _i6.PrimaryIpsIdActionsAssignPostBodyBodyModel body,
    required _i3.int id,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.DioOperationRequest(
        path: _path(id: id),
        query: null,
        data: _data(body: body),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path({required _i3.int id}) {
    return [
      r'primary_ips',
      id.toSimple(explode: false, allowEmpty: false),
      r'actions',
      r'assign',
    ];
  }

  _i3.Object? _data({
    required _i6.PrimaryIpsIdActionsAssignPostBodyBodyModel body,
  }) {
    return _i7.jsonEncode(body.toJson());
  }

  _i5.Options _options() {
    final _$headers = <_i3.String, _i3.dynamic>{};
    _$headers['Accept'] = r'application/json';
    return _i5.Options(
      method: 'POST',
      headers: _$headers,
      contentType: r'application/json',
      responseType: _i5.ResponseType.bytes,
      validateStatus: (_) => true,
    );
  }

  _i2.AssignPrimaryIpResponse _parseResponse(
    _i5.Response<_i3.List<_i3.int>> response,
  ) {
    final _$mediaType = _i4.extractMediaType(
      response.headers.value('content-type'),
    );
    switch ((response.statusCode, _$mediaType)) {
      case (201, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.data);
        final _$body = _i8.PrimaryIpsIdActionsAssignPost201BodyModel.fromJson(
          _$json,
        );
        return _i2.AssignPrimaryIpResponse201(body: _$body);
      case (201, _):
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
        final _$body = _i9.PrimaryIpsIdActionsAssignPost4xxBodyModel.fromJson(
          _$json,
        );
        return _i2.AssignPrimaryIpResponse4XX(body: _$body);
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
        final _$body = _i10.PrimaryIpsIdActionsAssignPost5xxBodyModel.fromJson(
          _$json,
        );
        return _i2.AssignPrimaryIpResponse5XX(body: _$body);
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
