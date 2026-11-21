// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersPostBodyBodyFirewallsArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersPostBodyBodyFirewallsArrayModel({required this.firewall});

  factory ServersPostBodyBodyFirewallsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'firewall'},
      listKeys: {},
      context: r'ServersPostBodyBodyFirewallsArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersPostBodyBodyFirewallsArrayModel(
      firewall: _$values[r'firewall'].decodeSimpleInt(
        context: r'ServersPostBodyBodyFirewallsArrayModel.firewall',
      ),
    );
  }

  factory ServersPostBodyBodyFirewallsArrayModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersPostBodyBodyFirewallsArrayModel',
    );
    return ServersPostBodyBodyFirewallsArrayModel(
      firewall: _$map[r'firewall'].decodeJsonInt(
        context: r'ServersPostBodyBodyFirewallsArrayModel.firewall',
      ),
    );
  }

  factory ServersPostBodyBodyFirewallsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'firewall'},
      listKeys: {},
      context: r'ServersPostBodyBodyFirewallsArrayModel',
    );
    return ServersPostBodyBodyFirewallsArrayModel(
      firewall: _$values[r'firewall'].decodeFormInt(
        context: r'ServersPostBodyBodyFirewallsArrayModel.firewall',
      ),
    );
  }

  /// ID of the Firewall.
  final _i3.int firewall;

  @_i3.override
  _i3.Object? toJson() => {r'firewall': this.firewall};

  ServersPostBodyBodyFirewallsArrayModel Function({_i3.int? firewall})
  get copyWith {
    return ({_i3.int? firewall}) => ServersPostBodyBodyFirewallsArrayModel(
      firewall: firewall ?? this.firewall,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersPostBodyBodyFirewallsArrayModel &&
        other.firewall == this.firewall;
  }

  @_i3.override
  _i3.int get hashCode => this.firewall.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'firewall'] = _i1.PropertyValue.scalar(this.firewall.toString());
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
      r'Cannot uriEncode ServersPostBodyBodyFirewallsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
