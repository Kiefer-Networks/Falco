// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/volumes_id_actions_attach_post_body_body_assignee_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class VolumesIdActionsAttachPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const VolumesIdActionsAttachPostBodyBodyModel({
    required this.assignee,
    this.server,
    this.automount,
  });

  factory VolumesIdActionsAttachPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for VolumesIdActionsAttachPostBodyBodyModel: contains complex types',
    );
  }

  factory VolumesIdActionsAttachPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'VolumesIdActionsAttachPostBodyBodyModel',
    );
    return VolumesIdActionsAttachPostBodyBodyModel(
      server: _$map[r'server'].decodeJsonNullableInt(
        context: r'VolumesIdActionsAttachPostBodyBodyModel.server',
      ),
      assignee: _i4.VolumesIdActionsAttachPostBodyBodyAssigneeModel.fromJson(
        _$map[r'assignee'],
      ),
      automount: _$map[r'automount'].decodeJsonNullableBool(
        context: r'VolumesIdActionsAttachPostBodyBodyModel.automount',
      ),
    );
  }

  factory VolumesIdActionsAttachPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for VolumesIdActionsAttachPostBodyBodyModel: contains complex types',
    );
  }

  /// This field is deprecated, use the `assignee` field with `server` as the `type` instead.
  ///
  /// ID of the Server the Volume will be attached to.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 43
  /// ```
  @_i3.Deprecated('This property is deprecated.')
  final _i3.int? server;

  /// Resource the Volume will be attached to.
  final _i4.VolumesIdActionsAttachPostBodyBodyAssigneeModel assignee;

  /// Auto-mount the Volume after attaching it.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool? automount;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.server != null) r'server': this.server,
    r'assignee': this.assignee.toJson(),
    if (this.automount != null) r'automount': this.automount,
  };

  VolumesIdActionsAttachPostBodyBodyModel Function({
    _i3.int? server,
    _i4.VolumesIdActionsAttachPostBodyBodyAssigneeModel? assignee,
    _i3.bool? automount,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? server = _sentinel,
      _i4.VolumesIdActionsAttachPostBodyBodyAssigneeModel? assignee,
      _i3.Object? automount = _sentinel,
    }) => VolumesIdActionsAttachPostBodyBodyModel(
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server as _i3.int?),
      assignee: assignee ?? this.assignee,
      automount: _i3.identical(automount, _sentinel)
          ? this.automount
          : (automount as _i3.bool?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VolumesIdActionsAttachPostBodyBodyModel &&
        other.server == this.server &&
        other.assignee == this.assignee &&
        other.automount == this.automount;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.server, this.assignee, this.automount]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for VolumesIdActionsAttachPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode VolumesIdActionsAttachPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
