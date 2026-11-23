// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i6;

import 'package:dio/dio.dart' as _i9;
import 'package:hetzner_cloud_api/src/model/images_id_put_body_body_model.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/model/images_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/images_parameters_array_model2.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/images_parameters_array_model3.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/model/images_parameters_model.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/operation/delete_image.dart' as _i5;
import 'package:hetzner_cloud_api/src/operation/get_image.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/list_images.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_image.dart' as _i4;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_image_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/get_image_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/list_images_response.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/response_wrapper/update_image_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i7;

/// Images are blueprints for your VM disks. They can be of different types:
///
/// ### System Images
///
/// Distribution Images maintained by us, e.g. “Ubuntu 20.04”
///
/// ### Snapshot Images
///
/// Maintained by you, for example “Ubuntu 20.04 with my own settings”. These are billed per GB per month.
///
/// ### Backup Images
///
/// Daily Backups of your Server. Will automatically be created for Servers which have backups enabled (`POST /servers/{id}/actions/enable_backup`)
///
/// Bound to exactly one Server. If you delete the Server, you also delete all backups bound to it. You may convert backup Images to snapshot Images to keep them.
///
/// These are billed at 20% of your server price for 7 backup slots.
///
/// ### App Images
///
/// Prebuild images with specific software configurations, e.g. “Wordpress”. All app images are created by us.
///
class ImagesApi {
  ImagesApi(_i1.Server server)
    : _listImages = _i2.ListImages(server.baseUrl, () => server.dio),
      _getImage = _i3.GetImage(server.baseUrl, () => server.dio),
      _updateImage = _i4.UpdateImage(server.baseUrl, () => server.dio),
      _deleteImage = _i5.DeleteImage(server.baseUrl, () => server.dio);

  final _i2.ListImages _listImages;

  final _i3.GetImage _getImage;

  final _i4.UpdateImage _updateImage;

  final _i5.DeleteImage _deleteImage;

  /// List Images
  /// Returns all Image objects. You can select specific Image types only and sort the results by using URI parameters.
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
  _i6.Future<_i7.TonikResult<_i8.ListImagesResponse, _i9.Response<_i6.Object?>>>
  listImages({
    _i6.List<_i10.ImagesParametersArrayModel3>? sort,
    _i6.List<_i11.ImagesParametersArrayModel>? $type,
    _i6.List<_i12.ImagesParametersArrayModel2>? status,
    _i6.List<_i6.String>? boundTo,
    _i6.bool? includeDeprecated,
    _i6.String? name,
    _i6.String? labelSelector,
    _i13.ImagesParametersModel? architecture,
    _i6.int page = _i2.ListImages.pageDefault,
    _i6.int perPage = _i2.ListImages.perPageDefault,
    _i7.TonikCancellation? cancellation,
  }) async => this._listImages(
    sort: sort,
    $type: $type,
    status: status,
    boundTo: boundTo,
    includeDeprecated: includeDeprecated,
    name: name,
    labelSelector: labelSelector,
    architecture: architecture,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an Image
  /// Returns a specific Image object.
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
  _i6.Future<_i7.TonikResult<_i14.GetImageResponse, _i9.Response<_i6.Object?>>>
  getImage({required _i6.int id, _i7.TonikCancellation? cancellation}) async =>
      this._getImage(id: id, cancellation: cancellation);

  /// Update an Image
  /// Updates the Image. You may change the description, convert a Backup Image to a Snapshot Image or change the Image labels. Only Images of type `snapshot` and `backup` can be updated.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "image": {
  ///     "id": 4711,
  ///     "type": "snapshot",
  ///     "status": "available",
  ///     "name": null,
  ///     "description": "My new Image description",
  ///     "image_size": 2.3,
  ///     "disk_size": 10,
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "created_from": {
  ///       "id": 1,
  ///       "name": "Server"
  ///     },
  ///     "bound_to": null,
  ///     "os_flavor": "ubuntu",
  ///     "os_version": "20.04",
  ///     "rapid_deploy": false,
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "deprecation": null,
  ///     "deleted": null,
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "architecture": "x86"
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
  _i6.Future<
    _i7.TonikResult<_i15.UpdateImageResponse, _i9.Response<_i6.Object?>>
  >
  updateImage({
    required _i16.ImagesIdPutBodyBodyModel body,
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => this._updateImage(body: body, id: id, cancellation: cancellation);

  /// Delete an Image
  /// Deletes an Image. Only Images of type `snapshot` and `backup` can be deleted.
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
  _i6.Future<
    _i7.TonikResult<_i17.DeleteImageResponse, _i9.Response<_i6.Object?>>
  >
  deleteImage({
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => this._deleteImage(id: id, cancellation: cancellation);
}
