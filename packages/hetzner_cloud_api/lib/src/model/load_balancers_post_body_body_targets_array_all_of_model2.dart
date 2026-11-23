// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_targets_array_all_of_ip_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_targets_array_all_of_label_selector_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_targets_array_all_of_server_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_targets_array_all_of_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Configuration of a Load Balancer target.
@_i2.immutable
class LoadBalancersPostBodyBodyTargetsArrayAllOfModel2
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPostBodyBodyTargetsArrayAllOfModel2({
    required this.$type,
    this.server,
    this.labelSelector,
    this.ip,
  });

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersPostBodyBodyTargetsArrayAllOfModel2: contains complex types',
    );
  }

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfModel2.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfModel2',
    );
    return LoadBalancersPostBodyBodyTargetsArrayAllOfModel2(
      $type: _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfTypeModel.fromJson(
        _$map[r'type'],
      ),
      server: _$map[r'server'] == null
          ? null
          : _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.fromJson(
              _$map[r'server'],
            ),
      labelSelector: _$map[r'label_selector'] == null
          ? null
          : _i6.LoadBalancersPostBodyBodyTargetsArrayAllOfLabelSelectorModel.fromJson(
              _$map[r'label_selector'],
            ),
      ip: _$map[r'ip'] == null
          ? null
          : _i7.LoadBalancersPostBodyBodyTargetsArrayAllOfIpModel.fromJson(
              _$map[r'ip'],
            ),
    );
  }

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersPostBodyBodyTargetsArrayAllOfModel2: contains complex types',
    );
  }

  /// Type of the resource.
  final _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfTypeModel $type;

  /// Configuration for type Server, only valid and required if type is `server`.
  final _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel? server;

  /// Configuration for label selector targets, only valid and required if type is `label_selector`.
  final _i6.LoadBalancersPostBodyBodyTargetsArrayAllOfLabelSelectorModel?
  labelSelector;

  /// Configuration for an IP target. It is only possible to use the (Public or vSwitch) IPs of Hetzner Online Root Servers belonging to the project owner. IPs belonging to other users are blocked. Additionally IPs belonging to services provided by Hetzner Cloud (Servers, Load Balancers, ...) are blocked as well. Only valid and required if type is `ip`.
  final _i7.LoadBalancersPostBodyBodyTargetsArrayAllOfIpModel? ip;

  @_i3.override
  _i3.Object? toJson() => {
    r'type': this.$type.toJson(),
    if (this.server != null) r'server': this.server?.toJson(),
    if (this.labelSelector != null)
      r'label_selector': this.labelSelector?.toJson(),
    if (this.ip != null) r'ip': this.ip?.toJson(),
  };

  LoadBalancersPostBodyBodyTargetsArrayAllOfModel2 Function({
    _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfTypeModel? $type,
    _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel? server,
    _i6.LoadBalancersPostBodyBodyTargetsArrayAllOfLabelSelectorModel?
    labelSelector,
    _i7.LoadBalancersPostBodyBodyTargetsArrayAllOfIpModel? ip,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfTypeModel? $type,
      _i3.Object? server = _sentinel,
      _i3.Object? labelSelector = _sentinel,
      _i3.Object? ip = _sentinel,
    }) => LoadBalancersPostBodyBodyTargetsArrayAllOfModel2(
      $type: $type ?? this.$type,
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server
                as _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel?),
      labelSelector: _i3.identical(labelSelector, _sentinel)
          ? this.labelSelector
          : (labelSelector
                as _i6.LoadBalancersPostBodyBodyTargetsArrayAllOfLabelSelectorModel?),
      ip: _i3.identical(ip, _sentinel)
          ? this.ip
          : (ip as _i7.LoadBalancersPostBodyBodyTargetsArrayAllOfIpModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersPostBodyBodyTargetsArrayAllOfModel2 &&
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
    r'parameterProperties not supported for LoadBalancersPostBodyBodyTargetsArrayAllOfModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPostBodyBodyTargetsArrayAllOfModel2: complex types cannot be URI-encoded',
    );
  }
}
