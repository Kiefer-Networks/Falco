// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i9;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i8;
import 'package:hetzner_cloud_api/src/model/firewalls_post201_body_firewall_applied_to_array_applied_to_resources_array_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/firewalls_post201_body_firewall_applied_to_array_label_selector_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/firewalls_post201_body_firewall_applied_to_array_server_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/firewalls_post201_body_firewall_applied_to_array_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsPost201BodyFirewallAppliedToArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsPost201BodyFirewallAppliedToArrayModel({
    required this.$type,
    this.server,
    this.labelSelector,
    this.appliedToResources,
  });

  factory FirewallsPost201BodyFirewallAppliedToArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsPost201BodyFirewallAppliedToArrayModel: contains complex types',
    );
  }

  factory FirewallsPost201BodyFirewallAppliedToArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsPost201BodyFirewallAppliedToArrayModel',
    );
    return FirewallsPost201BodyFirewallAppliedToArrayModel(
      $type: _i4.FirewallsPost201BodyFirewallAppliedToArrayTypeModel.fromJson(
        _$map[r'type'],
      ),
      server: _$map[r'server'] == null
          ? null
          : _i5.FirewallsPost201BodyFirewallAppliedToArrayServerModel.fromJson(
              _$map[r'server'],
            ),
      labelSelector: _$map[r'label_selector'] == null
          ? null
          : _i6.FirewallsPost201BodyFirewallAppliedToArrayLabelSelectorModel.fromJson(
              _$map[r'label_selector'],
            ),
      appliedToResources: _$map[r'applied_to_resources']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'FirewallsPost201BodyFirewallAppliedToArrayModel.applied_to_resources',
          )
          ?.map(
            _i7
                .FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory FirewallsPost201BodyFirewallAppliedToArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsPost201BodyFirewallAppliedToArrayModel: contains complex types',
    );
  }

  /// The type of resource to apply.
  ///
  /// **Example**:
  /// ```
  /// server
  /// ```
  final _i4.FirewallsPost201BodyFirewallAppliedToArrayTypeModel $type;

  /// [Server](#tag/servers) the [Firewall](#tag/firewalls) is applied to.
  ///
  /// Only set for `type` `server`, otherwise `null`.
  ///
  final _i5.FirewallsPost201BodyFirewallAppliedToArrayServerModel? server;

  /// [Label Selector](#description/label-selector) the [Firewall](#tag/firewalls) is applied to.
  ///
  /// Only set for `type` `label_selector`, otherwise `null`.
  ///
  final _i6.FirewallsPost201BodyFirewallAppliedToArrayLabelSelectorModel?
  labelSelector;

  /// Resources applied to via this [Label Selector](#description/label-selector).
  ///
  final _i3.List<
    _i7.FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayModel
  >?
  appliedToResources;

  @_i3.override
  _i3.Object? toJson() => {
    r'type': this.$type.toJson(),
    if (this.server != null) r'server': this.server?.toJson(),
    if (this.labelSelector != null)
      r'label_selector': this.labelSelector?.toJson(),
    if (this.appliedToResources != null)
      r'applied_to_resources': this.appliedToResources
          ?.map((e) => e.toJson())
          .toList(),
  };

  FirewallsPost201BodyFirewallAppliedToArrayModel Function({
    _i4.FirewallsPost201BodyFirewallAppliedToArrayTypeModel? $type,
    _i5.FirewallsPost201BodyFirewallAppliedToArrayServerModel? server,
    _i6.FirewallsPost201BodyFirewallAppliedToArrayLabelSelectorModel?
    labelSelector,
    _i3.List<
      _i7.FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayModel
    >?
    appliedToResources,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.FirewallsPost201BodyFirewallAppliedToArrayTypeModel? $type,
      _i3.Object? server = _sentinel,
      _i3.Object? labelSelector = _sentinel,
      _i3.Object? appliedToResources = _sentinel,
    }) => FirewallsPost201BodyFirewallAppliedToArrayModel(
      $type: $type ?? this.$type,
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server
                as _i5.FirewallsPost201BodyFirewallAppliedToArrayServerModel?),
      labelSelector: _i3.identical(labelSelector, _sentinel)
          ? this.labelSelector
          : (labelSelector
                as _i6.FirewallsPost201BodyFirewallAppliedToArrayLabelSelectorModel?),
      appliedToResources: _i3.identical(appliedToResources, _sentinel)
          ? this.appliedToResources
          : (appliedToResources
                as _i3.List<
                  _i7.FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayModel
                >?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i8.DeepCollectionEquality();
    return other is FirewallsPost201BodyFirewallAppliedToArrayModel &&
        other.$type == this.$type &&
        other.server == this.server &&
        other.labelSelector == this.labelSelector &&
        _$deepEquals.equals(other.appliedToResources, this.appliedToResources);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i8.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.$type,
      this.server,
      this.labelSelector,
      deepEquals.hash(this.appliedToResources),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsPost201BodyFirewallAppliedToArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i9.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsPost201BodyFirewallAppliedToArrayModel: complex types cannot be URI-encoded',
    );
  }
}
