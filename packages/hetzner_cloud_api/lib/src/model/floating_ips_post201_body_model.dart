// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/floating_ips_post201_body_action_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/floating_ips_post201_body_floating_ip_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FloatingIpsPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FloatingIpsPost201BodyModel({required this.floatingIp, this.action});

  factory FloatingIpsPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FloatingIpsPost201BodyModel: contains complex types',
    );
  }

  factory FloatingIpsPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FloatingIpsPost201BodyModel');
    return FloatingIpsPost201BodyModel(
      floatingIp: _i4.FloatingIpsPost201BodyFloatingIpModel.fromJson(
        _$map[r'floating_ip'],
      ),
      action: _$map[r'action'] == null
          ? null
          : _i5.FloatingIpsPost201BodyActionModel.fromJson(_$map[r'action']),
    );
  }

  factory FloatingIpsPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FloatingIpsPost201BodyModel: contains complex types',
    );
  }

  final _i4.FloatingIpsPost201BodyFloatingIpModel floatingIp;

  /// Action will only be returned if the [Floating IP](#tag/floating-ips) is getting assigned.
  ///
  final _i5.FloatingIpsPost201BodyActionModel? action;

  @_i3.override
  _i3.Object? toJson() => {
    r'floating_ip': this.floatingIp.toJson(),
    r'action': this.action?.toJson(),
  };

  FloatingIpsPost201BodyModel Function({
    _i4.FloatingIpsPost201BodyFloatingIpModel? floatingIp,
    _i5.FloatingIpsPost201BodyActionModel? action,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.FloatingIpsPost201BodyFloatingIpModel? floatingIp,
      _i3.Object? action = _sentinel,
    }) => FloatingIpsPost201BodyModel(
      floatingIp: floatingIp ?? this.floatingIp,
      action: _i3.identical(action, _sentinel)
          ? this.action
          : (action as _i5.FloatingIpsPost201BodyActionModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FloatingIpsPost201BodyModel &&
        other.floatingIp == this.floatingIp &&
        other.action == this.action;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.floatingIp, this.action]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FloatingIpsPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FloatingIpsPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
