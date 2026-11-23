// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameActionsChangeTtlPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameActionsChangeTtlPostBodyBodyModel({this.ttl = ttlDefault});

  factory ZonesIdOrNameActionsChangeTtlPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ttl'},
      listKeys: {},
      context: r'ZonesIdOrNameActionsChangeTtlPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesIdOrNameActionsChangeTtlPostBodyBodyModel(
      ttl: _$values.containsKey(r'ttl')
          ? _$values[r'ttl'].decodeSimpleInt(
              context: r'ZonesIdOrNameActionsChangeTtlPostBodyBodyModel.ttl',
            )
          : ttlDefault,
    );
  }

  factory ZonesIdOrNameActionsChangeTtlPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameActionsChangeTtlPostBodyBodyModel',
    );
    return ZonesIdOrNameActionsChangeTtlPostBodyBodyModel(
      ttl: _$map.containsKey(r'ttl')
          ? _$map[r'ttl'].decodeJsonInt(
              context: r'ZonesIdOrNameActionsChangeTtlPostBodyBodyModel.ttl',
            )
          : ttlDefault,
    );
  }

  factory ZonesIdOrNameActionsChangeTtlPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ttl'},
      listKeys: {},
      context: r'ZonesIdOrNameActionsChangeTtlPostBodyBodyModel',
    );
    return ZonesIdOrNameActionsChangeTtlPostBodyBodyModel(
      ttl: _$values.containsKey(r'ttl')
          ? _$values[r'ttl'].decodeFormInt(
              context: r'ZonesIdOrNameActionsChangeTtlPostBodyBodyModel.ttl',
            )
          : ttlDefault,
    );
  }

  static const _i3.int ttlDefault = 3600;

  /// Default Time To Live (TTL) of the [Zone](#tag/zones).
  ///
  /// Must be in between 60s and 2147483647s.
  ///
  /// This TTL is used for [RRSets](#tag/zone-rrsets) that do not explicitly define a TTL.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 10800
  /// ```
  final _i3.int ttl;

  @_i3.override
  _i3.Object? toJson() => {r'ttl': this.ttl};

  ZonesIdOrNameActionsChangeTtlPostBodyBodyModel Function({_i3.int? ttl})
  get copyWith {
    return ({_i3.int? ttl}) =>
        ZonesIdOrNameActionsChangeTtlPostBodyBodyModel(ttl: ttl ?? this.ttl);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNameActionsChangeTtlPostBodyBodyModel &&
        other.ttl == this.ttl;
  }

  @_i3.override
  _i3.int get hashCode => this.ttl.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'ttl'] = _i1.PropertyValue.scalar(this.ttl.toString());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameActionsChangeTtlPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
