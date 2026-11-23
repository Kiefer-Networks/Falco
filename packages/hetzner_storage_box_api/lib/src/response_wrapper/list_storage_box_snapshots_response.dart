// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListStorageBoxSnapshotsResponse {
  const ListStorageBoxSnapshotsResponse();
}

@_i1.immutable
class ListStorageBoxSnapshotsResponse200
    extends ListStorageBoxSnapshotsResponse {
  const ListStorageBoxSnapshotsResponse200({required this.body});

  final _i2.StorageBoxesIdSnapshotsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxSnapshotsResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxSnapshotsResponse4XX
    extends ListStorageBoxSnapshotsResponse {
  const ListStorageBoxSnapshotsResponse4XX({required this.body});

  final _i4.StorageBoxesIdSnapshotsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxSnapshotsResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxSnapshotsResponse5XX
    extends ListStorageBoxSnapshotsResponse {
  const ListStorageBoxSnapshotsResponse5XX({required this.body});

  final _i5.StorageBoxesIdSnapshotsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxSnapshotsResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
