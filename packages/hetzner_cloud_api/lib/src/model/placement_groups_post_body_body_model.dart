// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/placement_groups_post_body_body_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PlacementGroupsPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PlacementGroupsPostBodyBodyModel({
    required this.name,
    required this.$type,
    this.labels,
  });

  factory PlacementGroupsPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PlacementGroupsPostBodyBodyModel: contains complex types',
    );
  }

  factory PlacementGroupsPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PlacementGroupsPostBodyBodyModel');
    return PlacementGroupsPostBodyBodyModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'PlacementGroupsPostBodyBodyModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context: r'PlacementGroupsPostBodyBodyModel.labels',
        ),
        context: r'PlacementGroupsPostBodyBodyModel.labels',
      ),
      $type: _i4.PlacementGroupsPostBodyBodyTypeModel.fromJson(_$map[r'type']),
    );
  }

  factory PlacementGroupsPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PlacementGroupsPostBodyBodyModel: contains complex types',
    );
  }

  /// Name of the Placement Group.
  ///
  /// **Example**:
  /// ```
  /// my Placement Group
  /// ```
  final _i3.String name;

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

  /// Define the Placement Group Type.
  ///
  /// **Example**:
  /// ```
  /// spread
  /// ```
  final _i4.PlacementGroupsPostBodyBodyTypeModel $type;

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    if (this.labels != null) r'labels': this.labels,
    r'type': this.$type.toJson(),
  };

  PlacementGroupsPostBodyBodyModel Function({
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i4.PlacementGroupsPostBodyBodyTypeModel? $type,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i3.Object? labels = _sentinel,
      _i4.PlacementGroupsPostBodyBodyTypeModel? $type,
    }) => PlacementGroupsPostBodyBodyModel(
      name: name ?? this.name,
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      $type: $type ?? this.$type,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is PlacementGroupsPostBodyBodyModel &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.$type == this.$type;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      deepEquals.hash(this.labels),
      this.$type,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PlacementGroupsPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PlacementGroupsPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
