// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_apply_to_resources_post_body_body_apply_to_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsIdActionsApplyToResourcesPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsIdActionsApplyToResourcesPostBodyBodyModel({
    required this.applyTo,
  });

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsIdActionsApplyToResourcesPostBodyBodyModel: contains complex types',
    );
  }

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsIdActionsApplyToResourcesPostBodyBodyModel',
    );
    return FirewallsIdActionsApplyToResourcesPostBodyBodyModel(
      applyTo: _$map[r'apply_to']
          .decodeJsonList<_i3.Object?>(
            context:
                r'FirewallsIdActionsApplyToResourcesPostBodyBodyModel.apply_to',
          )
          .map(
            _i4
                .FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsIdActionsApplyToResourcesPostBodyBodyModel: contains complex types',
    );
  }

  /// Resources to apply the [Firewall](#tag/firewalls) to.
  ///
  /// Extends existing resources.
  ///
  final _i3.List<
    _i4.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel
  >
  applyTo;

  @_i3.override
  _i3.Object? toJson() => {
    r'apply_to': this.applyTo.map((e) => e.toJson()).toList(),
  };

  FirewallsIdActionsApplyToResourcesPostBodyBodyModel Function({
    _i3.List<
      _i4.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel
    >?
    applyTo,
  })
  get copyWith {
    return ({
      _i3.List<
        _i4.FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayModel
      >?
      applyTo,
    }) => FirewallsIdActionsApplyToResourcesPostBodyBodyModel(
      applyTo: applyTo ?? this.applyTo,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is FirewallsIdActionsApplyToResourcesPostBodyBodyModel &&
        _$deepEquals.equals(other.applyTo, this.applyTo);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return deepEquals.hash(this.applyTo);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsIdActionsApplyToResourcesPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsIdActionsApplyToResourcesPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
