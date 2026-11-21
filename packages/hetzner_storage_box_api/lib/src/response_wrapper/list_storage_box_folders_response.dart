// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_folders_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_folders_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_folders_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListStorageBoxFoldersResponse {
  const ListStorageBoxFoldersResponse();
}

@_i1.immutable
class ListStorageBoxFoldersResponse200 extends ListStorageBoxFoldersResponse {
  const ListStorageBoxFoldersResponse200({required this.body});

  final _i2.StorageBoxesIdFoldersGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxFoldersResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxFoldersResponse4XX extends ListStorageBoxFoldersResponse {
  const ListStorageBoxFoldersResponse4XX({required this.body});

  final _i4.StorageBoxesIdFoldersGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxFoldersResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxFoldersResponse5XX extends ListStorageBoxFoldersResponse {
  const ListStorageBoxFoldersResponse5XX({required this.body});

  final _i5.StorageBoxesIdFoldersGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxFoldersResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
