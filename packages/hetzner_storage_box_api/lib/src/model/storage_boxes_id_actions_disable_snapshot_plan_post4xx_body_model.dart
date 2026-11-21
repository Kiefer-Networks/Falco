// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_disable_snapshot_plan_post4xx_body_error_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// **Example**:
/// ```json
/// {
///   "error": {
///     "code": "unauthorized",
///     "message": "unable to authenticate",
///     "details": null
///   }
/// }
/// ```
@_i2.immutable
class StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel({
    required this.error,
  });

  factory StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel: contains complex types',
    );
  }

  factory StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel',
    );
    return StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel(
      error:
          _i4.StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyErrorModel.fromJson(
            _$map[r'error'],
          ),
    );
  }

  factory StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel: contains complex types',
    );
  }

  final _i4.StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyErrorModel error;

  @_i3.override
  _i3.Object? toJson() => {r'error': this.error.toJson()};

  StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel Function({
    _i4.StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyErrorModel? error,
  })
  get copyWith {
    return ({
      _i4.StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyErrorModel? error,
    }) => StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel(
      error: error ?? this.error,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel &&
        other.error == this.error;
  }

  @_i3.override
  _i3.int get hashCode => this.error.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel: complex types cannot be URI-encoded',
    );
  }
}
