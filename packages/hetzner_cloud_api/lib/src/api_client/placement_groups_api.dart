// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/placement_groups_id_put_body_body_model.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/model/placement_groups_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/placement_groups_parameters_array_model2.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/placement_groups_post_body_body_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/operation/create_placement_group.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_placement_group.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/get_placement_group.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_placement_groups.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/update_placement_group.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_placement_group_response.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_placement_group_response.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/response_wrapper/get_placement_group_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/response_wrapper/list_placement_groups_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/update_placement_group_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// Placement groups are used to influence the location of interdependent virtual servers in our data centers. The distribution of the different servers within a group is based on a pattern specified in the type. By enforcing certain rules on the placement of servers within our infrastructure, availability can be influenced in a way that fits your needs best.
///
/// In `spread` placement groups, all virtual servers will run on different physical servers. This decreases the probability that some servers might fail together.
///
class PlacementGroupsApi {
  PlacementGroupsApi(_i1.Server server)
    : _listPlacementGroups = _i2.ListPlacementGroups(
        server.baseUrl,
        () => server.dio,
      ),
      _createPlacementGroup = _i3.CreatePlacementGroup(
        server.baseUrl,
        () => server.dio,
      ),
      _getPlacementGroup = _i4.GetPlacementGroup(
        server.baseUrl,
        () => server.dio,
      ),
      _updatePlacementGroup = _i5.UpdatePlacementGroup(
        server.baseUrl,
        () => server.dio,
      ),
      _deletePlacementGroup = _i6.DeletePlacementGroup(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListPlacementGroups _listPlacementGroups;

  final _i3.CreatePlacementGroup _createPlacementGroup;

  final _i4.GetPlacementGroup _getPlacementGroup;

  final _i5.UpdatePlacementGroup _updatePlacementGroup;

  final _i6.DeletePlacementGroup _deletePlacementGroup;

  /// List Placement Groups
  /// Returns all Placement Group objects.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "placement_groups": [
  ///     {
  ///       "id": 897,
  ///       "name": "my Placement Group",
  ///       "labels": {
  ///         "key": "value"
  ///       },
  ///       "type": "spread",
  ///       "created": "2019-01-08T12:10:00Z",
  ///       "servers": [
  ///         4711,
  ///         4712
  ///       ]
  ///     }
  ///   ],
  ///   "meta": {
  ///     "pagination": {
  ///       "page": 1,
  ///       "per_page": 25,
  ///       "previous_page": null,
  ///       "next_page": null,
  ///       "last_page": 1,
  ///       "total_entries": 21
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<_i9.ListPlacementGroupsResponse, _i10.Response<_i7.Object?>>
  >
  listPlacementGroups({
    _i7.List<_i11.PlacementGroupsParametersArrayModel>? sort,
    _i7.String? name,
    _i7.String? labelSelector,
    _i7.List<_i12.PlacementGroupsParametersArrayModel2>? $type,
    _i7.int page = _i2.ListPlacementGroups.pageDefault,
    _i7.int perPage = _i2.ListPlacementGroups.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listPlacementGroups(
    sort: sort,
    name: name,
    labelSelector: labelSelector,
    $type: $type,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a PlacementGroup
  /// Creates a new Placement Group.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Request body (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "name": "my Placement Group",
  ///   "type": "spread"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "placement_group": {
  ///     "id": 897,
  ///     "name": "my Placement Group",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "type": "spread",
  ///     "created": "2019-01-08T12:10:00Z",
  ///     "servers": []
  ///   }
  /// }
  /// ```
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<
      _i13.CreatePlacementGroupResponse,
      _i10.Response<_i7.Object?>
    >
  >
  createPlacementGroup({
    required _i14.PlacementGroupsPostBodyBodyModel body,
    _i8.TonikCancellation? cancellation,
  }) async =>
      this._createPlacementGroup(body: body, cancellation: cancellation);

  /// Get a PlacementGroup
  /// Gets a specific Placement Group object.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "placement_group": {
  ///     "id": 897,
  ///     "name": "my Placement Group",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "type": "spread",
  ///     "created": "2019-01-08T12:10:00Z",
  ///     "servers": [
  ///       4711,
  ///       4712
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<_i15.GetPlacementGroupResponse, _i10.Response<_i7.Object?>>
  >
  getPlacementGroup({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._getPlacementGroup(id: id, cancellation: cancellation);

  /// Update a PlacementGroup
  /// Updates the Placement Group properties.
  ///
  /// Note: if the Placement Group object changes during the request, the response will be a “conflict” error.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "placement_group": {
  ///     "id": 897,
  ///     "name": "my Placement Group",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "type": "spread",
  ///     "created": "2019-01-08T12:10:00Z",
  ///     "servers": [
  ///       4711,
  ///       4712
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<
      _i16.UpdatePlacementGroupResponse,
      _i10.Response<_i7.Object?>
    >
  >
  updatePlacementGroup({
    required _i17.PlacementGroupsIdPutBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._updatePlacementGroup(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Delete a PlacementGroup
  /// Deletes a Placement Group.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<
      _i18.DeletePlacementGroupResponse,
      _i10.Response<_i7.Object?>
    >
  >
  deletePlacementGroup({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._deletePlacementGroup(id: id, cancellation: cancellation);
}
