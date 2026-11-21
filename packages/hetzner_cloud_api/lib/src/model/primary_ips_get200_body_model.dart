// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_meta_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_primary_ips_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PrimaryIpsGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PrimaryIpsGet200BodyModel({
    required this.primaryIps,
    required this.meta,
  });

  factory PrimaryIpsGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PrimaryIpsGet200BodyModel: contains complex types',
    );
  }

  factory PrimaryIpsGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PrimaryIpsGet200BodyModel');
    return PrimaryIpsGet200BodyModel(
      primaryIps: _$map[r'primary_ips']
          .decodeJsonList<_i3.Object?>(
            context: r'PrimaryIpsGet200BodyModel.primary_ips',
          )
          .map(_i4.PrimaryIpsGet200BodyPrimaryIpsArrayModel.fromJson)
          .toList(),
      meta: _i5.PrimaryIpsGet200BodyMetaModel.fromJson(_$map[r'meta']),
    );
  }

  factory PrimaryIpsGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PrimaryIpsGet200BodyModel: contains complex types',
    );
  }

  final _i3.List<_i4.PrimaryIpsGet200BodyPrimaryIpsArrayModel> primaryIps;

  final _i5.PrimaryIpsGet200BodyMetaModel meta;

  @_i3.override
  _i3.Object? toJson() => {
    r'primary_ips': this.primaryIps.map((e) => e.toJson()).toList(),
    r'meta': this.meta.toJson(),
  };

  PrimaryIpsGet200BodyModel Function({
    _i3.List<_i4.PrimaryIpsGet200BodyPrimaryIpsArrayModel>? primaryIps,
    _i5.PrimaryIpsGet200BodyMetaModel? meta,
  })
  get copyWith {
    return ({
      _i3.List<_i4.PrimaryIpsGet200BodyPrimaryIpsArrayModel>? primaryIps,
      _i5.PrimaryIpsGet200BodyMetaModel? meta,
    }) => PrimaryIpsGet200BodyModel(
      primaryIps: primaryIps ?? this.primaryIps,
      meta: meta ?? this.meta,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is PrimaryIpsGet200BodyModel &&
        _$deepEquals.equals(other.primaryIps, this.primaryIps) &&
        other.meta == this.meta;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(this.primaryIps), this.meta]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PrimaryIpsGet200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PrimaryIpsGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
