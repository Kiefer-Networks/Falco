// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Protection configuration for the Resource.
@_i2.immutable
class NetworksIdPut200BodyNetworkProtectionModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksIdPut200BodyNetworkProtectionModel({required this.delete});

  factory NetworksIdPut200BodyNetworkProtectionModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'delete'},
      listKeys: {},
      context: r'NetworksIdPut200BodyNetworkProtectionModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return NetworksIdPut200BodyNetworkProtectionModel(
      delete: _$values[r'delete'].decodeSimpleBool(
        context: r'NetworksIdPut200BodyNetworkProtectionModel.delete',
      ),
    );
  }

  factory NetworksIdPut200BodyNetworkProtectionModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'NetworksIdPut200BodyNetworkProtectionModel',
    );
    return NetworksIdPut200BodyNetworkProtectionModel(
      delete: _$map[r'delete'].decodeJsonBool(
        context: r'NetworksIdPut200BodyNetworkProtectionModel.delete',
      ),
    );
  }

  factory NetworksIdPut200BodyNetworkProtectionModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'delete'},
      listKeys: {},
      context: r'NetworksIdPut200BodyNetworkProtectionModel',
    );
    return NetworksIdPut200BodyNetworkProtectionModel(
      delete: _$values[r'delete'].decodeFormBool(
        context: r'NetworksIdPut200BodyNetworkProtectionModel.delete',
      ),
    );
  }

  /// Prevent the Resource from being deleted.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool delete;

  @_i3.override
  _i3.Object? toJson() => {r'delete': this.delete};

  NetworksIdPut200BodyNetworkProtectionModel Function({_i3.bool? delete})
  get copyWith {
    return ({_i3.bool? delete}) => NetworksIdPut200BodyNetworkProtectionModel(
      delete: delete ?? this.delete,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is NetworksIdPut200BodyNetworkProtectionModel &&
        other.delete == this.delete;
  }

  @_i3.override
  _i3.int get hashCode => this.delete.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'delete'] = _i1.PropertyValue.scalar(this.delete.toString());
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
      r'Cannot uriEncode NetworksIdPut200BodyNetworkProtectionModel: complex types cannot be URI-encoded',
    );
  }
}
