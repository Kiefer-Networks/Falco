// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_post201_body_zone_one_of_all_of_mode_model2.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesPost201BodyZoneOneOfAllOfModel6 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesPost201BodyZoneOneOfAllOfModel6({required this.mode});

  factory ZonesPost201BodyZoneOneOfAllOfModel6.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'mode'},
      listKeys: {},
      context: r'ZonesPost201BodyZoneOneOfAllOfModel6',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesPost201BodyZoneOneOfAllOfModel6(
      mode: _i4.ZonesPost201BodyZoneOneOfAllOfModeModel2.fromSimple(
        _$values[r'mode'],
        explode: explode,
      ),
    );
  }

  factory ZonesPost201BodyZoneOneOfAllOfModel6.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ZonesPost201BodyZoneOneOfAllOfModel6',
    );
    return ZonesPost201BodyZoneOneOfAllOfModel6(
      mode: _i4.ZonesPost201BodyZoneOneOfAllOfModeModel2.fromJson(
        _$map[r'mode'],
      ),
    );
  }

  factory ZonesPost201BodyZoneOneOfAllOfModel6.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'mode'},
      listKeys: {},
      context: r'ZonesPost201BodyZoneOneOfAllOfModel6',
    );
    return ZonesPost201BodyZoneOneOfAllOfModel6(
      mode: _i4.ZonesPost201BodyZoneOneOfAllOfModeModel2.fromForm(
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
  /// secondary
  /// ```
  final _i4.ZonesPost201BodyZoneOneOfAllOfModeModel2 mode;

  @_i3.override
  _i3.Object? toJson() => {r'mode': this.mode.toJson()};

  ZonesPost201BodyZoneOneOfAllOfModel6 Function({
    _i4.ZonesPost201BodyZoneOneOfAllOfModeModel2? mode,
  })
  get copyWith {
    return ({_i4.ZonesPost201BodyZoneOneOfAllOfModeModel2? mode}) =>
        ZonesPost201BodyZoneOneOfAllOfModel6(mode: mode ?? this.mode);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesPost201BodyZoneOneOfAllOfModel6 &&
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
      r'Cannot uriEncode ZonesPost201BodyZoneOneOfAllOfModel6: complex types cannot be URI-encoded',
    );
  }
}
