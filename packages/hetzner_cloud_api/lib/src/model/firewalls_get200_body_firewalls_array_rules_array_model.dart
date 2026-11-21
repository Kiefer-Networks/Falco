// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/firewalls_get200_body_firewalls_array_rules_array_direction_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/firewalls_get200_body_firewalls_array_rules_array_protocol_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsGet200BodyFirewallsArrayRulesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsGet200BodyFirewallsArrayRulesArrayModel({
    required this.direction,
    required this.sourceIps,
    required this.destinationIps,
    required this.protocol,
    required this.port,
    this.description,
  });

  factory FirewallsGet200BodyFirewallsArrayRulesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'description',
        r'direction',
        r'source_ips',
        r'destination_ips',
        r'protocol',
        r'port',
      },
      listKeys: {r'source_ips', r'destination_ips'},
      context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return FirewallsGet200BodyFirewallsArrayRulesArrayModel(
      description: _$values[r'description'].decodeSimpleNullableString(
        context:
            r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.description',
      ),
      direction:
          _i4.FirewallsGet200BodyFirewallsArrayRulesArrayDirectionModel.fromSimple(
            _$values[r'direction'],
            explode: explode,
          ),
      sourceIps: _$values[r'source_ips'].decodeSimpleStringList(
        context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.source_ips',
        isHeader: isHeader,
      ),
      destinationIps: _$values[r'destination_ips'].decodeSimpleStringList(
        context:
            r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.destination_ips',
        isHeader: isHeader,
      ),
      protocol:
          _i5.FirewallsGet200BodyFirewallsArrayRulesArrayProtocolModel.fromSimple(
            _$values[r'protocol'],
            explode: explode,
          ),
      port: _$values[r'port'].decodeSimpleNullableString(
        context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.port',
      ),
    );
  }

  factory FirewallsGet200BodyFirewallsArrayRulesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel',
    );
    return FirewallsGet200BodyFirewallsArrayRulesArrayModel(
      description: _$map[r'description'].decodeJsonNullableString(
        context:
            r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.description',
      ),
      direction:
          _i4.FirewallsGet200BodyFirewallsArrayRulesArrayDirectionModel.fromJson(
            _$map[r'direction'],
          ),
      sourceIps: _$map[r'source_ips'].decodeJsonList<_i3.String>(
        context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.source_ips',
      ),
      destinationIps: _$map[r'destination_ips'].decodeJsonList<_i3.String>(
        context:
            r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.destination_ips',
      ),
      protocol:
          _i5.FirewallsGet200BodyFirewallsArrayRulesArrayProtocolModel.fromJson(
            _$map[r'protocol'],
          ),
      port: _$map[r'port'].decodeJsonNullableString(
        context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.port',
      ),
    );
  }

  factory FirewallsGet200BodyFirewallsArrayRulesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'description',
        r'direction',
        r'source_ips',
        r'destination_ips',
        r'protocol',
        r'port',
      },
      listKeys: {r'source_ips', r'destination_ips'},
      context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel',
    );
    return FirewallsGet200BodyFirewallsArrayRulesArrayModel(
      description: _$values[r'description'].decodeFormNullableString(
        context:
            r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.description',
      ),
      direction:
          _i4.FirewallsGet200BodyFirewallsArrayRulesArrayDirectionModel.fromForm(
            _$values[r'direction'],
            explode: explode,
          ),
      sourceIps: _$values[r'source_ips'].decodeFormStringList(
        context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.source_ips',
      ),
      destinationIps: _$values[r'destination_ips'].decodeFormStringList(
        context:
            r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.destination_ips',
      ),
      protocol:
          _i5.FirewallsGet200BodyFirewallsArrayRulesArrayProtocolModel.fromForm(
            _$values[r'protocol'],
            explode: explode,
          ),
      port: _$values[r'port'].decodeFormNullableString(
        context: r'FirewallsGet200BodyFirewallsArrayRulesArrayModel.port',
      ),
    );
  }

  /// Description of the rule.
  final _i3.String? description;

  /// Traffic direction in which the rule should be applied to.
  ///
  /// Use `source_ips` for direction `in` and `destination_ips` for direction `out` to specify IPs.
  ///
  ///
  /// **Example**:
  /// ```
  /// in
  /// ```
  final _i4.FirewallsGet200BodyFirewallsArrayRulesArrayDirectionModel direction;

  /// List of permitted IPv4/IPv6 addresses for incoming traffic.
  ///
  /// The `direction` must be set to `in`.
  ///
  /// IPs must be provided in [CIDR block notation](https://wikipedia.org/wiki/CIDR). You can specify 100 CIDR
  /// blocks at most.
  ///
  /// The CIDR blocks may refer to networks (with empty host bits) or single hosts.
  /// For example, a network could be defined with `10.0.1.0/24` or `2001:db8:ff00:42::/64`,
  /// and a single host with `10.0.1.1/32` or `2001:db8:ff00:42::8329/128`.
  ///
  /// Use `0.0.0.0/0` to allow any IPv4 addresses and `::/0` to allow any IPv6 addresses.
  ///
  /// IPv6 CIDRs will be transformed to their canonical form according to [RFC5952](https://datatracker.ietf.org/doc/html/rfc5952#section-4).
  ///
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "192.0.2.2/32",
  ///   "192.0.2.0/24",
  ///   "2001:0db8:9a3b:ee58:5ca:990c:8bc9:c03b/128"
  /// ]
  /// ```
  final _i3.List<_i3.String> sourceIps;

  /// List of permitted IPv4/IPv6 addresses for outgoing traffic.
  ///
  /// The `direction` must be set to `out`.
  ///
  /// IPs must be in [CIDR block notation](https://wikipedia.org/wiki/CIDR). You can specify 100 CIDR
  /// blocks at most.
  ///
  /// The CIDR blocks may refer to networks (with empty host bits) or single hosts.
  /// For example, a network could be defined with `10.0.1.0/24` or `2001:db8:ff00:42::/64`,
  /// and a single host with `10.0.1.1/32` or `2001:db8:ff00:42::8329/128`.
  ///
  /// Use `0.0.0.0/0` to allow any IPv4 addresses and `::/0` to allow any IPv6 addresses.
  ///
  /// IPv6 CIDRs will be transformed to their canonical form according to [RFC5952](https://datatracker.ietf.org/doc/html/rfc5952#section-4).
  ///
  ///
  /// **Example**:
  /// ```json
  /// []
  /// ```
  final _i3.List<_i3.String> destinationIps;

  /// Network protocol to apply the rule for.
  final _i5.FirewallsGet200BodyFirewallsArrayRulesArrayProtocolModel protocol;

  /// Port or port range to apply the rule for.
  ///
  /// Only applicable for protocols `tcp` and `udp`.
  ///
  /// A port range can be specified by separating lower and upper bounds with a dash. `1024-5000` will include
  /// all ports starting from 1024 up to port 5000.
  ///
  ///
  /// **Example**:
  /// ```
  /// 80
  /// ```
  final _i3.String? port;

  @_i3.override
  _i3.Object? toJson() => {
    r'description': this.description,
    r'direction': this.direction.toJson(),
    r'source_ips': this.sourceIps,
    r'destination_ips': this.destinationIps,
    r'protocol': this.protocol.toJson(),
    r'port': this.port,
  };

  FirewallsGet200BodyFirewallsArrayRulesArrayModel Function({
    _i3.String? description,
    _i4.FirewallsGet200BodyFirewallsArrayRulesArrayDirectionModel? direction,
    _i3.List<_i3.String>? sourceIps,
    _i3.List<_i3.String>? destinationIps,
    _i5.FirewallsGet200BodyFirewallsArrayRulesArrayProtocolModel? protocol,
    _i3.String? port,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? description = _sentinel,
      _i4.FirewallsGet200BodyFirewallsArrayRulesArrayDirectionModel? direction,
      _i3.List<_i3.String>? sourceIps,
      _i3.List<_i3.String>? destinationIps,
      _i5.FirewallsGet200BodyFirewallsArrayRulesArrayProtocolModel? protocol,
      _i3.Object? port = _sentinel,
    }) => FirewallsGet200BodyFirewallsArrayRulesArrayModel(
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      direction: direction ?? this.direction,
      sourceIps: sourceIps ?? this.sourceIps,
      destinationIps: destinationIps ?? this.destinationIps,
      protocol: protocol ?? this.protocol,
      port: _i3.identical(port, _sentinel) ? this.port : (port as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is FirewallsGet200BodyFirewallsArrayRulesArrayModel &&
        other.description == this.description &&
        other.direction == this.direction &&
        _$deepEquals.equals(other.sourceIps, this.sourceIps) &&
        _$deepEquals.equals(other.destinationIps, this.destinationIps) &&
        other.protocol == this.protocol &&
        other.port == this.port;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.description,
      this.direction,
      deepEquals.hash(this.sourceIps),
      deepEquals.hash(this.destinationIps),
      this.protocol,
      this.port,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.description != null) {
      _$result[r'description'] = _i1.PropertyValue.scalar(this.description!);
    }
    _$result[r'direction'] = _i1.PropertyValue.scalar(this.direction.toJson());
    _$result[r'source_ips'] = _i1.PropertyValue.array(this.sourceIps);
    _$result[r'destination_ips'] = _i1.PropertyValue.array(this.destinationIps);
    _$result[r'protocol'] = _i1.PropertyValue.scalar(this.protocol.toJson());
    if (this.port != null) {
      _$result[r'port'] = _i1.PropertyValue.scalar(this.port!);
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsGet200BodyFirewallsArrayRulesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
