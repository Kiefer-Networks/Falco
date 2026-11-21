// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/zones_post201_body_zone_one_of_all_of_authoritative_nameservers_delegation_status_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel({
    required this.assigned,
    required this.delegated,
    required this.delegationLastCheck,
    this.delegationStatus,
  });

  factory ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'assigned',
        r'delegated',
        r'delegation_last_check',
        r'delegation_status',
      },
      listKeys: {r'assigned', r'delegated'},
      context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel(
      assigned: _$values[r'assigned'].decodeSimpleStringList(
        context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.assigned',
        isHeader: isHeader,
      ),
      delegated: _$values[r'delegated'].decodeSimpleStringList(
        context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.delegated',
        isHeader: isHeader,
      ),
      delegationLastCheck: _$values[r'delegation_last_check']
          .decodeSimpleNullableDateTime(
            context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.delegation_last_check',
          ),
      delegationStatus: _$values[r'delegation_status'] == null
          ? null
          : _i4.ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversDelegationStatusModel.fromSimple(
              _$values[r'delegation_status'],
              explode: explode,
            ),
    );
  }

  factory ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel',
    );
    return ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel(
      assigned: _$map[r'assigned'].decodeJsonList<_i3.String>(
        context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.assigned',
      ),
      delegated: _$map[r'delegated'].decodeJsonList<_i3.String>(
        context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.delegated',
      ),
      delegationLastCheck: _$map[r'delegation_last_check']
          .decodeJsonNullableDateTime(
            context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.delegation_last_check',
          ),
      delegationStatus: _$map[r'delegation_status'] == null
          ? null
          : _i4.ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversDelegationStatusModel.fromJson(
              _$map[r'delegation_status'],
            ),
    );
  }

  factory ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'assigned',
        r'delegated',
        r'delegation_last_check',
        r'delegation_status',
      },
      listKeys: {r'assigned', r'delegated'},
      context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel',
    );
    return ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel(
      assigned: _$values[r'assigned'].decodeFormStringList(
        context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.assigned',
      ),
      delegated: _$values[r'delegated'].decodeFormStringList(
        context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.delegated',
      ),
      delegationLastCheck: _$values[r'delegation_last_check']
          .decodeFormNullableDateTime(
            context: r'ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel.delegation_last_check',
          ),
      delegationStatus: _$values[r'delegation_status'] == null
          ? null
          : _i4.ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversDelegationStatusModel.fromForm(
              _$values[r'delegation_status'],
              explode: explode,
            ),
    );
  }

  /// Authoritative Hetzner nameservers assigned to this [Zone](#tag/zones).
  ///
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "hydrogen.ns.hetzner.com.",
  ///   "oxygen.ns.hetzner.com.",
  ///   "helium.ns.hetzner.de."
  /// ]
  /// ```
  final _i3.List<_i3.String> assigned;

  /// Authoritative nameservers currently delegated to by the parent DNS zone.
  ///
  /// If these don't match the assigned authoritative nameservers, the DNS zone is currently not being served by Hetzner.
  ///
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "hydrogen.ns.hetzner.com.",
  ///   "oxygen.ns.hetzner.com.",
  ///   "helium.ns.hetzner.de."
  /// ]
  /// ```
  final _i3.List<_i3.String> delegated;

  /// Point in time (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format) when the DNS zone delegation was last checked.
  ///
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime? delegationLastCheck;

  /// Status of the delegation.
  ///
  final _i4.ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversDelegationStatusModel?
  delegationStatus;

  @_i3.override
  _i3.Object? toJson() => {
    r'assigned': this.assigned,
    r'delegated': this.delegated,
    r'delegation_last_check': this.delegationLastCheck
        ?.toTimeZonedIso8601String(),
    if (this.delegationStatus != null)
      r'delegation_status': this.delegationStatus?.toJson(),
  };

  ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel Function({
    _i3.List<_i3.String>? assigned,
    _i3.List<_i3.String>? delegated,
    _i3.DateTime? delegationLastCheck,
    _i4.ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversDelegationStatusModel?
    delegationStatus,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.List<_i3.String>? assigned,
      _i3.List<_i3.String>? delegated,
      _i3.Object? delegationLastCheck = _sentinel,
      _i3.Object? delegationStatus = _sentinel,
    }) => ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel(
      assigned: assigned ?? this.assigned,
      delegated: delegated ?? this.delegated,
      delegationLastCheck: _i3.identical(delegationLastCheck, _sentinel)
          ? this.delegationLastCheck
          : (delegationLastCheck as _i3.DateTime?),
      delegationStatus: _i3.identical(delegationStatus, _sentinel)
          ? this.delegationStatus
          : (delegationStatus
                as _i4.ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversDelegationStatusModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other
            is ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel &&
        _$deepEquals.equals(other.assigned, this.assigned) &&
        _$deepEquals.equals(other.delegated, this.delegated) &&
        other.delegationLastCheck == this.delegationLastCheck &&
        other.delegationStatus == this.delegationStatus;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(this.assigned),
      deepEquals.hash(this.delegated),
      this.delegationLastCheck,
      this.delegationStatus,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'assigned'] = _i1.PropertyValue.array(this.assigned);
    _$result[r'delegated'] = _i1.PropertyValue.array(this.delegated);
    if (this.delegationLastCheck != null) {
      _$result[r'delegation_last_check'] = _i1.PropertyValue.scalar(
        this.delegationLastCheck!.toTimeZonedIso8601String(),
      );
    }
    if (this.delegationStatus != null) {
      _$result[r'delegation_status'] = _i1.PropertyValue.scalar(
        this.delegationStatus!.toJson(),
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
      r'Cannot uriEncode ZonesPost201BodyZoneOneOfAllOfAuthoritativeNameserversModel: complex types cannot be URI-encoded',
    );
  }
}
