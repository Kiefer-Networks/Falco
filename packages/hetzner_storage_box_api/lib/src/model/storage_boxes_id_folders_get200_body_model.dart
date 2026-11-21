// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdFoldersGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdFoldersGet200BodyModel({required this.folders});

  factory StorageBoxesIdFoldersGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'folders'},
      listKeys: {r'folders'},
      context: r'StorageBoxesIdFoldersGet200BodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdFoldersGet200BodyModel(
      folders: _$values[r'folders'].decodeSimpleStringList(
        context: r'StorageBoxesIdFoldersGet200BodyModel.folders',
        isHeader: isHeader,
      ),
    );
  }

  factory StorageBoxesIdFoldersGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdFoldersGet200BodyModel',
    );
    return StorageBoxesIdFoldersGet200BodyModel(
      folders: _$map[r'folders'].decodeJsonList<_i3.String>(
        context: r'StorageBoxesIdFoldersGet200BodyModel.folders',
      ),
    );
  }

  factory StorageBoxesIdFoldersGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'folders'},
      listKeys: {r'folders'},
      context: r'StorageBoxesIdFoldersGet200BodyModel',
    );
    return StorageBoxesIdFoldersGet200BodyModel(
      folders: _$values[r'folders'].decodeFormStringList(
        context: r'StorageBoxesIdFoldersGet200BodyModel.folders',
      ),
    );
  }

  final _i3.List<_i3.String> folders;

  @_i3.override
  _i3.Object? toJson() => {r'folders': this.folders};

  StorageBoxesIdFoldersGet200BodyModel Function({_i3.List<_i3.String>? folders})
  get copyWith {
    return ({_i3.List<_i3.String>? folders}) =>
        StorageBoxesIdFoldersGet200BodyModel(folders: folders ?? this.folders);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is StorageBoxesIdFoldersGet200BodyModel &&
        _$deepEquals.equals(other.folders, this.folders);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return deepEquals.hash(this.folders);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'folders'] = _i1.PropertyValue.array(this.folders);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdFoldersGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
