// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i9;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i8;
import 'package:hetzner_cloud_api/src/model/firewalls_id_put200_body_firewall_applied_to_array_applied_to_resources_array_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/firewalls_id_put200_body_firewall_applied_to_array_label_selector_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/firewalls_id_put200_body_firewall_applied_to_array_server_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/firewalls_id_put200_body_firewall_applied_to_array_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsIdPut200BodyFirewallAppliedToArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsIdPut200BodyFirewallAppliedToArrayModel({
    required this.$type,
    this.server,
    this.labelSelector,
    this.appliedToResources,
  });

  factory FirewallsIdPut200BodyFirewallAppliedToArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsIdPut200BodyFirewallAppliedToArrayModel: contains complex types',
    );
  }

  factory FirewallsIdPut200BodyFirewallAppliedToArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsIdPut200BodyFirewallAppliedToArrayModel',
    );
    return FirewallsIdPut200BodyFirewallAppliedToArrayModel(
      $type: _i4.FirewallsIdPut200BodyFirewallAppliedToArrayTypeModel.fromJson(
        _$map[r'type'],
      ),
      server: _$map[r'server'] == null
          ? null
          : _i5.FirewallsIdPut200BodyFirewallAppliedToArrayServerModel.fromJson(
              _$map[r'server'],
            ),
      labelSelector: _$map[r'label_selector'] == null
          ? null
          : _i6.FirewallsIdPut200BodyFirewallAppliedToArrayLabelSelectorModel.fromJson(
              _$map[r'label_selector'],
            ),
      appliedToResources: _$map[r'applied_to_resources']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'FirewallsIdPut200BodyFirewallAppliedToArrayModel.applied_to_resources',
          )
          ?.map(
            _i7
                .FirewallsIdPut200BodyFirewallAppliedToArrayAppliedToResourcesArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory FirewallsIdPut200BodyFirewallAppliedToArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsIdPut200BodyFirewallAppliedToArrayModel: contains complex types',
    );
  }

  /// The type of resource to apply.
  ///
  /// **Example**:
  /// ```
  /// server
  /// ```
  final _i4.FirewallsIdPut200BodyFirewallAppliedToArrayTypeModel $type;

  /// [Server](#tag/servers) the [Firewall](#tag/firewalls) is applied to.
  ///
  /// Only set for `type` `server`, otherwise `null`.
  ///
  final _i5.FirewallsIdPut200BodyFirewallAppliedToArrayServerModel? server;

  /// [Label Selector](#description/label-selector) the [Firewall](#tag/firewalls) is applied to.
  ///
  /// Only set for `type` `label_selector`, otherwise `null`.
  ///
  final _i6.FirewallsIdPut200BodyFirewallAppliedToArrayLabelSelectorModel?
  labelSelector;

  /// Resources applied to via this [Label Selector](#description/label-selector).
  ///
  final _i3.List<
    _i7.FirewallsIdPut200BodyFirewallAppliedToArrayAppliedToResourcesArrayModel
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

  FirewallsIdPut200BodyFirewallAppliedToArrayModel Function({
    _i4.FirewallsIdPut200BodyFirewallAppliedToArrayTypeModel? $type,
    _i5.FirewallsIdPut200BodyFirewallAppliedToArrayServerModel? server,
    _i6.FirewallsIdPut200BodyFirewallAppliedToArrayLabelSelectorModel?
    labelSelector,
    _i3.List<
      _i7.FirewallsIdPut200BodyFirewallAppliedToArrayAppliedToResourcesArrayModel
    >?
    appliedToResources,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.FirewallsIdPut200BodyFirewallAppliedToArrayTypeModel? $type,
      _i3.Object? server = _sentinel,
      _i3.Object? labelSelector = _sentinel,
      _i3.Object? appliedToResources = _sentinel,
    }) => FirewallsIdPut200BodyFirewallAppliedToArrayModel(
      $type: $type ?? this.$type,
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server
                as _i5.FirewallsIdPut200BodyFirewallAppliedToArrayServerModel?),
      labelSelector: _i3.identical(labelSelector, _sentinel)
          ? this.labelSelector
          : (labelSelector
                as _i6.FirewallsIdPut200BodyFirewallAppliedToArrayLabelSelectorModel?),
      appliedToResources: _i3.identical(appliedToResources, _sentinel)
          ? this.appliedToResources
          : (appliedToResources
                as _i3.List<
                  _i7.FirewallsIdPut200BodyFirewallAppliedToArrayAppliedToResourcesArrayModel
                >?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i8.DeepCollectionEquality();
    return other is FirewallsIdPut200BodyFirewallAppliedToArrayModel &&
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
    r'parameterProperties not supported for FirewallsIdPut200BodyFirewallAppliedToArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i9.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsIdPut200BodyFirewallAppliedToArrayModel: complex types cannot be URI-encoded',
    );
  }
}
