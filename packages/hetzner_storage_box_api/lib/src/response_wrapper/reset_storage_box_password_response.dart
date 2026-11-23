// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_reset_password_post201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_reset_password_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_reset_password_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ResetStorageBoxPasswordResponse {
  const ResetStorageBoxPasswordResponse();
}

@_i1.immutable
class ResetStorageBoxPasswordResponse201
    extends ResetStorageBoxPasswordResponse {
  const ResetStorageBoxPasswordResponse201({required this.body});

  final _i2.StorageBoxesIdActionsResetPasswordPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetStorageBoxPasswordResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ResetStorageBoxPasswordResponse4XX
    extends ResetStorageBoxPasswordResponse {
  const ResetStorageBoxPasswordResponse4XX({required this.body});

  final _i4.StorageBoxesIdActionsResetPasswordPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetStorageBoxPasswordResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ResetStorageBoxPasswordResponse5XX
    extends ResetStorageBoxPasswordResponse {
  const ResetStorageBoxPasswordResponse5XX({required this.body});

  final _i5.StorageBoxesIdActionsResetPasswordPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetStorageBoxPasswordResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
