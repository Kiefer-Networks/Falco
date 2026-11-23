// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_reset_subaccount_password_post201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_reset_subaccount_password_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_reset_subaccount_password_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ResetStorageBoxSubaccountPasswordResponse {
  const ResetStorageBoxSubaccountPasswordResponse();
}

@_i1.immutable
class ResetStorageBoxSubaccountPasswordResponse201
    extends ResetStorageBoxSubaccountPasswordResponse {
  const ResetStorageBoxSubaccountPasswordResponse201({required this.body});

  final _i2.StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPost201BodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetStorageBoxSubaccountPasswordResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ResetStorageBoxSubaccountPasswordResponse4XX
    extends ResetStorageBoxSubaccountPasswordResponse {
  const ResetStorageBoxSubaccountPasswordResponse4XX({required this.body});

  final _i4.StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPost4xxBodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetStorageBoxSubaccountPasswordResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ResetStorageBoxSubaccountPasswordResponse5XX
    extends ResetStorageBoxSubaccountPasswordResponse {
  const ResetStorageBoxSubaccountPasswordResponse5XX({required this.body});

  final _i5.StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPost5xxBodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetStorageBoxSubaccountPasswordResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
