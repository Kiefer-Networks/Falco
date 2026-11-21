// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_placement_group_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// The placement group the server is assigned to.
@_i2.immutable
class $RawServersPost201BodyServerPlacementGroupModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawServersPost201BodyServerPlacementGroupModel({
    required this.id,
    required this.name,
    required this.labels,
    required this.$type,
    required this.created,
    required this.servers,
  });

  factory $RawServersPost201BodyServerPlacementGroupModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for $RawServersPost201BodyServerPlacementGroupModel: contains complex types',
    );
  }

  factory $RawServersPost201BodyServerPlacementGroupModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawServersPost201BodyServerPlacementGroupModel',
    );
    return $RawServersPost201BodyServerPlacementGroupModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'$RawServersPost201BodyServerPlacementGroupModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'$RawServersPost201BodyServerPlacementGroupModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'$RawServersPost201BodyServerPlacementGroupModel.labels',
        ),
        context: r'$RawServersPost201BodyServerPlacementGroupModel.labels',
      ),
      $type: _i4.ServersPost201BodyServerPlacementGroupTypeModel.fromJson(
        _$map[r'type'],
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'$RawServersPost201BodyServerPlacementGroupModel.created',
      ),
      servers: _$map[r'servers'].decodeJsonList<_i3.int>(
        context: r'$RawServersPost201BodyServerPlacementGroupModel.servers',
      ),
    );
  }

  factory $RawServersPost201BodyServerPlacementGroupModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for $RawServersPost201BodyServerPlacementGroupModel: contains complex types',
    );
  }

  /// ID of the [Placement Group](#tag/placement-groups).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the Resource. Must be unique per Project.
  ///
  /// **Example**:
  /// ```
  /// my-resource
  /// ```
  final _i3.String name;

  /// User-defined labels (`key/value` pairs) for the Resource.
  /// For more information, see "[Labels](#description/labels)".
  ///
  ///
  /// **Example**:
  /// ```json
  /// {
  ///   "environment": "prod",
  ///   "example.com/my": "label",
  ///   "just-a-key": ""
  /// }
  /// ```
  final _i3.Map<_i3.String, _i3.String> labels;

  /// Type of Placement Group.
  ///
  ///
  /// **Example**:
  /// ```
  /// spread
  /// ```
  final _i4.ServersPost201BodyServerPlacementGroupTypeModel $type;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  /// Array of IDs of Servers that are part of this Placement Group.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   42
  /// ]
  /// ```
  final _i3.List<_i3.int> servers;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'labels': this.labels,
    r'type': this.$type.toJson(),
    r'created': this.created.toTimeZonedIso8601String(),
    r'servers': this.servers,
  };

  $RawServersPost201BodyServerPlacementGroupModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i4.ServersPost201BodyServerPlacementGroupTypeModel? $type,
    _i3.DateTime? created,
    _i3.List<_i3.int>? servers,
  })
  get copyWith {
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i4.ServersPost201BodyServerPlacementGroupTypeModel? $type,
      _i3.DateTime? created,
      _i3.List<_i3.int>? servers,
    }) => $RawServersPost201BodyServerPlacementGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      labels: labels ?? this.labels,
      $type: $type ?? this.$type,
      created: created ?? this.created,
      servers: servers ?? this.servers,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is $RawServersPost201BodyServerPlacementGroupModel &&
        other.id == this.id &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.$type == this.$type &&
        other.created == this.created &&
        _$deepEquals.equals(other.servers, this.servers);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      deepEquals.hash(this.labels),
      this.$type,
      this.created,
      deepEquals.hash(this.servers),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersPost201BodyServerPlacementGroupModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode $RawServersPost201BodyServerPlacementGroupModel: complex types cannot be URI-encoded',
    );
  }
}

typedef ServersPost201BodyServerPlacementGroupModel =
    $RawServersPost201BodyServerPlacementGroupModel?;
