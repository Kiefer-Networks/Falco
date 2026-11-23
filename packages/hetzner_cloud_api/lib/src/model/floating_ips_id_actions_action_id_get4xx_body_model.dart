// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_action_id_get4xx_body_error_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// **Example**:
/// ```json
/// {
///   "error": {
///     "code": "unauthorized",
///     "message": "unable to authenticate",
///     "details": null
///   }
/// }
/// ```
@_i2.immutable
class FloatingIpsIdActionsActionIdGet4xxBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FloatingIpsIdActionsActionIdGet4xxBodyModel({required this.error});

  factory FloatingIpsIdActionsActionIdGet4xxBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FloatingIpsIdActionsActionIdGet4xxBodyModel: contains complex types',
    );
  }

  factory FloatingIpsIdActionsActionIdGet4xxBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FloatingIpsIdActionsActionIdGet4xxBodyModel',
    );
    return FloatingIpsIdActionsActionIdGet4xxBodyModel(
      error: _i4.FloatingIpsIdActionsActionIdGet4xxBodyErrorModel.fromJson(
        _$map[r'error'],
      ),
    );
  }

  factory FloatingIpsIdActionsActionIdGet4xxBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FloatingIpsIdActionsActionIdGet4xxBodyModel: contains complex types',
    );
  }

  final _i4.FloatingIpsIdActionsActionIdGet4xxBodyErrorModel error;

  @_i3.override
  _i3.Object? toJson() => {r'error': this.error.toJson()};

  FloatingIpsIdActionsActionIdGet4xxBodyModel Function({
    _i4.FloatingIpsIdActionsActionIdGet4xxBodyErrorModel? error,
  })
  get copyWith {
    return ({_i4.FloatingIpsIdActionsActionIdGet4xxBodyErrorModel? error}) =>
        FloatingIpsIdActionsActionIdGet4xxBodyModel(error: error ?? this.error);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FloatingIpsIdActionsActionIdGet4xxBodyModel &&
        other.error == this.error;
  }

  @_i3.override
  _i3.int get hashCode => this.error.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FloatingIpsIdActionsActionIdGet4xxBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FloatingIpsIdActionsActionIdGet4xxBodyModel: complex types cannot be URI-encoded',
    );
  }
}
