// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_primary_nameservers_post_body_body_primary_nameservers_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel({
    required this.primaryNameservers,
  });

  factory ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel: contains complex types',
    );
  }

  factory ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel',
    );
    return ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel(
      primaryNameservers: _$map[r'primary_nameservers']
          .decodeJsonList<_i3.Object?>(
            context: r'ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel.primary_nameservers',
          )
          .map(
            _i4
                .ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyPrimaryNameserversArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel: contains complex types',
    );
  }

  /// Primary nameservers of the [Zone](#tag/zones).
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   {
  ///     "address": "198.51.100.1",
  ///     "port": 53
  ///   },
  ///   {
  ///     "address": "203.0.113.1",
  ///     "port": 53
  ///   }
  /// ]
  /// ```
  final _i3.List<
    _i4.ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyPrimaryNameserversArrayModel
  >
  primaryNameservers;

  @_i3.override
  _i3.Object? toJson() => {
    r'primary_nameservers': this.primaryNameservers
        .map((e) => e.toJson())
        .toList(),
  };

  ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel Function({
    _i3.List<
      _i4.ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyPrimaryNameserversArrayModel
    >?
    primaryNameservers,
  })
  get copyWith {
    return ({
      _i3.List<
        _i4.ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyPrimaryNameserversArrayModel
      >?
      primaryNameservers,
    }) => ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel(
      primaryNameservers: primaryNameservers ?? this.primaryNameservers,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other
            is ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel &&
        _$deepEquals.equals(other.primaryNameservers, this.primaryNameservers);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return deepEquals.hash(this.primaryNameservers);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
