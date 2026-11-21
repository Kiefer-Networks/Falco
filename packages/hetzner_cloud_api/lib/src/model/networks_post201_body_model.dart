// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_post201_body_network_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class NetworksPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksPost201BodyModel({this.network});

  factory NetworksPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for NetworksPost201BodyModel: contains complex types',
    );
  }

  factory NetworksPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'NetworksPost201BodyModel');
    return NetworksPost201BodyModel(
      network: _$map[r'network'] == null
          ? null
          : _i4.NetworksPost201BodyNetworkModel.fromJson(_$map[r'network']),
    );
  }

  factory NetworksPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for NetworksPost201BodyModel: contains complex types',
    );
  }

  final _i4.NetworksPost201BodyNetworkModel? network;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.network != null) r'network': this.network?.toJson(),
  };

  NetworksPost201BodyModel Function({
    _i4.NetworksPost201BodyNetworkModel? network,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? network = _sentinel}) => NetworksPost201BodyModel(
      network: _i3.identical(network, _sentinel)
          ? this.network
          : (network as _i4.NetworksPost201BodyNetworkModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is NetworksPost201BodyModel && other.network == this.network;
  }

  @_i3.override
  _i3.int get hashCode => this.network.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for NetworksPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode NetworksPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
