// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetStorageBoxSubaccountResponse {
  const GetStorageBoxSubaccountResponse();
}

@_i1.immutable
class GetStorageBoxSubaccountResponse200
    extends GetStorageBoxSubaccountResponse {
  const GetStorageBoxSubaccountResponse200({required this.body});

  final _i2.StorageBoxesIdSubaccountsSubaccountIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxSubaccountResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetStorageBoxSubaccountResponse4XX
    extends GetStorageBoxSubaccountResponse {
  const GetStorageBoxSubaccountResponse4XX({required this.body});

  final _i4.StorageBoxesIdSubaccountsSubaccountIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxSubaccountResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetStorageBoxSubaccountResponse5XX
    extends GetStorageBoxSubaccountResponse {
  const GetStorageBoxSubaccountResponse5XX({required this.body});

  final _i5.StorageBoxesIdSubaccountsSubaccountIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxSubaccountResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
