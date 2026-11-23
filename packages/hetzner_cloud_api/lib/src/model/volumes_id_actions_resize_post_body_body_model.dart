// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class VolumesIdActionsResizePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const VolumesIdActionsResizePostBodyBodyModel({required this.size});

  factory VolumesIdActionsResizePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'size'},
      listKeys: {},
      context: r'VolumesIdActionsResizePostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return VolumesIdActionsResizePostBodyBodyModel(
      size: _$values[r'size'].decodeSimpleDouble(
        context: r'VolumesIdActionsResizePostBodyBodyModel.size',
      ),
    );
  }

  factory VolumesIdActionsResizePostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'VolumesIdActionsResizePostBodyBodyModel',
    );
    return VolumesIdActionsResizePostBodyBodyModel(
      size: _$map[r'size'].decodeJsonNum(
        context: r'VolumesIdActionsResizePostBodyBodyModel.size',
      ),
    );
  }

  factory VolumesIdActionsResizePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'size'},
      listKeys: {},
      context: r'VolumesIdActionsResizePostBodyBodyModel',
    );
    return VolumesIdActionsResizePostBodyBodyModel(
      size: _$values[r'size'].decodeFormDouble(
        context: r'VolumesIdActionsResizePostBodyBodyModel.size',
      ),
    );
  }

  /// New Volume size in GB (must be greater than current size).
  ///
  /// **Example**:
  /// ```json
  /// 50
  /// ```
  final _i3.num size;

  @_i3.override
  _i3.Object? toJson() => {r'size': this.size};

  VolumesIdActionsResizePostBodyBodyModel Function({_i3.num? size})
  get copyWith {
    return ({_i3.num? size}) =>
        VolumesIdActionsResizePostBodyBodyModel(size: size ?? this.size);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VolumesIdActionsResizePostBodyBodyModel &&
        other.size == this.size;
  }

  @_i3.override
  _i3.int get hashCode => this.size.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'size'] = _i1.PropertyValue.scalar(this.size.toString());
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
      r'Cannot uriEncode VolumesIdActionsResizePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
