// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_enable_rescue_post_body_body_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsEnableRescuePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsEnableRescuePostBodyBodyModel({
    this.$type = $typeDefault,
    this.sshKeys,
  });

  factory ServersIdActionsEnableRescuePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'type', r'ssh_keys'},
      listKeys: {r'ssh_keys'},
      context: r'ServersIdActionsEnableRescuePostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdActionsEnableRescuePostBodyBodyModel(
      $type: _$values.containsKey(r'type')
          ? _i4.ServersIdActionsEnableRescuePostBodyBodyTypeModel.fromSimple(
              _$values[r'type'],
              explode: explode,
            )
          : $typeDefault,
      sshKeys: _$values[r'ssh_keys']
          .decodeSimpleNullableStringList(
            context: r'ServersIdActionsEnableRescuePostBodyBodyModel.ssh_keys',
            isHeader: isHeader,
          )
          ?.map(
            (e) => e.decodeSimpleInt(
              context:
                  r'ServersIdActionsEnableRescuePostBodyBodyModel.ssh_keys',
            ),
          )
          .toList(),
    );
  }

  factory ServersIdActionsEnableRescuePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsEnableRescuePostBodyBodyModel',
    );
    return ServersIdActionsEnableRescuePostBodyBodyModel(
      $type: _$map.containsKey(r'type')
          ? _i4.ServersIdActionsEnableRescuePostBodyBodyTypeModel.fromJson(
              _$map[r'type'],
            )
          : $typeDefault,
      sshKeys: _$map[r'ssh_keys'].decodeJsonNullableList<_i3.int>(
        context: r'ServersIdActionsEnableRescuePostBodyBodyModel.ssh_keys',
      ),
    );
  }

  factory ServersIdActionsEnableRescuePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'type', r'ssh_keys'},
      listKeys: {r'ssh_keys'},
      context: r'ServersIdActionsEnableRescuePostBodyBodyModel',
    );
    return ServersIdActionsEnableRescuePostBodyBodyModel(
      $type: _$values.containsKey(r'type')
          ? _i4.ServersIdActionsEnableRescuePostBodyBodyTypeModel.fromForm(
              _$values[r'type'],
              explode: explode,
            )
          : $typeDefault,
      sshKeys: _$values[r'ssh_keys']
          .decodeSimpleNullableStringList(
            context: r'ServersIdActionsEnableRescuePostBodyBodyModel.ssh_keys',
          )
          ?.map(
            (e) => e.decodeFormInt(
              context:
                  r'ServersIdActionsEnableRescuePostBodyBodyModel.ssh_keys',
            ),
          )
          .toList(),
    );
  }

  static const _i4.ServersIdActionsEnableRescuePostBodyBodyTypeModel
  $typeDefault = _i4.ServersIdActionsEnableRescuePostBodyBodyTypeModel.linux64;

  /// Type of rescue system to boot.
  final _i4.ServersIdActionsEnableRescuePostBodyBodyTypeModel? $type;

  /// Array of SSH key IDs which should be injected into the rescue system.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   2323
  /// ]
  /// ```
  final _i3.List<_i3.int>? sshKeys;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.$type != null) r'type': this.$type?.toJson(),
    if (this.sshKeys != null) r'ssh_keys': this.sshKeys,
  };

  ServersIdActionsEnableRescuePostBodyBodyModel Function({
    _i4.ServersIdActionsEnableRescuePostBodyBodyTypeModel? $type,
    _i3.List<_i3.int>? sshKeys,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? $type = _sentinel, _i3.Object? sshKeys = _sentinel}) =>
        ServersIdActionsEnableRescuePostBodyBodyModel(
          $type: _i3.identical($type, _sentinel)
              ? this.$type
              : ($type
                    as _i4.ServersIdActionsEnableRescuePostBodyBodyTypeModel?),
          sshKeys: _i3.identical(sshKeys, _sentinel)
              ? this.sshKeys
              : (sshKeys as _i3.List<_i3.int>?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is ServersIdActionsEnableRescuePostBodyBodyModel &&
        other.$type == this.$type &&
        _$deepEquals.equals(other.sshKeys, this.sshKeys);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([this.$type, deepEquals.hash(this.sshKeys)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.$type != null) {
      _$result[r'type'] = _i1.PropertyValue.scalar(this.$type!.toJson());
    }
    if (this.sshKeys != null) {
      _$result[r'ssh_keys'] = _i1.PropertyValue.array(
        this.sshKeys!.map((e) => e.toString()).toList(),
      );
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdActionsEnableRescuePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
