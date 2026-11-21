// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel({
    required this.values,
  });

  factory LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel: contains complex types',
    );
  }

  factory LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel',
    );
    return LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel(
      values: _$map[r'values']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel.values',
          )
          .map(
            (e) => e.decodeJsonList<_i3.Object?>(
              context: r'LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel.values',
            ),
          )
          .toList(),
    );
  }

  factory LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel: contains complex types',
    );
  }

  /// Metrics timestamps with values.
  final _i3.List<_i3.List<_i3.Object?>> values;

  @_i3.override
  _i3.Object? toJson() => {
    r'values': this.values
        .map(
          (e) => e
              .map(
                (e) => _i1.encodeUnknownJson(
                  e,
                  context: r'LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel.values',
                ),
              )
              .toList(),
        )
        .toList(),
  };

  LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel Function({
    _i3.List<_i3.List<_i3.Object?>>? values,
  })
  get copyWith {
    return ({_i3.List<_i3.List<_i3.Object?>>? values}) =>
        LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel(
          values: values ?? this.values,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel &&
        _$deepEquals.equals(other.values, this.values);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return deepEquals.hash(this.values);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdMetricsGet200BodyMetricsTimeSeriesMapModel: complex types cannot be URI-encoded',
    );
  }
}
