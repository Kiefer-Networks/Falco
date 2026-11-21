// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_put200_body_zone_one_of_all_of_mode_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5({required this.mode});

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'mode'},
      listKeys: {},
      context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5(
      mode: _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModeModel.fromSimple(
        _$values[r'mode'],
        explode: explode,
      ),
    );
  }

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5',
    );
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5(
      mode: _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModeModel.fromJson(
        _$map[r'mode'],
      ),
    );
  }

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'mode'},
      listKeys: {},
      context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5',
    );
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5(
      mode: _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModeModel.fromForm(
        _$values[r'mode'],
        explode: explode,
      ),
    );
  }

  /// Mode of the [Zone](#tag/zones).
  ///
  /// For more information, see [Zone Modes](#tag/zones/zone-modes).
  ///
  ///
  /// **Example**:
  /// ```
  /// primary
  /// ```
  final _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModeModel mode;

  @_i3.override
  _i3.Object? toJson() => {r'mode': this.mode.toJson()};

  ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5 Function({
    _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModeModel? mode,
  })
  get copyWith {
    return ({_i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModeModel? mode}) =>
        ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5(mode: mode ?? this.mode);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5 &&
        other.mode == this.mode;
  }

  @_i3.override
  _i3.int get hashCode => this.mode.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'mode'] = _i1.PropertyValue.scalar(this.mode.toJson());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNamePut200BodyZoneOneOfAllOfModel5: complex types cannot be URI-encoded',
    );
  }
}
