// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_put200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_put4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_put5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdateStorageBoxSubaccountResponse {
  const UpdateStorageBoxSubaccountResponse();
}

@_i1.immutable
class UpdateStorageBoxSubaccountResponse200
    extends UpdateStorageBoxSubaccountResponse {
  const UpdateStorageBoxSubaccountResponse200({required this.body});

  final _i2.StorageBoxesIdSubaccountsSubaccountIdPut200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSubaccountResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateStorageBoxSubaccountResponse4XX
    extends UpdateStorageBoxSubaccountResponse {
  const UpdateStorageBoxSubaccountResponse4XX({required this.body});

  final _i4.StorageBoxesIdSubaccountsSubaccountIdPut4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSubaccountResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateStorageBoxSubaccountResponse5XX
    extends UpdateStorageBoxSubaccountResponse {
  const UpdateStorageBoxSubaccountResponse5XX({required this.body});

  final _i5.StorageBoxesIdSubaccountsSubaccountIdPut5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSubaccountResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
