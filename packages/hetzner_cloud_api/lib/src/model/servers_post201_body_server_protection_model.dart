// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Protection configuration for the Server.
@_i2.immutable
class ServersPost201BodyServerProtectionModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersPost201BodyServerProtectionModel({
    required this.delete,
    required this.rebuild,
  });

  factory ServersPost201BodyServerProtectionModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'delete', r'rebuild'},
      listKeys: {},
      context: r'ServersPost201BodyServerProtectionModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersPost201BodyServerProtectionModel(
      delete: _$values[r'delete'].decodeSimpleBool(
        context: r'ServersPost201BodyServerProtectionModel.delete',
      ),
      rebuild: _$values[r'rebuild'].decodeSimpleBool(
        context: r'ServersPost201BodyServerProtectionModel.rebuild',
      ),
    );
  }

  factory ServersPost201BodyServerProtectionModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersPost201BodyServerProtectionModel',
    );
    return ServersPost201BodyServerProtectionModel(
      delete: _$map[r'delete'].decodeJsonBool(
        context: r'ServersPost201BodyServerProtectionModel.delete',
      ),
      rebuild: _$map[r'rebuild'].decodeJsonBool(
        context: r'ServersPost201BodyServerProtectionModel.rebuild',
      ),
    );
  }

  factory ServersPost201BodyServerProtectionModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'delete', r'rebuild'},
      listKeys: {},
      context: r'ServersPost201BodyServerProtectionModel',
    );
    return ServersPost201BodyServerProtectionModel(
      delete: _$values[r'delete'].decodeFormBool(
        context: r'ServersPost201BodyServerProtectionModel.delete',
      ),
      rebuild: _$values[r'rebuild'].decodeFormBool(
        context: r'ServersPost201BodyServerProtectionModel.rebuild',
      ),
    );
  }

  /// If true, prevents the Server from being deleted.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool delete;

  /// If true, prevents the Server from being rebuilt.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool rebuild;

  @_i3.override
  _i3.Object? toJson() => {r'delete': this.delete, r'rebuild': this.rebuild};

  ServersPost201BodyServerProtectionModel Function({
    _i3.bool? delete,
    _i3.bool? rebuild,
  })
  get copyWith {
    return ({_i3.bool? delete, _i3.bool? rebuild}) =>
        ServersPost201BodyServerProtectionModel(
          delete: delete ?? this.delete,
          rebuild: rebuild ?? this.rebuild,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersPost201BodyServerProtectionModel &&
        other.delete == this.delete &&
        other.rebuild == this.rebuild;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.delete, this.rebuild]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'delete'] = _i1.PropertyValue.scalar(this.delete.toString());
    _$result[r'rebuild'] = _i1.PropertyValue.scalar(this.rebuild.toString());
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
      r'Cannot uriEncode ServersPost201BodyServerProtectionModel: complex types cannot be URI-encoded',
    );
  }
}
