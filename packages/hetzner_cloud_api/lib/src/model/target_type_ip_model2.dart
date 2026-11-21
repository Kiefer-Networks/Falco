// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/target_type_ip_health_status_array_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/target_type_ip_ip_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/target_type_ip_type_model2.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TargetTypeIpModel2 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TargetTypeIpModel2({
    required this.ip,
    required this.healthStatus,
    this.$type,
  });

  factory TargetTypeIpModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for TargetTypeIpModel2: contains complex types',
    );
  }

  factory TargetTypeIpModel2.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TargetTypeIpModel2');
    return TargetTypeIpModel2(
      $type: _$map[r'type'] == null
          ? null
          : _i4.TargetTypeIpTypeModel2.fromJson(_$map[r'type']),
      ip: _i5.TargetTypeIpIpModel.fromJson(_$map[r'ip']),
      healthStatus: _$map[r'health_status']
          .decodeJsonList<_i3.Object?>(
            context: r'TargetTypeIpModel2.health_status',
          )
          .map(_i6.TargetTypeIpHealthStatusArrayModel.fromJson)
          .toList(),
    );
  }

  factory TargetTypeIpModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for TargetTypeIpModel2: contains complex types',
    );
  }

  /// **Example**:
  /// ```
  /// ip
  /// ```
  final _i4.TargetTypeIpTypeModel2? $type;

  /// IP target where the traffic should be routed to. It is only possible to use the (Public or vSwitch) IPs of Hetzner Online Root Servers belonging to the project owner. IPs belonging to other users are blocked. Additionally IPs belonging to services provided by Hetzner Cloud (Servers, Load Balancers, ...) are blocked as well. Only present for target type `ip`.
  final _i5.TargetTypeIpIpModel ip;

  /// List of health statuses of the services on this target. Only present for target types "server" and "ip".
  final _i3.List<_i6.TargetTypeIpHealthStatusArrayModel> healthStatus;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.$type != null) r'type': this.$type?.toJson(),
    r'ip': this.ip.toJson(),
    r'health_status': this.healthStatus.map((e) => e.toJson()).toList(),
  };

  TargetTypeIpModel2 Function({
    _i4.TargetTypeIpTypeModel2? $type,
    _i5.TargetTypeIpIpModel? ip,
    _i3.List<_i6.TargetTypeIpHealthStatusArrayModel>? healthStatus,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? $type = _sentinel,
      _i5.TargetTypeIpIpModel? ip,
      _i3.List<_i6.TargetTypeIpHealthStatusArrayModel>? healthStatus,
    }) => TargetTypeIpModel2(
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i4.TargetTypeIpTypeModel2?),
      ip: ip ?? this.ip,
      healthStatus: healthStatus ?? this.healthStatus,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is TargetTypeIpModel2 &&
        other.$type == this.$type &&
        other.ip == this.ip &&
        _$deepEquals.equals(other.healthStatus, this.healthStatus);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.$type,
      this.ip,
      deepEquals.hash(this.healthStatus),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for TargetTypeIpModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TargetTypeIpModel2: complex types cannot be URI-encoded',
    );
  }
}
