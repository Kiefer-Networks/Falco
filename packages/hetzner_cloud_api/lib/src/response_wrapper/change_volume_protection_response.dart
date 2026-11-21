// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/volumes_id_actions_change_protection_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_change_protection_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_change_protection_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeVolumeProtectionResponse {
  const ChangeVolumeProtectionResponse();
}

@_i1.immutable
class ChangeVolumeProtectionResponse201 extends ChangeVolumeProtectionResponse {
  const ChangeVolumeProtectionResponse201({required this.body});

  final _i2.VolumesIdActionsChangeProtectionPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeVolumeProtectionResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeVolumeProtectionResponse4XX extends ChangeVolumeProtectionResponse {
  const ChangeVolumeProtectionResponse4XX({required this.body});

  final _i4.VolumesIdActionsChangeProtectionPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeVolumeProtectionResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeVolumeProtectionResponse5XX extends ChangeVolumeProtectionResponse {
  const ChangeVolumeProtectionResponse5XX({required this.body});

  final _i5.VolumesIdActionsChangeProtectionPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeVolumeProtectionResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
