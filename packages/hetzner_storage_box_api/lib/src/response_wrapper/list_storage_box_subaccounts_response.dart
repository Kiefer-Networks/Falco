// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListStorageBoxSubaccountsResponse {
  const ListStorageBoxSubaccountsResponse();
}

@_i1.immutable
class ListStorageBoxSubaccountsResponse200
    extends ListStorageBoxSubaccountsResponse {
  const ListStorageBoxSubaccountsResponse200({required this.body});

  final _i2.StorageBoxesIdSubaccountsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxSubaccountsResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxSubaccountsResponse4XX
    extends ListStorageBoxSubaccountsResponse {
  const ListStorageBoxSubaccountsResponse4XX({required this.body});

  final _i4.StorageBoxesIdSubaccountsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxSubaccountsResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxSubaccountsResponse5XX
    extends ListStorageBoxSubaccountsResponse {
  const ListStorageBoxSubaccountsResponse5XX({required this.body});

  final _i5.StorageBoxesIdSubaccountsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxSubaccountsResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
