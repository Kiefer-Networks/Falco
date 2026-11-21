// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Protection of the [RRSet](#tag/zone-rrsets).
///
@_i2.immutable
class ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel({
    required this.change,
  });

  factory ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'change'},
      listKeys: {},
      context: r'ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel(
      change: _$values[r'change'].decodeSimpleBool(
        context:
            r'ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel.change',
      ),
    );
  }

  factory ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel',
    );
    return ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel(
      change: _$map[r'change'].decodeJsonBool(
        context:
            r'ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel.change',
      ),
    );
  }

  factory ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'change'},
      listKeys: {},
      context: r'ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel',
    );
    return ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel(
      change: _$values[r'change'].decodeFormBool(
        context:
            r'ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel.change',
      ),
    );
  }

  /// Prevent the Resource from being changed.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool change;

  @_i3.override
  _i3.Object? toJson() => {r'change': this.change};

  ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel Function({
    _i3.bool? change,
  })
  get copyWith {
    return ({_i3.bool? change}) =>
        ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel(
          change: change ?? this.change,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel &&
        other.change == this.change;
  }

  @_i3.override
  _i3.int get hashCode => this.change.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'change'] = _i1.PropertyValue.scalar(this.change.toString());
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
      r'Cannot uriEncode ZonesIdOrNameRrsetsGet200BodyRrsetsArrayProtectionModel: complex types cannot be URI-encoded',
    );
  }
}
