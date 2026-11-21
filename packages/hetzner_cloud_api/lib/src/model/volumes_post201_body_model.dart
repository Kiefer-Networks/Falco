// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/volumes_post201_body_action_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/volumes_post201_body_next_actions_array_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/volumes_post201_body_volume_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class VolumesPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const VolumesPost201BodyModel({
    required this.volume,
    required this.action,
    required this.nextActions,
  });

  factory VolumesPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for VolumesPost201BodyModel: contains complex types',
    );
  }

  factory VolumesPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'VolumesPost201BodyModel');
    return VolumesPost201BodyModel(
      volume: _i4.VolumesPost201BodyVolumeModel.fromJson(_$map[r'volume']),
      action: _i5.VolumesPost201BodyActionModel.fromJson(_$map[r'action']),
      nextActions: _$map[r'next_actions']
          .decodeJsonList<_i3.Object?>(
            context: r'VolumesPost201BodyModel.next_actions',
          )
          .map(_i6.VolumesPost201BodyNextActionsArrayModel.fromJson)
          .toList(),
    );
  }

  factory VolumesPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for VolumesPost201BodyModel: contains complex types',
    );
  }

  final _i4.VolumesPost201BodyVolumeModel volume;

  final _i5.VolumesPost201BodyActionModel action;

  final _i3.List<_i6.VolumesPost201BodyNextActionsArrayModel> nextActions;

  @_i3.override
  _i3.Object? toJson() => {
    r'volume': this.volume.toJson(),
    r'action': this.action.toJson(),
    r'next_actions': this.nextActions.map((e) => e.toJson()).toList(),
  };

  VolumesPost201BodyModel Function({
    _i4.VolumesPost201BodyVolumeModel? volume,
    _i5.VolumesPost201BodyActionModel? action,
    _i3.List<_i6.VolumesPost201BodyNextActionsArrayModel>? nextActions,
  })
  get copyWith {
    return ({
      _i4.VolumesPost201BodyVolumeModel? volume,
      _i5.VolumesPost201BodyActionModel? action,
      _i3.List<_i6.VolumesPost201BodyNextActionsArrayModel>? nextActions,
    }) => VolumesPost201BodyModel(
      volume: volume ?? this.volume,
      action: action ?? this.action,
      nextActions: nextActions ?? this.nextActions,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is VolumesPost201BodyModel &&
        other.volume == this.volume &&
        other.action == this.action &&
        _$deepEquals.equals(other.nextActions, this.nextActions);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.volume,
      this.action,
      deepEquals.hash(this.nextActions),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for VolumesPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode VolumesPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
