// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel({
    required this.ttl,
  });

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ttl'},
      listKeys: {},
      context:
          r'ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel(
      ttl: _$values[r'ttl'].decodeSimpleNullableInt(
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel.ttl',
      ),
    );
  }

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel',
    );
    return ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel(
      ttl: _$map[r'ttl'].decodeJsonNullableInt(
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel.ttl',
      ),
    );
  }

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ttl'},
      listKeys: {},
      context:
          r'ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel',
    );
    return ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel(
      ttl: _$values[r'ttl'].decodeFormNullableInt(
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel.ttl',
      ),
    );
  }

  /// Time To Live (TTL) of the [RRSet](#tag/zone-rrsets).
  ///
  /// Must be in between 60s and 2147483647s.
  ///
  /// If not set, the [Zone's](#tag/zones) Default TTL is used.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 3600
  /// ```
  final _i3.int? ttl;

  @_i3.override
  _i3.Object? toJson() => {r'ttl': this.ttl};

  ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel Function({
    _i3.int? ttl,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? ttl = _sentinel}) =>
        ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel(
          ttl: _i3.identical(ttl, _sentinel) ? this.ttl : (ttl as _i3.int?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel &&
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
    if (this.ttl != null) {
      _$result[r'ttl'] = _i1.PropertyValue.scalar(this.ttl!.toString());
    }
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
      r'Cannot uriEncode ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
