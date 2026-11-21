// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/placement_groups_post201_body_action_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/placement_groups_post201_body_placement_group_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PlacementGroupsPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PlacementGroupsPost201BodyModel({
    required this.placementGroup,
    this.action,
  });

  factory PlacementGroupsPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PlacementGroupsPost201BodyModel: contains complex types',
    );
  }

  factory PlacementGroupsPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PlacementGroupsPost201BodyModel');
    return PlacementGroupsPost201BodyModel(
      placementGroup:
          _i4.PlacementGroupsPost201BodyPlacementGroupModel.fromJson(
            _$map[r'placement_group'],
          ),
      action: _$map[r'action'] == null
          ? null
          : _i5.PlacementGroupsPost201BodyActionModel.fromJson(
              _$map[r'action'],
            ),
    );
  }

  factory PlacementGroupsPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PlacementGroupsPost201BodyModel: contains complex types',
    );
  }

  final _i4.PlacementGroupsPost201BodyPlacementGroupModel placementGroup;

  final _i5.PlacementGroupsPost201BodyActionModel? action;

  @_i3.override
  _i3.Object? toJson() => {
    r'placement_group': this.placementGroup.toJson(),
    r'action': this.action?.toJson(),
  };

  PlacementGroupsPost201BodyModel Function({
    _i4.PlacementGroupsPost201BodyPlacementGroupModel? placementGroup,
    _i5.PlacementGroupsPost201BodyActionModel? action,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.PlacementGroupsPost201BodyPlacementGroupModel? placementGroup,
      _i3.Object? action = _sentinel,
    }) => PlacementGroupsPost201BodyModel(
      placementGroup: placementGroup ?? this.placementGroup,
      action: _i3.identical(action, _sentinel)
          ? this.action
          : (action as _i5.PlacementGroupsPost201BodyActionModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PlacementGroupsPost201BodyModel &&
        other.placementGroup == this.placementGroup &&
        other.action == this.action;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.placementGroup, this.action]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PlacementGroupsPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PlacementGroupsPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
