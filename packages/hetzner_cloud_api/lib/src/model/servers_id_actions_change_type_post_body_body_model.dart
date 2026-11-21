// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsChangeTypePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsChangeTypePostBodyBodyModel({
    required this.upgradeDisk,
    required this.serverType,
  });

  factory ServersIdActionsChangeTypePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'upgrade_disk', r'server_type'},
      listKeys: {},
      context: r'ServersIdActionsChangeTypePostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdActionsChangeTypePostBodyBodyModel(
      upgradeDisk: _$values[r'upgrade_disk'].decodeSimpleBool(
        context: r'ServersIdActionsChangeTypePostBodyBodyModel.upgrade_disk',
      ),
      serverType: _$values[r'server_type'].decodeSimpleString(
        context: r'ServersIdActionsChangeTypePostBodyBodyModel.server_type',
      ),
    );
  }

  factory ServersIdActionsChangeTypePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsChangeTypePostBodyBodyModel',
    );
    return ServersIdActionsChangeTypePostBodyBodyModel(
      upgradeDisk: _$map[r'upgrade_disk'].decodeJsonBool(
        context: r'ServersIdActionsChangeTypePostBodyBodyModel.upgrade_disk',
      ),
      serverType: _$map[r'server_type'].decodeJsonString(
        context: r'ServersIdActionsChangeTypePostBodyBodyModel.server_type',
      ),
    );
  }

  factory ServersIdActionsChangeTypePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'upgrade_disk', r'server_type'},
      listKeys: {},
      context: r'ServersIdActionsChangeTypePostBodyBodyModel',
    );
    return ServersIdActionsChangeTypePostBodyBodyModel(
      upgradeDisk: _$values[r'upgrade_disk'].decodeFormBool(
        context: r'ServersIdActionsChangeTypePostBodyBodyModel.upgrade_disk',
      ),
      serverType: _$values[r'server_type'].decodeFormString(
        context: r'ServersIdActionsChangeTypePostBodyBodyModel.server_type',
      ),
    );
  }

  /// If false, do not upgrade the disk (this allows downgrading the Server type later).
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool upgradeDisk;

  /// ID or name of Server type the Server should migrate to.
  ///
  /// **Example**:
  /// ```
  /// cpx22
  /// ```
  final _i3.String serverType;

  @_i3.override
  _i3.Object? toJson() => {
    r'upgrade_disk': this.upgradeDisk,
    r'server_type': this.serverType,
  };

  ServersIdActionsChangeTypePostBodyBodyModel Function({
    _i3.bool? upgradeDisk,
    _i3.String? serverType,
  })
  get copyWith {
    return ({_i3.bool? upgradeDisk, _i3.String? serverType}) =>
        ServersIdActionsChangeTypePostBodyBodyModel(
          upgradeDisk: upgradeDisk ?? this.upgradeDisk,
          serverType: serverType ?? this.serverType,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdActionsChangeTypePostBodyBodyModel &&
        other.upgradeDisk == this.upgradeDisk &&
        other.serverType == this.serverType;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.upgradeDisk, this.serverType]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'upgrade_disk'] = _i1.PropertyValue.scalar(
      this.upgradeDisk.toString(),
    );
    _$result[r'server_type'] = _i1.PropertyValue.scalar(this.serverType);
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
      r'Cannot uriEncode ServersIdActionsChangeTypePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
