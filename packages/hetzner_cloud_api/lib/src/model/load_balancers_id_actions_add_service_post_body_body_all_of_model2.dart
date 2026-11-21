// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post_body_body_all_of_http_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2({this.http});

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2: contains complex types',
    );
  }

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2',
    );
    return LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2(
      http: _$map[r'http'] == null
          ? null
          : _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHttpModel.fromJson(
              _$map[r'http'],
            ),
    );
  }

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2: contains complex types',
    );
  }

  /// Configuration option for protocols http and https.
  final _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHttpModel? http;

  @_i3.override
  _i3.Object? toJson() => {if (this.http != null) r'http': this.http?.toJson()};

  LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2 Function({
    _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHttpModel? http,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? http = _sentinel,
    }) => LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2(
      http: _i3.identical(http, _sentinel)
          ? this.http
          : (http
                as _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHttpModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2 &&
        other.http == this.http;
  }

  @_i3.override
  _i3.int get hashCode => this.http.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2: complex types cannot be URI-encoded',
    );
  }
}
