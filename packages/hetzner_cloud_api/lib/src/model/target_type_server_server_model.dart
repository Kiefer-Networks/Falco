// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Server where the traffic should be routed to. Only present for target type "server".
@_i2.immutable
class TargetTypeServerServerModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TargetTypeServerServerModel({required this.id, required this.ip});

  factory TargetTypeServerServerModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'ip'},
      listKeys: {},
      context: r'TargetTypeServerServerModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return TargetTypeServerServerModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'TargetTypeServerServerModel.id',
      ),
      ip: _$values[r'ip'].decodeSimpleString(
        context: r'TargetTypeServerServerModel.ip',
      ),
    );
  }

  factory TargetTypeServerServerModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TargetTypeServerServerModel');
    return TargetTypeServerServerModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'TargetTypeServerServerModel.id',
      ),
      ip: _$map[r'ip'].decodeJsonString(
        context: r'TargetTypeServerServerModel.ip',
      ),
    );
  }

  factory TargetTypeServerServerModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'ip'},
      listKeys: {},
      context: r'TargetTypeServerServerModel',
    );
    return TargetTypeServerServerModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'TargetTypeServerServerModel.id',
      ),
      ip: _$values[r'ip'].decodeFormString(
        context: r'TargetTypeServerServerModel.ip',
      ),
    );
  }

  /// ID of the Server.
  ///
  /// **Example**:
  /// ```json
  /// 80
  /// ```
  final _i3.int id;

  /// IP of the Server that the traffic is routed to. Either the Server's primary IPv4 or, if an IPv6 was specified when adding the target, an IPv6 within the Server's /64 subnet.
  ///
  /// **Example**:
  /// ```
  /// 2001:db8::1
  /// ```
  final _i3.String ip;

  @_i3.override
  _i3.Object? toJson() => {r'id': this.id, r'ip': this.ip};

  TargetTypeServerServerModel Function({_i3.int? id, _i3.String? ip})
  get copyWith {
    return ({_i3.int? id, _i3.String? ip}) =>
        TargetTypeServerServerModel(id: id ?? this.id, ip: ip ?? this.ip);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TargetTypeServerServerModel &&
        other.id == this.id &&
        other.ip == this.ip;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.id, this.ip]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    _$result[r'ip'] = _i1.PropertyValue.scalar(this.ip);
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
      r'Cannot uriEncode TargetTypeServerServerModel: complex types cannot be URI-encoded',
    );
  }
}
