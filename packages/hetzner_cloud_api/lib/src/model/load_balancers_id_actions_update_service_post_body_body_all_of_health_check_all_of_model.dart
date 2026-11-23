// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_update_service_post_body_body_all_of_health_check_all_of_model2.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel({
    required this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2,
    required this.map,
  });

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel(
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2:
          _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      map: value.decodeSimpleMap(
        (v) => v,
        explode: explode,
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel.map',
        isHeader: isHeader,
      ),
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel(
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2:
          _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2.fromForm(
            value,
            explode: explode,
          ),
      map: throw _i1.FormDecodingException('Map types cannot be form-decoded.'),
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel(
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2:
          _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2.fromJson(
            json,
          ),
      map: json.decodeJsonMap(
        (v) => v,
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel',
      ),
    );
  }

  final _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2
  loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2;

  final _i3.Map<_i3.String, _i3.Object?> map;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2Json =
        this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2
            .toJson();
    if (_$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2Json,
    );
    final _$mapJson = this.map.map(
      (k, v) => _i3.MapEntry(
        k,
        _i1.encodeUnknownJson(
          v,
          context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel.Map',
        ),
      ),
    );
    _i1.mergeJsonObject(_$map, _$mapJson);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel: contains map types',
  );

  @_i3.override
  _i3.String toSimple({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool literal = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty)
        .toSimple(explode: explode, allowEmpty: allowEmpty, literal: literal);
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toForm(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
    _i3.Map<_i3.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toForm(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
      useQueryComponent: useQueryComponent,
      allowReserved: allowReserved,
      fieldEncodings: fieldEncodings,
      textEncoding: textEncoding,
    );
  }

  @_i3.override
  _i3.String toLabel({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    return parameterProperties(allowEmpty: allowEmpty)
        .toLabel(explode: explode, allowEmpty: allowEmpty);
  }

  @_i3.override
  _i3.String toMatrix(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    return parameterProperties(allowEmpty: allowEmpty)
        .toMatrix(paramName, explode: explode, allowEmpty: allowEmpty);
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toDeepObject(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toDeepObject(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toPipeDelimited(
    _i3.String paramName, {
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toPipeDelimited(
      paramName,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toSpaceDelimited(
    _i3.String paramName, {
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toSpaceDelimited(
      paramName,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other
            is LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel &&
        other.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2 ==
            this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2 &&
        _$deepEquals.equals(other.map, this.map);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2,
      deepEquals.hash(this.map),
    ]);
  }

  LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel
  Function({
    _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2?
    loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2,
    _i3.Map<_i3.String, _i3.Object?>? map,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2?
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2,
      _i3.Map<_i3.String, _i3.Object?>? map,
    }) => LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel(
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2:
          loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2 ??
          this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel2,
      map: map ?? this.map,
    );
  }
}
