// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:dio/dio.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/primary_ips_get4xx_body_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/primary_ips_get5xx_body_model.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/model/primary_ips_parameters_array_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/dio_operation.dart' as _i1;
import 'package:hetzner_cloud_api/src/response_wrapper/list_primary_ips_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class ListPrimaryIps
    extends _i1.DioOperation<_i2.ListPrimaryIpsResponse> {
  ListPrimaryIps(super.baseUrl, super.clientAccessor);

  static const _i3.int pageDefault = 1;

  static const _i3.int perPageDefault = 25;

  _i3.Future<
    _i4.TonikResult<_i2.ListPrimaryIpsResponse, _i5.Response<_i3.Object?>>
  >
  call({
    _i3.String? name,
    _i3.String? labelSelector,
    _i3.String? ip,
    _i3.int page = pageDefault,
    _i3.int perPage = perPageDefault,
    _i3.List<_i6.PrimaryIpsParametersArrayModel>? sort,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.DioOperationRequest(
        path: _path(),
        query: _queryParameters(
          name: name,
          labelSelector: labelSelector,
          ip: ip,
          page: page,
          perPage: perPage,
          sort: sort,
        ),
        data: _data(),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path() {
    return [r'primary_ips'];
  }

  _i3.Object? _data() {
    return null;
  }

  _i3.String? _queryParameters({
    _i3.String? name,
    _i3.String? labelSelector,
    _i3.String? ip,
    _i3.int? page,
    _i3.int? perPage,
    _i3.List<_i6.PrimaryIpsParametersArrayModel>? sort,
  }) {
    final _$entries = <_i4.ParameterEntry>[];
    if (name != null) {
      _$entries.addAll(
        name.toForm(
          r'name',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (labelSelector != null) {
      _$entries.addAll(
        labelSelector.toForm(
          r'label_selector',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (ip != null) {
      _$entries.addAll(
        ip.toForm(
          r'ip',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (page != null) {
      _$entries.addAll(
        page.toForm(
          r'page',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (perPage != null) {
      _$entries.addAll(
        perPage.toForm(
          r'per_page',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (sort != null) {
      _$entries.addAll(
        sort
            .map((e) => e.uriEncode(allowEmpty: false, textEncoding: _i7.utf8))
            .toList()
            .toForm(
              r'sort',
              explode: true,
              allowEmpty: false,
              textEncoding: _i7.utf8,
              alreadyEncoded: true,
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

  _i2.ListPrimaryIpsResponse _parseResponse(
    _i5.Response<_i3.List<_i3.int>> response,
  ) {
    final _$mediaType = _i4.extractMediaType(
      response.headers.value('content-type'),
    );
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.data);
        final _$body = _i8.PrimaryIpsGet200BodyModel.fromJson(_$json);
        return _i2.ListPrimaryIpsResponse200(body: _$body);
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
        final _$body = _i9.PrimaryIpsGet4xxBodyModel.fromJson(_$json);
        return _i2.ListPrimaryIpsResponse4XX(body: _$body);
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
        final _$body = _i10.PrimaryIpsGet5xxBodyModel.fromJson(_$json);
        return _i2.ListPrimaryIpsResponse5XX(body: _$body);
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
