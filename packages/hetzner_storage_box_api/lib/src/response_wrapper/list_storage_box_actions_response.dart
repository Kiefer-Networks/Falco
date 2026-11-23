// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListStorageBoxActionsResponse {
  const ListStorageBoxActionsResponse();
}

@_i1.immutable
class ListStorageBoxActionsResponse200 extends ListStorageBoxActionsResponse {
  const ListStorageBoxActionsResponse200({required this.body});

  final _i2.StorageBoxesIdActionsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxActionsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxActionsResponse4XX extends ListStorageBoxActionsResponse {
  const ListStorageBoxActionsResponse4XX({required this.body});

  final _i4.StorageBoxesIdActionsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxActionsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxActionsResponse5XX extends ListStorageBoxActionsResponse {
  const ListStorageBoxActionsResponse5XX({required this.body});

  final _i5.StorageBoxesIdActionsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxActionsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
