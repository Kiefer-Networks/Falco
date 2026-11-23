// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Public Network options.
@_i2.immutable
class ServersPostBodyBodyPublicNetModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersPostBodyBodyPublicNetModel({
    this.enableIpv4 = enableIpv4Default,
    this.enableIpv6 = enableIpv6Default,
    this.ipv4,
    this.ipv6,
  });

  factory ServersPostBodyBodyPublicNetModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'enable_ipv4', r'enable_ipv6', r'ipv4', r'ipv6'},
      listKeys: {},
      context: r'ServersPostBodyBodyPublicNetModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersPostBodyBodyPublicNetModel(
      enableIpv4: _$values.containsKey(r'enable_ipv4')
          ? _$values[r'enable_ipv4'].decodeSimpleBool(
              context: r'ServersPostBodyBodyPublicNetModel.enable_ipv4',
            )
          : enableIpv4Default,
      enableIpv6: _$values.containsKey(r'enable_ipv6')
          ? _$values[r'enable_ipv6'].decodeSimpleBool(
              context: r'ServersPostBodyBodyPublicNetModel.enable_ipv6',
            )
          : enableIpv6Default,
      ipv4: _$values[r'ipv4'].decodeSimpleNullableInt(
        context: r'ServersPostBodyBodyPublicNetModel.ipv4',
      ),
      ipv6: _$values[r'ipv6'].decodeSimpleNullableInt(
        context: r'ServersPostBodyBodyPublicNetModel.ipv6',
      ),
    );
  }

  factory ServersPostBodyBodyPublicNetModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServersPostBodyBodyPublicNetModel');
    return ServersPostBodyBodyPublicNetModel(
      enableIpv4: _$map.containsKey(r'enable_ipv4')
          ? _$map[r'enable_ipv4'].decodeJsonBool(
              context: r'ServersPostBodyBodyPublicNetModel.enable_ipv4',
            )
          : enableIpv4Default,
      enableIpv6: _$map.containsKey(r'enable_ipv6')
          ? _$map[r'enable_ipv6'].decodeJsonBool(
              context: r'ServersPostBodyBodyPublicNetModel.enable_ipv6',
            )
          : enableIpv6Default,
      ipv4: _$map[r'ipv4'].decodeJsonNullableInt(
        context: r'ServersPostBodyBodyPublicNetModel.ipv4',
      ),
      ipv6: _$map[r'ipv6'].decodeJsonNullableInt(
        context: r'ServersPostBodyBodyPublicNetModel.ipv6',
      ),
    );
  }

  factory ServersPostBodyBodyPublicNetModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'enable_ipv4', r'enable_ipv6', r'ipv4', r'ipv6'},
      listKeys: {},
      context: r'ServersPostBodyBodyPublicNetModel',
    );
    return ServersPostBodyBodyPublicNetModel(
      enableIpv4: _$values.containsKey(r'enable_ipv4')
          ? _$values[r'enable_ipv4'].decodeFormBool(
              context: r'ServersPostBodyBodyPublicNetModel.enable_ipv4',
            )
          : enableIpv4Default,
      enableIpv6: _$values.containsKey(r'enable_ipv6')
          ? _$values[r'enable_ipv6'].decodeFormBool(
              context: r'ServersPostBodyBodyPublicNetModel.enable_ipv6',
            )
          : enableIpv6Default,
      ipv4: _$values[r'ipv4'].decodeFormNullableInt(
        context: r'ServersPostBodyBodyPublicNetModel.ipv4',
      ),
      ipv6: _$values[r'ipv6'].decodeFormNullableInt(
        context: r'ServersPostBodyBodyPublicNetModel.ipv6',
      ),
    );
  }

  static const _i3.bool enableIpv4Default = true;

  static const _i3.bool enableIpv6Default = true;

  /// Attach an IPv4 on the public NIC. If false, no IPv4 address will be attached.
  final _i3.bool? enableIpv4;

  /// Attach an IPv6 on the public NIC. If false, no IPv6 address will be attached.
  final _i3.bool? enableIpv6;

  /// ID of the ipv4 Primary IP to use. If omitted and enable_ipv4 is true, a new ipv4 Primary IP will automatically be created.
  final _i3.int? ipv4;

  /// ID of the ipv6 Primary IP to use. If omitted and enable_ipv6 is true, a new ipv6 Primary IP will automatically be created.
  final _i3.int? ipv6;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.enableIpv4 != null) r'enable_ipv4': this.enableIpv4,
    if (this.enableIpv6 != null) r'enable_ipv6': this.enableIpv6,
    r'ipv4': this.ipv4,
    r'ipv6': this.ipv6,
  };

  ServersPostBodyBodyPublicNetModel Function({
    _i3.bool? enableIpv4,
    _i3.bool? enableIpv6,
    _i3.int? ipv4,
    _i3.int? ipv6,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? enableIpv4 = _sentinel,
      _i3.Object? enableIpv6 = _sentinel,
      _i3.Object? ipv4 = _sentinel,
      _i3.Object? ipv6 = _sentinel,
    }) => ServersPostBodyBodyPublicNetModel(
      enableIpv4: _i3.identical(enableIpv4, _sentinel)
          ? this.enableIpv4
          : (enableIpv4 as _i3.bool?),
      enableIpv6: _i3.identical(enableIpv6, _sentinel)
          ? this.enableIpv6
          : (enableIpv6 as _i3.bool?),
      ipv4: _i3.identical(ipv4, _sentinel) ? this.ipv4 : (ipv4 as _i3.int?),
      ipv6: _i3.identical(ipv6, _sentinel) ? this.ipv6 : (ipv6 as _i3.int?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersPostBodyBodyPublicNetModel &&
        other.enableIpv4 == this.enableIpv4 &&
        other.enableIpv6 == this.enableIpv6 &&
        other.ipv4 == this.ipv4 &&
        other.ipv6 == this.ipv6;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.enableIpv4,
      this.enableIpv6,
      this.ipv4,
      this.ipv6,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.enableIpv4 != null) {
      _$result[r'enable_ipv4'] = _i1.PropertyValue.scalar(
        this.enableIpv4!.toString(),
      );
    }
    if (this.enableIpv6 != null) {
      _$result[r'enable_ipv6'] = _i1.PropertyValue.scalar(
        this.enableIpv6!.toString(),
      );
    }
    if (this.ipv4 != null) {
      _$result[r'ipv4'] = _i1.PropertyValue.scalar(this.ipv4!.toString());
    }
    if (this.ipv6 != null) {
      _$result[r'ipv6'] = _i1.PropertyValue.scalar(this.ipv6!.toString());
    }
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
      r'Cannot uriEncode ServersPostBodyBodyPublicNetModel: complex types cannot be URI-encoded',
    );
  }
}
