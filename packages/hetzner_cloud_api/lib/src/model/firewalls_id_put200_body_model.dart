// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/firewalls_id_put200_body_firewall_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsIdPut200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsIdPut200BodyModel({required this.firewall});

  factory FirewallsIdPut200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsIdPut200BodyModel: contains complex types',
    );
  }

  factory FirewallsIdPut200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FirewallsIdPut200BodyModel');
    return FirewallsIdPut200BodyModel(
      firewall: _i4.FirewallsIdPut200BodyFirewallModel.fromJson(
        _$map[r'firewall'],
      ),
    );
  }

  factory FirewallsIdPut200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsIdPut200BodyModel: contains complex types',
    );
  }

  final _i4.FirewallsIdPut200BodyFirewallModel firewall;

  @_i3.override
  _i3.Object? toJson() => {r'firewall': this.firewall.toJson()};

  FirewallsIdPut200BodyModel Function({
    _i4.FirewallsIdPut200BodyFirewallModel? firewall,
  })
  get copyWith {
    return ({_i4.FirewallsIdPut200BodyFirewallModel? firewall}) =>
        FirewallsIdPut200BodyModel(firewall: firewall ?? this.firewall);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FirewallsIdPut200BodyModel &&
        other.firewall == this.firewall;
  }

  @_i3.override
  _i3.int get hashCode => this.firewall.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsIdPut200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsIdPut200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
