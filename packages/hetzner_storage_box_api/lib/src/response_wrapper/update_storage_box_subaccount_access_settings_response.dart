// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_update_access_settings_post201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_update_access_settings_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_update_access_settings_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdateStorageBoxSubaccountAccessSettingsResponse {
  const UpdateStorageBoxSubaccountAccessSettingsResponse();
}

@_i1.immutable
class UpdateStorageBoxSubaccountAccessSettingsResponse201
    extends UpdateStorageBoxSubaccountAccessSettingsResponse {
  const UpdateStorageBoxSubaccountAccessSettingsResponse201({
    required this.body,
  });

  final _i2.StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPost201BodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSubaccountAccessSettingsResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateStorageBoxSubaccountAccessSettingsResponse4XX
    extends UpdateStorageBoxSubaccountAccessSettingsResponse {
  const UpdateStorageBoxSubaccountAccessSettingsResponse4XX({
    required this.body,
  });

  final _i4.StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPost4xxBodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSubaccountAccessSettingsResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateStorageBoxSubaccountAccessSettingsResponse5XX
    extends UpdateStorageBoxSubaccountAccessSettingsResponse {
  const UpdateStorageBoxSubaccountAccessSettingsResponse5XX({
    required this.body,
  });

  final _i5.StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPost5xxBodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSubaccountAccessSettingsResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
