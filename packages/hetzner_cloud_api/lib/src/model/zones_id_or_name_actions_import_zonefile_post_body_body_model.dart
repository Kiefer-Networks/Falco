// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameActionsImportZonefilePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameActionsImportZonefilePostBodyBodyModel({
    required this.zonefile,
  });

  factory ZonesIdOrNameActionsImportZonefilePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'zonefile'},
      listKeys: {},
      context: r'ZonesIdOrNameActionsImportZonefilePostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesIdOrNameActionsImportZonefilePostBodyBodyModel(
      zonefile: _$values[r'zonefile'].decodeSimpleString(
        context:
            r'ZonesIdOrNameActionsImportZonefilePostBodyBodyModel.zonefile',
      ),
    );
  }

  factory ZonesIdOrNameActionsImportZonefilePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameActionsImportZonefilePostBodyBodyModel',
    );
    return ZonesIdOrNameActionsImportZonefilePostBodyBodyModel(
      zonefile: _$map[r'zonefile'].decodeJsonString(
        context:
            r'ZonesIdOrNameActionsImportZonefilePostBodyBodyModel.zonefile',
      ),
    );
  }

  factory ZonesIdOrNameActionsImportZonefilePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'zonefile'},
      listKeys: {},
      context: r'ZonesIdOrNameActionsImportZonefilePostBodyBodyModel',
    );
    return ZonesIdOrNameActionsImportZonefilePostBodyBodyModel(
      zonefile: _$values[r'zonefile'].decodeFormString(
        context:
            r'ZonesIdOrNameActionsImportZonefilePostBodyBodyModel.zonefile',
      ),
    );
  }

  /// Zone file to import.
  ///
  /// See [Zone file import](#tag/zones/zone-file-import) for more details.
  ///
  ///
  /// **Example**:
  /// ```
  /// $ORIGIN	example.com.
  /// $TTL	3600
  ///
  /// @	IN	SOA	hydrogen.ns.hetzner.com. dns.hetzner.com. 2024010100 86400 10800 3600000 3600
  ///
  /// @	IN	10800	NS	hydrogen.ns.hetzner.com. ; Some comment.
  /// @	IN	10800	NS	oxygen.ns.hetzner.com.
  /// @	IN	10800	NS	helium.ns.hetzner.de.
  ///
  /// ```
  final _i3.String zonefile;

  @_i3.override
  _i3.Object? toJson() => {r'zonefile': this.zonefile};

  ZonesIdOrNameActionsImportZonefilePostBodyBodyModel Function({
    _i3.String? zonefile,
  })
  get copyWith {
    return ({_i3.String? zonefile}) =>
        ZonesIdOrNameActionsImportZonefilePostBodyBodyModel(
          zonefile: zonefile ?? this.zonefile,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNameActionsImportZonefilePostBodyBodyModel &&
        other.zonefile == this.zonefile;
  }

  @_i3.override
  _i3.int get hashCode => this.zonefile.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'zonefile'] = _i1.PropertyValue.scalar(this.zonefile);
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
      r'Cannot uriEncode ZonesIdOrNameActionsImportZonefilePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
