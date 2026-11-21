// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_remove_target_post_body_body_ip_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_remove_target_post_body_body_label_selector_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_remove_target_post_body_body_server_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_remove_target_post_body_body_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Configuration of a Load Balancer target.
@_i2.immutable
class LoadBalancersIdActionsRemoveTargetPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsRemoveTargetPostBodyBodyModel({
    required this.$type,
    this.server,
    this.labelSelector,
    this.ip,
  });

  factory LoadBalancersIdActionsRemoveTargetPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdActionsRemoveTargetPostBodyBodyModel: contains complex types',
    );
  }

  factory LoadBalancersIdActionsRemoveTargetPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsRemoveTargetPostBodyBodyModel',
    );
    return LoadBalancersIdActionsRemoveTargetPostBodyBodyModel(
      $type:
          _i4.LoadBalancersIdActionsRemoveTargetPostBodyBodyTypeModel.fromJson(
            _$map[r'type'],
          ),
      server: _$map[r'server'] == null
          ? null
          : _i5.LoadBalancersIdActionsRemoveTargetPostBodyBodyServerModel.fromJson(
              _$map[r'server'],
            ),
      labelSelector: _$map[r'label_selector'] == null
          ? null
          : _i6.LoadBalancersIdActionsRemoveTargetPostBodyBodyLabelSelectorModel.fromJson(
              _$map[r'label_selector'],
            ),
      ip: _$map[r'ip'] == null
          ? null
          : _i7.LoadBalancersIdActionsRemoveTargetPostBodyBodyIpModel.fromJson(
              _$map[r'ip'],
            ),
    );
  }

  factory LoadBalancersIdActionsRemoveTargetPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdActionsRemoveTargetPostBodyBodyModel: contains complex types',
    );
  }

  /// Type of the resource.
  final _i4.LoadBalancersIdActionsRemoveTargetPostBodyBodyTypeModel $type;

  /// Configuration for type Server, only valid and required if type is `server`.
  final _i5.LoadBalancersIdActionsRemoveTargetPostBodyBodyServerModel? server;

  /// Configuration for label selector targets, only valid and required if type is `label_selector`.
  final _i6.LoadBalancersIdActionsRemoveTargetPostBodyBodyLabelSelectorModel?
  labelSelector;

  /// Configuration for an IP target. It is only possible to use the (Public or vSwitch) IPs of Hetzner Online Root Servers belonging to the project owner. IPs belonging to other users are blocked. Additionally IPs belonging to services provided by Hetzner Cloud (Servers, Load Balancers, ...) are blocked as well. Only valid and required if type is `ip`.
  final _i7.LoadBalancersIdActionsRemoveTargetPostBodyBodyIpModel? ip;

  @_i3.override
  _i3.Object? toJson() => {
    r'type': this.$type.toJson(),
    if (this.server != null) r'server': this.server?.toJson(),
    if (this.labelSelector != null)
      r'label_selector': this.labelSelector?.toJson(),
    if (this.ip != null) r'ip': this.ip?.toJson(),
  };

  LoadBalancersIdActionsRemoveTargetPostBodyBodyModel Function({
    _i4.LoadBalancersIdActionsRemoveTargetPostBodyBodyTypeModel? $type,
    _i5.LoadBalancersIdActionsRemoveTargetPostBodyBodyServerModel? server,
    _i6.LoadBalancersIdActionsRemoveTargetPostBodyBodyLabelSelectorModel?
    labelSelector,
    _i7.LoadBalancersIdActionsRemoveTargetPostBodyBodyIpModel? ip,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.LoadBalancersIdActionsRemoveTargetPostBodyBodyTypeModel? $type,
      _i3.Object? server = _sentinel,
      _i3.Object? labelSelector = _sentinel,
      _i3.Object? ip = _sentinel,
    }) => LoadBalancersIdActionsRemoveTargetPostBodyBodyModel(
      $type: $type ?? this.$type,
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server
                as _i5.LoadBalancersIdActionsRemoveTargetPostBodyBodyServerModel?),
      labelSelector: _i3.identical(labelSelector, _sentinel)
          ? this.labelSelector
          : (labelSelector
                as _i6.LoadBalancersIdActionsRemoveTargetPostBodyBodyLabelSelectorModel?),
      ip: _i3.identical(ip, _sentinel)
          ? this.ip
          : (ip as _i7.LoadBalancersIdActionsRemoveTargetPostBodyBodyIpModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsRemoveTargetPostBodyBodyModel &&
        other.$type == this.$type &&
        other.server == this.server &&
        other.labelSelector == this.labelSelector &&
        other.ip == this.ip;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.$type,
      this.server,
      this.labelSelector,
      this.ip,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersIdActionsRemoveTargetPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdActionsRemoveTargetPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
