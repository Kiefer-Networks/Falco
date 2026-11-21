// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Protection configuration for the Server.
@_i2.immutable
class ServersIdPut200BodyServerProtectionModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdPut200BodyServerProtectionModel({
    required this.delete,
    required this.rebuild,
  });

  factory ServersIdPut200BodyServerProtectionModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'delete', r'rebuild'},
      listKeys: {},
      context: r'ServersIdPut200BodyServerProtectionModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdPut200BodyServerProtectionModel(
      delete: _$values[r'delete'].decodeSimpleBool(
        context: r'ServersIdPut200BodyServerProtectionModel.delete',
      ),
      rebuild: _$values[r'rebuild'].decodeSimpleBool(
        context: r'ServersIdPut200BodyServerProtectionModel.rebuild',
      ),
    );
  }

  factory ServersIdPut200BodyServerProtectionModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersIdPut200BodyServerProtectionModel',
    );
    return ServersIdPut200BodyServerProtectionModel(
      delete: _$map[r'delete'].decodeJsonBool(
        context: r'ServersIdPut200BodyServerProtectionModel.delete',
      ),
      rebuild: _$map[r'rebuild'].decodeJsonBool(
        context: r'ServersIdPut200BodyServerProtectionModel.rebuild',
      ),
    );
  }

  factory ServersIdPut200BodyServerProtectionModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'delete', r'rebuild'},
      listKeys: {},
      context: r'ServersIdPut200BodyServerProtectionModel',
    );
    return ServersIdPut200BodyServerProtectionModel(
      delete: _$values[r'delete'].decodeFormBool(
        context: r'ServersIdPut200BodyServerProtectionModel.delete',
      ),
      rebuild: _$values[r'rebuild'].decodeFormBool(
        context: r'ServersIdPut200BodyServerProtectionModel.rebuild',
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

  ServersIdPut200BodyServerProtectionModel Function({
    _i3.bool? delete,
    _i3.bool? rebuild,
  })
  get copyWith {
    return ({_i3.bool? delete, _i3.bool? rebuild}) =>
        ServersIdPut200BodyServerProtectionModel(
          delete: delete ?? this.delete,
          rebuild: rebuild ?? this.rebuild,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdPut200BodyServerProtectionModel &&
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
      r'Cannot uriEncode ServersIdPut200BodyServerProtectionModel: complex types cannot be URI-encoded',
    );
  }
}
