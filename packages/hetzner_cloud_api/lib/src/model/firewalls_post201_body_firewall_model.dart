// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/firewalls_post201_body_firewall_applied_to_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/firewalls_post201_body_firewall_rules_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsPost201BodyFirewallModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsPost201BodyFirewallModel({
    required this.id,
    required this.name,
    required this.created,
    required this.rules,
    required this.appliedTo,
    this.labels,
  });

  factory FirewallsPost201BodyFirewallModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsPost201BodyFirewallModel: contains complex types',
    );
  }

  factory FirewallsPost201BodyFirewallModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FirewallsPost201BodyFirewallModel');
    return FirewallsPost201BodyFirewallModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'FirewallsPost201BodyFirewallModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'FirewallsPost201BodyFirewallModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context: r'FirewallsPost201BodyFirewallModel.labels',
        ),
        context: r'FirewallsPost201BodyFirewallModel.labels',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'FirewallsPost201BodyFirewallModel.created',
      ),
      rules: _$map[r'rules']
          .decodeJsonList<_i3.Object?>(
            context: r'FirewallsPost201BodyFirewallModel.rules',
          )
          .map(_i4.FirewallsPost201BodyFirewallRulesArrayModel.fromJson)
          .toList(),
      appliedTo: _$map[r'applied_to']
          .decodeJsonList<_i3.Object?>(
            context: r'FirewallsPost201BodyFirewallModel.applied_to',
          )
          .map(_i5.FirewallsPost201BodyFirewallAppliedToArrayModel.fromJson)
          .toList(),
    );
  }

  factory FirewallsPost201BodyFirewallModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsPost201BodyFirewallModel: contains complex types',
    );
  }

  /// ID of the [Firewall](#tag/firewalls).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the [Firewall](#tag/firewalls).
  ///
  /// Must be unique per Project.
  ///
  ///
  /// **Example**:
  /// ```
  /// new-name
  /// ```
  final _i3.String name;

  /// User-defined labels (`key/value` pairs) for the Resource.
  /// For more information, see "[Labels](#description/labels)".
  ///
  ///
  /// **Example**:
  /// ```json
  /// {
  ///   "environment": "prod",
  ///   "example.com/my": "label",
  ///   "just-a-key": ""
  /// }
  /// ```
  final _i3.Map<_i3.String, _i3.String>? labels;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  final _i3.List<_i4.FirewallsPost201BodyFirewallRulesArrayModel> rules;

  final _i3.List<_i5.FirewallsPost201BodyFirewallAppliedToArrayModel> appliedTo;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    if (this.labels != null) r'labels': this.labels,
    r'created': this.created.toTimeZonedIso8601String(),
    r'rules': this.rules.map((e) => e.toJson()).toList(),
    r'applied_to': this.appliedTo.map((e) => e.toJson()).toList(),
  };

  FirewallsPost201BodyFirewallModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.DateTime? created,
    _i3.List<_i4.FirewallsPost201BodyFirewallRulesArrayModel>? rules,
    _i3.List<_i5.FirewallsPost201BodyFirewallAppliedToArrayModel>? appliedTo,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.Object? labels = _sentinel,
      _i3.DateTime? created,
      _i3.List<_i4.FirewallsPost201BodyFirewallRulesArrayModel>? rules,
      _i3.List<_i5.FirewallsPost201BodyFirewallAppliedToArrayModel>? appliedTo,
    }) => FirewallsPost201BodyFirewallModel(
      id: id ?? this.id,
      name: name ?? this.name,
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      created: created ?? this.created,
      rules: rules ?? this.rules,
      appliedTo: appliedTo ?? this.appliedTo,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is FirewallsPost201BodyFirewallModel &&
        other.id == this.id &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.created == this.created &&
        _$deepEquals.equals(other.rules, this.rules) &&
        _$deepEquals.equals(other.appliedTo, this.appliedTo);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      deepEquals.hash(this.labels),
      this.created,
      deepEquals.hash(this.rules),
      deepEquals.hash(this.appliedTo),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsPost201BodyFirewallModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsPost201BodyFirewallModel: complex types cannot be URI-encoded',
    );
  }
}
