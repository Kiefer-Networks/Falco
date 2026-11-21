// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel({
    required this.snapshot,
  });

  factory StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'snapshot'},
      listKeys: {},
      context: r'StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel(
      snapshot: _$values[r'snapshot'].decodeSimpleString(
        context:
            r'StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel.snapshot',
      ),
    );
  }

  factory StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel',
    );
    return StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel(
      snapshot: _$map[r'snapshot'].decodeJsonString(
        context:
            r'StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel.snapshot',
      ),
    );
  }

  factory StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'snapshot'},
      listKeys: {},
      context: r'StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel',
    );
    return StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel(
      snapshot: _$values[r'snapshot'].decodeFormString(
        context:
            r'StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel.snapshot',
      ),
    );
  }

  /// ID or Name of the [Storage Box Snapshot](#tag/storage-box-snapshots).
  ///
  /// **Example**:
  /// ```
  /// my-snapshot
  /// ```
  final _i3.String snapshot;

  @_i3.override
  _i3.Object? toJson() => {r'snapshot': this.snapshot};

  StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel Function({
    _i3.String? snapshot,
  })
  get copyWith {
    return ({_i3.String? snapshot}) =>
        StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel(
          snapshot: snapshot ?? this.snapshot,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel &&
        other.snapshot == this.snapshot;
  }

  @_i3.override
  _i3.int get hashCode => this.snapshot.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'snapshot'] = _i1.PropertyValue.scalar(this.snapshot);
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
      r'Cannot uriEncode StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
