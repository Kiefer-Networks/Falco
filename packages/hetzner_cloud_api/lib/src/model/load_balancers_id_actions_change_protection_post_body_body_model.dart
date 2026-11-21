// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsChangeProtectionPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsChangeProtectionPostBodyBodyModel({this.delete});

  factory LoadBalancersIdActionsChangeProtectionPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'delete'},
      listKeys: {},
      context: r'LoadBalancersIdActionsChangeProtectionPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdActionsChangeProtectionPostBodyBodyModel(
      delete: _$values[r'delete'].decodeSimpleNullableBool(
        context:
            r'LoadBalancersIdActionsChangeProtectionPostBodyBodyModel.delete',
      ),
    );
  }

  factory LoadBalancersIdActionsChangeProtectionPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsChangeProtectionPostBodyBodyModel',
    );
    return LoadBalancersIdActionsChangeProtectionPostBodyBodyModel(
      delete: _$map[r'delete'].decodeJsonNullableBool(
        context:
            r'LoadBalancersIdActionsChangeProtectionPostBodyBodyModel.delete',
      ),
    );
  }

  factory LoadBalancersIdActionsChangeProtectionPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'delete'},
      listKeys: {},
      context: r'LoadBalancersIdActionsChangeProtectionPostBodyBodyModel',
    );
    return LoadBalancersIdActionsChangeProtectionPostBodyBodyModel(
      delete: _$values[r'delete'].decodeFormNullableBool(
        context:
            r'LoadBalancersIdActionsChangeProtectionPostBodyBodyModel.delete',
      ),
    );
  }

  /// If true, prevents the Load Balancer from being deleted.
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? delete;

  @_i3.override
  _i3.Object? toJson() => {if (this.delete != null) r'delete': this.delete};

  LoadBalancersIdActionsChangeProtectionPostBodyBodyModel Function({
    _i3.bool? delete,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? delete = _sentinel}) =>
        LoadBalancersIdActionsChangeProtectionPostBodyBodyModel(
          delete: _i3.identical(delete, _sentinel)
              ? this.delete
              : (delete as _i3.bool?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsChangeProtectionPostBodyBodyModel &&
        other.delete == this.delete;
  }

  @_i3.override
  _i3.int get hashCode => this.delete.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.delete != null) {
      _$result[r'delete'] = _i1.PropertyValue.scalar(this.delete!.toString());
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdActionsChangeProtectionPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
