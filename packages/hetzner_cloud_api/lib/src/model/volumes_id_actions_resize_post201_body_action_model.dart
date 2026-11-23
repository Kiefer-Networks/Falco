// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_resize_post201_body_action_error_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_resize_post201_body_action_resources_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_resize_post201_body_action_status_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class VolumesIdActionsResizePost201BodyActionModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const VolumesIdActionsResizePost201BodyActionModel({
    required this.id,
    required this.command,
    required this.status,
    required this.started,
    required this.finished,
    required this.progress,
    required this.resources,
    required this.error,
  });

  factory VolumesIdActionsResizePost201BodyActionModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for VolumesIdActionsResizePost201BodyActionModel: contains complex types',
    );
  }

  factory VolumesIdActionsResizePost201BodyActionModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'VolumesIdActionsResizePost201BodyActionModel',
    );
    return VolumesIdActionsResizePost201BodyActionModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'VolumesIdActionsResizePost201BodyActionModel.id',
      ),
      command: _$map[r'command'].decodeJsonString(
        context: r'VolumesIdActionsResizePost201BodyActionModel.command',
      ),
      status: _i4.VolumesIdActionsResizePost201BodyActionStatusModel.fromJson(
        _$map[r'status'],
      ),
      started: _$map[r'started'].decodeJsonDateTime(
        context: r'VolumesIdActionsResizePost201BodyActionModel.started',
      ),
      finished: _$map[r'finished'].decodeJsonNullableDateTime(
        context: r'VolumesIdActionsResizePost201BodyActionModel.finished',
      ),
      progress: _$map[r'progress'].decodeJsonInt(
        context: r'VolumesIdActionsResizePost201BodyActionModel.progress',
      ),
      resources: _$map[r'resources']
          .decodeJsonList<_i3.Object?>(
            context: r'VolumesIdActionsResizePost201BodyActionModel.resources',
          )
          .map(
            _i5
                .VolumesIdActionsResizePost201BodyActionResourcesArrayModel
                .fromJson,
          )
          .toList(),
      error: _$map[r'error'] == null
          ? null
          : _i6.VolumesIdActionsResizePost201BodyActionErrorModel.fromJson(
              _$map[r'error'],
            ),
    );
  }

  factory VolumesIdActionsResizePost201BodyActionModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for VolumesIdActionsResizePost201BodyActionModel: contains complex types',
    );
  }

  /// ID of the [Action](#description/actions).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Command executed in the Action.
  ///
  /// **Example**:
  /// ```
  /// start_resource
  /// ```
  final _i3.String command;

  /// Status of the Action.
  final _i4.VolumesIdActionsResizePost201BodyActionStatusModel status;

  /// Point in time when the Action was started (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime started;

  /// Point in time when the Action was finished (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format). Only set if the Action is finished otherwise null.
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime? finished;

  /// Progress of the Action in percent.
  ///
  /// **Example**:
  /// ```json
  /// 100
  /// ```
  final _i3.int progress;

  /// Resources the Action relates to.
  final _i3.List<_i5.VolumesIdActionsResizePost201BodyActionResourcesArrayModel>
  resources;

  /// Error message for the Action if an error occurred, otherwise null.
  final _i6.VolumesIdActionsResizePost201BodyActionErrorModel? error;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'command': this.command,
    r'status': this.status.toJson(),
    r'started': this.started.toTimeZonedIso8601String(),
    r'finished': this.finished?.toTimeZonedIso8601String(),
    r'progress': this.progress,
    r'resources': this.resources.map((e) => e.toJson()).toList(),
    r'error': this.error?.toJson(),
  };

  VolumesIdActionsResizePost201BodyActionModel Function({
    _i3.int? id,
    _i3.String? command,
    _i4.VolumesIdActionsResizePost201BodyActionStatusModel? status,
    _i3.DateTime? started,
    _i3.DateTime? finished,
    _i3.int? progress,
    _i3.List<_i5.VolumesIdActionsResizePost201BodyActionResourcesArrayModel>?
    resources,
    _i6.VolumesIdActionsResizePost201BodyActionErrorModel? error,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? command,
      _i4.VolumesIdActionsResizePost201BodyActionStatusModel? status,
      _i3.DateTime? started,
      _i3.Object? finished = _sentinel,
      _i3.int? progress,
      _i3.List<_i5.VolumesIdActionsResizePost201BodyActionResourcesArrayModel>?
      resources,
      _i3.Object? error = _sentinel,
    }) => VolumesIdActionsResizePost201BodyActionModel(
      id: id ?? this.id,
      command: command ?? this.command,
      status: status ?? this.status,
      started: started ?? this.started,
      finished: _i3.identical(finished, _sentinel)
          ? this.finished
          : (finished as _i3.DateTime?),
      progress: progress ?? this.progress,
      resources: resources ?? this.resources,
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error as _i6.VolumesIdActionsResizePost201BodyActionErrorModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is VolumesIdActionsResizePost201BodyActionModel &&
        other.id == this.id &&
        other.command == this.command &&
        other.status == this.status &&
        other.started == this.started &&
        other.finished == this.finished &&
        other.progress == this.progress &&
        _$deepEquals.equals(other.resources, this.resources) &&
        other.error == this.error;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.command,
      this.status,
      this.started,
      this.finished,
      this.progress,
      deepEquals.hash(this.resources),
      this.error,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for VolumesIdActionsResizePost201BodyActionModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode VolumesIdActionsResizePost201BodyActionModel: complex types cannot be URI-encoded',
    );
  }
}
