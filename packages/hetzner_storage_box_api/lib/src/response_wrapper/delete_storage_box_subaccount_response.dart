// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_delete201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_delete4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_delete5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteStorageBoxSubaccountResponse {
  const DeleteStorageBoxSubaccountResponse();
}

@_i1.immutable
class DeleteStorageBoxSubaccountResponse201
    extends DeleteStorageBoxSubaccountResponse {
  const DeleteStorageBoxSubaccountResponse201({required this.body});

  final _i2.StorageBoxesIdSubaccountsSubaccountIdDelete201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteStorageBoxSubaccountResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteStorageBoxSubaccountResponse4XX
    extends DeleteStorageBoxSubaccountResponse {
  const DeleteStorageBoxSubaccountResponse4XX({required this.body});

  final _i4.StorageBoxesIdSubaccountsSubaccountIdDelete4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteStorageBoxSubaccountResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteStorageBoxSubaccountResponse5XX
    extends DeleteStorageBoxSubaccountResponse {
  const DeleteStorageBoxSubaccountResponse5XX({required this.body});

  final _i5.StorageBoxesIdSubaccountsSubaccountIdDelete5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteStorageBoxSubaccountResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
