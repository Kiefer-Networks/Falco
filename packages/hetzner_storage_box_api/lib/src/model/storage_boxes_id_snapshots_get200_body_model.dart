// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_get200_body_snapshots_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSnapshotsGet200BodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSnapshotsGet200BodyModel({required this.snapshots});

  factory StorageBoxesIdSnapshotsGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesIdSnapshotsGet200BodyModel: contains complex types',
    );
  }

  factory StorageBoxesIdSnapshotsGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSnapshotsGet200BodyModel',
    );
    return StorageBoxesIdSnapshotsGet200BodyModel(
      snapshots: _$map[r'snapshots']
          .decodeJsonList<_i3.Object?>(
            context: r'StorageBoxesIdSnapshotsGet200BodyModel.snapshots',
          )
          .map(
            _i4.StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.fromJson,
          )
          .toList(),
    );
  }

  factory StorageBoxesIdSnapshotsGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesIdSnapshotsGet200BodyModel: contains complex types',
    );
  }

  final _i3.List<_i4.StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel>
  snapshots;

  @_i3.override
  _i3.Object? toJson() => {
    r'snapshots': this.snapshots.map((e) => e.toJson()).toList(),
  };

  StorageBoxesIdSnapshotsGet200BodyModel Function({
    _i3.List<_i4.StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel>?
    snapshots,
  })
  get copyWith {
    return ({
      _i3.List<_i4.StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel>?
      snapshots,
    }) => StorageBoxesIdSnapshotsGet200BodyModel(
      snapshots: snapshots ?? this.snapshots,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is StorageBoxesIdSnapshotsGet200BodyModel &&
        _$deepEquals.equals(other.snapshots, this.snapshots);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return deepEquals.hash(this.snapshots);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesIdSnapshotsGet200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdSnapshotsGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
