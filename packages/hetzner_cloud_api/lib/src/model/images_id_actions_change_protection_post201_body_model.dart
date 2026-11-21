// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/images_id_actions_change_protection_post201_body_action_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Response for a created [Action](#description/actions).
///
/// Make sure to wait for the [Action](#description/actions) completion to ensure your changes are applied.
///
@_i2.immutable
class ImagesIdActionsChangeProtectionPost201BodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ImagesIdActionsChangeProtectionPost201BodyModel({required this.action});

  factory ImagesIdActionsChangeProtectionPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ImagesIdActionsChangeProtectionPost201BodyModel: contains complex types',
    );
  }

  factory ImagesIdActionsChangeProtectionPost201BodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ImagesIdActionsChangeProtectionPost201BodyModel',
    );
    return ImagesIdActionsChangeProtectionPost201BodyModel(
      action:
          _i4.ImagesIdActionsChangeProtectionPost201BodyActionModel.fromJson(
            _$map[r'action'],
          ),
    );
  }

  factory ImagesIdActionsChangeProtectionPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ImagesIdActionsChangeProtectionPost201BodyModel: contains complex types',
    );
  }

  final _i4.ImagesIdActionsChangeProtectionPost201BodyActionModel action;

  @_i3.override
  _i3.Object? toJson() => {r'action': this.action.toJson()};

  ImagesIdActionsChangeProtectionPost201BodyModel Function({
    _i4.ImagesIdActionsChangeProtectionPost201BodyActionModel? action,
  })
  get copyWith {
    return ({
      _i4.ImagesIdActionsChangeProtectionPost201BodyActionModel? action,
    }) => ImagesIdActionsChangeProtectionPost201BodyModel(
      action: action ?? this.action,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImagesIdActionsChangeProtectionPost201BodyModel &&
        other.action == this.action;
  }

  @_i3.override
  _i3.int get hashCode => this.action.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ImagesIdActionsChangeProtectionPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ImagesIdActionsChangeProtectionPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
