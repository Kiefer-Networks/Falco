// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Information about the Server the Image was created from.
@_i2.immutable
class $RawServersPost201BodyServerImageCreatedFromModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawServersPost201BodyServerImageCreatedFromModel({
    required this.id,
    required this.name,
  });

  factory $RawServersPost201BodyServerImageCreatedFromModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'name'},
      listKeys: {},
      context: r'$RawServersPost201BodyServerImageCreatedFromModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return $RawServersPost201BodyServerImageCreatedFromModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'$RawServersPost201BodyServerImageCreatedFromModel.id',
      ),
      name: _$values[r'name'].decodeSimpleString(
        context: r'$RawServersPost201BodyServerImageCreatedFromModel.name',
      ),
    );
  }

  factory $RawServersPost201BodyServerImageCreatedFromModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawServersPost201BodyServerImageCreatedFromModel',
    );
    return $RawServersPost201BodyServerImageCreatedFromModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'$RawServersPost201BodyServerImageCreatedFromModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'$RawServersPost201BodyServerImageCreatedFromModel.name',
      ),
    );
  }

  factory $RawServersPost201BodyServerImageCreatedFromModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'name'},
      listKeys: {},
      context: r'$RawServersPost201BodyServerImageCreatedFromModel',
    );
    return $RawServersPost201BodyServerImageCreatedFromModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'$RawServersPost201BodyServerImageCreatedFromModel.id',
      ),
      name: _$values[r'name'].decodeFormString(
        context: r'$RawServersPost201BodyServerImageCreatedFromModel.name',
      ),
    );
  }

  /// ID of the Server the Image was created from.
  ///
  /// **Example**:
  /// ```json
  /// 1
  /// ```
  final _i3.int id;

  /// Server name at the time the Image was created.
  ///
  /// **Example**:
  /// ```
  /// Server
  /// ```
  final _i3.String name;

  @_i3.override
  _i3.Object? toJson() => {r'id': this.id, r'name': this.name};

  $RawServersPost201BodyServerImageCreatedFromModel Function({
    _i3.int? id,
    _i3.String? name,
  })
  get copyWith {
    return ({_i3.int? id, _i3.String? name}) =>
        $RawServersPost201BodyServerImageCreatedFromModel(
          id: id ?? this.id,
          name: name ?? this.name,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is $RawServersPost201BodyServerImageCreatedFromModel &&
        other.id == this.id &&
        other.name == this.name;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.id, this.name]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    _$result[r'name'] = _i1.PropertyValue.scalar(this.name);
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
      r'Cannot uriEncode $RawServersPost201BodyServerImageCreatedFromModel: complex types cannot be URI-encoded',
    );
  }
}

typedef ServersPost201BodyServerImageCreatedFromModel =
    $RawServersPost201BodyServerImageCreatedFromModel?;
