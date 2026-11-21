// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel({
    required this.id,
    required this.$type,
  });

  factory LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'type'},
      listKeys: {},
      context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.id',
      ),
      $type: _$values[r'type'].decodeSimpleString(
        context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.type',
      ),
    );
  }

  factory LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel',
    );
    return LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.id',
      ),
      $type: _$map[r'type'].decodeJsonString(
        context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.type',
      ),
    );
  }

  factory LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'type'},
      listKeys: {},
      context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel',
    );
    return LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.id',
      ),
      $type: _$values[r'type'].decodeFormString(
        context: r'LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel.type',
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

  LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel
  Function({_i3.int? id, _i3.String? $type})
  get copyWith {
    return ({_i3.int? id, _i3.String? $type}) =>
        LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel(
          id: id ?? this.id,
          $type: $type ?? this.$type,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel &&
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
      r'Cannot uriEncode LoadBalancersIdActionsRemoveTargetPost201BodyActionResourcesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
