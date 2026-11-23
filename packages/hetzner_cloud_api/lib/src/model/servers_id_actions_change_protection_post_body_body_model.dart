// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsChangeProtectionPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsChangeProtectionPostBodyBodyModel({
    this.delete,
    this.rebuild,
  });

  factory ServersIdActionsChangeProtectionPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'delete', r'rebuild'},
      listKeys: {},
      context: r'ServersIdActionsChangeProtectionPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdActionsChangeProtectionPostBodyBodyModel(
      delete: _$values[r'delete'].decodeSimpleNullableBool(
        context: r'ServersIdActionsChangeProtectionPostBodyBodyModel.delete',
      ),
      rebuild: _$values[r'rebuild'].decodeSimpleNullableBool(
        context: r'ServersIdActionsChangeProtectionPostBodyBodyModel.rebuild',
      ),
    );
  }

  factory ServersIdActionsChangeProtectionPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsChangeProtectionPostBodyBodyModel',
    );
    return ServersIdActionsChangeProtectionPostBodyBodyModel(
      delete: _$map[r'delete'].decodeJsonNullableBool(
        context: r'ServersIdActionsChangeProtectionPostBodyBodyModel.delete',
      ),
      rebuild: _$map[r'rebuild'].decodeJsonNullableBool(
        context: r'ServersIdActionsChangeProtectionPostBodyBodyModel.rebuild',
      ),
    );
  }

  factory ServersIdActionsChangeProtectionPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'delete', r'rebuild'},
      listKeys: {},
      context: r'ServersIdActionsChangeProtectionPostBodyBodyModel',
    );
    return ServersIdActionsChangeProtectionPostBodyBodyModel(
      delete: _$values[r'delete'].decodeFormNullableBool(
        context: r'ServersIdActionsChangeProtectionPostBodyBodyModel.delete',
      ),
      rebuild: _$values[r'rebuild'].decodeFormNullableBool(
        context: r'ServersIdActionsChangeProtectionPostBodyBodyModel.rebuild',
      ),
    );
  }

  /// If true, prevents the Server from being deleted (currently delete and rebuild attribute needs to have the same value).
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? delete;

  /// If true, prevents the Server from being rebuilt (currently delete and rebuild attribute needs to have the same value).
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? rebuild;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.delete != null) r'delete': this.delete,
    if (this.rebuild != null) r'rebuild': this.rebuild,
  };

  ServersIdActionsChangeProtectionPostBodyBodyModel Function({
    _i3.bool? delete,
    _i3.bool? rebuild,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? delete = _sentinel,
      _i3.Object? rebuild = _sentinel,
    }) => ServersIdActionsChangeProtectionPostBodyBodyModel(
      delete: _i3.identical(delete, _sentinel)
          ? this.delete
          : (delete as _i3.bool?),
      rebuild: _i3.identical(rebuild, _sentinel)
          ? this.rebuild
          : (rebuild as _i3.bool?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdActionsChangeProtectionPostBodyBodyModel &&
        other.delete == this.delete &&
        other.rebuild == this.rebuild;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.delete, this.rebuild]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.delete != null) {
      _$result[r'delete'] = _i1.PropertyValue.scalar(this.delete!.toString());
    }
    if (this.rebuild != null) {
      _$result[r'rebuild'] = _i1.PropertyValue.scalar(this.rebuild!.toString());
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
      r'Cannot uriEncode ServersIdActionsChangeProtectionPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
