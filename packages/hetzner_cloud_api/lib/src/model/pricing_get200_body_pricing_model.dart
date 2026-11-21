// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i14;
import 'dart:core' as _i3;

import 'package:big_decimal/big_decimal.dart' as _i12;
import 'package:collection/collection.dart' as _i13;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_floating_ip_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_floating_ips_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_image_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_load_balancer_types_array_model.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_primary_ips_array_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_server_backup_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_server_types_array_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_volume_model.dart'
    as _i7;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PricingGet200BodyPricingModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PricingGet200BodyPricingModel({
    required this.currency,
    required this.vatRate,
    required this.primaryIps,
    required this.floatingIps,
    required this.image,
    required this.volume,
    required this.serverBackup,
    required this.serverTypes,
    required this.loadBalancerTypes,
    required this.floatingIp,
  });

  factory PricingGet200BodyPricingModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PricingGet200BodyPricingModel: contains complex types',
    );
  }

  factory PricingGet200BodyPricingModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PricingGet200BodyPricingModel');
    return PricingGet200BodyPricingModel(
      currency: _$map[r'currency'].decodeJsonString(
        context: r'PricingGet200BodyPricingModel.currency',
      ),
      vatRate: _$map[r'vat_rate'].decodeJsonBigDecimal(
        context: r'PricingGet200BodyPricingModel.vat_rate',
      ),
      primaryIps: _$map[r'primary_ips']
          .decodeJsonList<_i3.Object?>(
            context: r'PricingGet200BodyPricingModel.primary_ips',
          )
          .map(_i4.PricingGet200BodyPricingPrimaryIpsArrayModel.fromJson)
          .toList(),
      floatingIps: _$map[r'floating_ips']
          .decodeJsonList<_i3.Object?>(
            context: r'PricingGet200BodyPricingModel.floating_ips',
          )
          .map(_i5.PricingGet200BodyPricingFloatingIpsArrayModel.fromJson)
          .toList(),
      image: _i6.PricingGet200BodyPricingImageModel.fromJson(_$map[r'image']),
      volume: _i7.PricingGet200BodyPricingVolumeModel.fromJson(
        _$map[r'volume'],
      ),
      serverBackup: _i8.PricingGet200BodyPricingServerBackupModel.fromJson(
        _$map[r'server_backup'],
      ),
      serverTypes: _$map[r'server_types']
          .decodeJsonList<_i3.Object?>(
            context: r'PricingGet200BodyPricingModel.server_types',
          )
          .map(_i9.PricingGet200BodyPricingServerTypesArrayModel.fromJson)
          .toList(),
      loadBalancerTypes: _$map[r'load_balancer_types']
          .decodeJsonList<_i3.Object?>(
            context: r'PricingGet200BodyPricingModel.load_balancer_types',
          )
          .map(
            _i10.PricingGet200BodyPricingLoadBalancerTypesArrayModel.fromJson,
          )
          .toList(),
      floatingIp: _i11.PricingGet200BodyPricingFloatingIpModel.fromJson(
        _$map[r'floating_ip'],
      ),
    );
  }

  factory PricingGet200BodyPricingModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PricingGet200BodyPricingModel: contains complex types',
    );
  }

  /// Currency the returned prices are expressed in, coded according to [ISO 4217](https://wikipedia.org/wiki/ISO_4217).
  ///
  /// **Example**:
  /// ```
  /// EUR
  /// ```
  final _i3.String currency;

  /// VAT rate used for calculating prices with VAT.
  ///
  /// **Example**:
  /// ```
  /// 19.00
  /// ```
  final _i12.BigDecimal vatRate;

  /// Price of [Primary IPs](#tag/primary-ips) per type and per [Location](#tag/locations).
  final _i3.List<_i4.PricingGet200BodyPricingPrimaryIpsArrayModel> primaryIps;

  /// Price of [Floating IPs](#tag/floating-ips) per type and per [Location](#tag/locations).
  final _i3.List<_i5.PricingGet200BodyPricingFloatingIpsArrayModel> floatingIps;

  /// Price of [Images](#tag/images).
  final _i6.PricingGet200BodyPricingImageModel image;

  /// Price of [Volumes](#tag/volumes).
  final _i7.PricingGet200BodyPricingVolumeModel volume;

  /// Price of [Server](#tag/servers) backups.
  final _i8.PricingGet200BodyPricingServerBackupModel serverBackup;

  /// Price of Server per [type](#tag/server-types) and per [Location](#tag/locations).
  final _i3.List<_i9.PricingGet200BodyPricingServerTypesArrayModel> serverTypes;

  /// Price of Load Balancer per [type](#tag/load-balancer-types) and per [Location](#tag/locations).
  final _i3.List<_i10.PricingGet200BodyPricingLoadBalancerTypesArrayModel>
  loadBalancerTypes;

  /// Price of [Floating IPs](#tag/floating-ips).
  ///
  /// **Deprecated**: This field is deprecated, please refer to the `floating_ips` field instead.
  ///
  /// See the [Changelog](https://docs.hetzner.cloud/changelog#2024-08-29-field-floating_ip-in-pricing-response-is-now-deprecated) for more details.
  ///
  @_i3.Deprecated('This property is deprecated.')
  final _i11.PricingGet200BodyPricingFloatingIpModel floatingIp;

  @_i3.override
  _i3.Object? toJson() => {
    r'currency': this.currency,
    r'vat_rate': this.vatRate.toPlainString(),
    r'primary_ips': this.primaryIps.map((e) => e.toJson()).toList(),
    r'floating_ips': this.floatingIps.map((e) => e.toJson()).toList(),
    r'image': this.image.toJson(),
    r'volume': this.volume.toJson(),
    r'server_backup': this.serverBackup.toJson(),
    r'server_types': this.serverTypes.map((e) => e.toJson()).toList(),
    r'load_balancer_types': this.loadBalancerTypes
        .map((e) => e.toJson())
        .toList(),
    r'floating_ip': this.floatingIp.toJson(),
  };

  PricingGet200BodyPricingModel Function({
    _i3.String? currency,
    _i12.BigDecimal? vatRate,
    _i3.List<_i4.PricingGet200BodyPricingPrimaryIpsArrayModel>? primaryIps,
    _i3.List<_i5.PricingGet200BodyPricingFloatingIpsArrayModel>? floatingIps,
    _i6.PricingGet200BodyPricingImageModel? image,
    _i7.PricingGet200BodyPricingVolumeModel? volume,
    _i8.PricingGet200BodyPricingServerBackupModel? serverBackup,
    _i3.List<_i9.PricingGet200BodyPricingServerTypesArrayModel>? serverTypes,
    _i3.List<_i10.PricingGet200BodyPricingLoadBalancerTypesArrayModel>?
    loadBalancerTypes,
    _i11.PricingGet200BodyPricingFloatingIpModel? floatingIp,
  })
  get copyWith {
    return ({
      _i3.String? currency,
      _i12.BigDecimal? vatRate,
      _i3.List<_i4.PricingGet200BodyPricingPrimaryIpsArrayModel>? primaryIps,
      _i3.List<_i5.PricingGet200BodyPricingFloatingIpsArrayModel>? floatingIps,
      _i6.PricingGet200BodyPricingImageModel? image,
      _i7.PricingGet200BodyPricingVolumeModel? volume,
      _i8.PricingGet200BodyPricingServerBackupModel? serverBackup,
      _i3.List<_i9.PricingGet200BodyPricingServerTypesArrayModel>? serverTypes,
      _i3.List<_i10.PricingGet200BodyPricingLoadBalancerTypesArrayModel>?
      loadBalancerTypes,
      _i11.PricingGet200BodyPricingFloatingIpModel? floatingIp,
    }) => PricingGet200BodyPricingModel(
      currency: currency ?? this.currency,
      vatRate: vatRate ?? this.vatRate,
      primaryIps: primaryIps ?? this.primaryIps,
      floatingIps: floatingIps ?? this.floatingIps,
      image: image ?? this.image,
      volume: volume ?? this.volume,
      serverBackup: serverBackup ?? this.serverBackup,
      serverTypes: serverTypes ?? this.serverTypes,
      loadBalancerTypes: loadBalancerTypes ?? this.loadBalancerTypes,
      floatingIp: floatingIp ?? this.floatingIp,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i13.DeepCollectionEquality();
    return other is PricingGet200BodyPricingModel &&
        other.currency == this.currency &&
        other.vatRate == this.vatRate &&
        _$deepEquals.equals(other.primaryIps, this.primaryIps) &&
        _$deepEquals.equals(other.floatingIps, this.floatingIps) &&
        other.image == this.image &&
        other.volume == this.volume &&
        other.serverBackup == this.serverBackup &&
        _$deepEquals.equals(other.serverTypes, this.serverTypes) &&
        _$deepEquals.equals(other.loadBalancerTypes, this.loadBalancerTypes) &&
        other.floatingIp == this.floatingIp;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i13.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.currency,
      this.vatRate,
      deepEquals.hash(this.primaryIps),
      deepEquals.hash(this.floatingIps),
      this.image,
      this.volume,
      this.serverBackup,
      deepEquals.hash(this.serverTypes),
      deepEquals.hash(this.loadBalancerTypes),
      this.floatingIp,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PricingGet200BodyPricingModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i14.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PricingGet200BodyPricingModel: complex types cannot be URI-encoded',
    );
  }
}
