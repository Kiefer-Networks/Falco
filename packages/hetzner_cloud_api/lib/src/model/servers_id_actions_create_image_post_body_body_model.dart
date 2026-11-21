// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_create_image_post_body_body_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsCreateImagePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsCreateImagePostBodyBodyModel({
    this.description,
    this.$type = $typeDefault,
    this.labels,
  });

  factory ServersIdActionsCreateImagePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdActionsCreateImagePostBodyBodyModel: contains complex types',
    );
  }

  factory ServersIdActionsCreateImagePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsCreateImagePostBodyBodyModel',
    );
    return ServersIdActionsCreateImagePostBodyBodyModel(
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'ServersIdActionsCreateImagePostBodyBodyModel.description',
      ),
      $type: _$map.containsKey(r'type')
          ? _i4.ServersIdActionsCreateImagePostBodyBodyTypeModel.fromJson(
              _$map[r'type'],
            )
          : $typeDefault,
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context: r'ServersIdActionsCreateImagePostBodyBodyModel.labels',
        ),
        context: r'ServersIdActionsCreateImagePostBodyBodyModel.labels',
      ),
    );
  }

  factory ServersIdActionsCreateImagePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdActionsCreateImagePostBodyBodyModel: contains complex types',
    );
  }

  static const _i4.ServersIdActionsCreateImagePostBodyBodyTypeModel
  $typeDefault = _i4.ServersIdActionsCreateImagePostBodyBodyTypeModel.snapshot;

  /// Description of the Image, will be auto-generated if not set.
  ///
  /// **Example**:
  /// ```
  /// my image
  /// ```
  final _i3.String? description;

  /// Type of Image to create.
  ///
  /// **Example**:
  /// ```
  /// snapshot
  /// ```
  final _i4.ServersIdActionsCreateImagePostBodyBodyTypeModel? $type;

  /// User-defined labels (`key/value` pairs) for the Resource.
  /// For more information, see "[Labels](#description/labels)".
  ///
  ///
  /// **Example**:
  /// ```json
  /// {
  ///   "environment": "prod",
  ///   "example.com/my": "label",
  ///   "just-a-key": ""
  /// }
  /// ```
  final _i3.Map<_i3.String, _i3.String>? labels;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.description != null) r'description': this.description,
    if (this.$type != null) r'type': this.$type?.toJson(),
    if (this.labels != null) r'labels': this.labels,
  };

  ServersIdActionsCreateImagePostBodyBodyModel Function({
    _i3.String? description,
    _i4.ServersIdActionsCreateImagePostBodyBodyTypeModel? $type,
    _i3.Map<_i3.String, _i3.String>? labels,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? description = _sentinel,
      _i3.Object? $type = _sentinel,
      _i3.Object? labels = _sentinel,
    }) => ServersIdActionsCreateImagePostBodyBodyModel(
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i4.ServersIdActionsCreateImagePostBodyBodyTypeModel?),
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is ServersIdActionsCreateImagePostBodyBodyModel &&
        other.description == this.description &&
        other.$type == this.$type &&
        _$deepEquals.equals(other.labels, this.labels);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.description,
      this.$type,
      deepEquals.hash(this.labels),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdActionsCreateImagePostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdActionsCreateImagePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
