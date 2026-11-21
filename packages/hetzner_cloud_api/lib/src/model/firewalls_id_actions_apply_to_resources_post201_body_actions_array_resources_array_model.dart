// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel({
    required this.id,
    required this.$type,
  });

  factory FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'type'},
      listKeys: {},
      context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.id',
      ),
      $type: _$values[r'type'].decodeSimpleString(
        context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.type',
      ),
    );
  }

  factory FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel',
    );
    return FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.id',
      ),
      $type: _$map[r'type'].decodeJsonString(
        context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.type',
      ),
    );
  }

  factory FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'type'},
      listKeys: {},
      context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel',
    );
    return FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.id',
      ),
      $type: _$values[r'type'].decodeFormString(
        context: r'FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel.type',
      ),
    );
  }

  /// ID of the Resource.
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Type of the Resource.
  ///
  /// **Example**:
  /// ```
  /// server
  /// ```
  final _i3.String $type;

  @_i3.override
  _i3.Object? toJson() => {r'id': this.id, r'type': this.$type};

  FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel
  Function({_i3.int? id, _i3.String? $type})
  get copyWith {
    return ({_i3.int? id, _i3.String? $type}) =>
        FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel(
          id: id ?? this.id,
          $type: $type ?? this.$type,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel &&
        other.id == this.id &&
        other.$type == this.$type;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.id, this.$type]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    _$result[r'type'] = _i1.PropertyValue.scalar(this.$type);
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
      r'Cannot uriEncode FirewallsIdActionsApplyToResourcesPost201BodyActionsArrayResourcesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
