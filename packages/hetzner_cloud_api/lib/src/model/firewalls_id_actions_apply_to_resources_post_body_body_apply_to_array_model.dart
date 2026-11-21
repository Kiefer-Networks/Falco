// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_apply_to_resources_post_body_body_apply_to_array_label_selector_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_apply_to_resources_post_body_body_apply_to_array_server_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_apply_to_resources_post_body_body_apply_to_array_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel({
    required this.$type,
    this.server,
    this.labelSelector,
  });

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel: contains complex types',
    );
  }

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel',
    );
    return FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel(
      $type:
          _i4.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayTypeModel.fromJson(
            _$map[r'type'],
          ),
      server: _$map[r'server'] == null
          ? null
          : _i5.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayServerModel.fromJson(
              _$map[r'server'],
            ),
      labelSelector: _$map[r'label_selector'] == null
          ? null
          : _i6.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel.fromJson(
              _$map[r'label_selector'],
            ),
    );
  }

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel: contains complex types',
    );
  }

  /// Type of the resource.
  final _i4.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayTypeModel
  $type;

  /// [Server](#tag/servers) the [Firewall](#tag/firewalls) is applied to.
  ///
  /// Only set for `type` `server`, otherwise `null`.
  ///
  final _i5.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayServerModel?
  server;

  /// [Label Selector](#description/label-selector) the [Firewall](#tag/firewalls) is applied to.
  ///
  /// Only set for `type` `label_selector`, otherwise `null`.
  ///
  final _i6.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel?
  labelSelector;

  @_i3.override
  _i3.Object? toJson() => {
    r'type': this.$type.toJson(),
    if (this.server != null) r'server': this.server?.toJson(),
    if (this.labelSelector != null)
      r'label_selector': this.labelSelector?.toJson(),
  };

  FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel Function({
    _i4.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayTypeModel?
    $type,
    _i5.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayServerModel?
    server,
    _i6.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel?
    labelSelector,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayTypeModel?
      $type,
      _i3.Object? server = _sentinel,
      _i3.Object? labelSelector = _sentinel,
    }) => FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel(
      $type: $type ?? this.$type,
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server
                as _i5.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayServerModel?),
      labelSelector: _i3.identical(labelSelector, _sentinel)
          ? this.labelSelector
          : (labelSelector
                as _i6.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel &&
        other.$type == this.$type &&
        other.server == this.server &&
        other.labelSelector == this.labelSelector;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.$type, this.server, this.labelSelector]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel: complex types cannot be URI-encoded',
    );
  }
}
