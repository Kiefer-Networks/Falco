// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_assign_post_body_body_assignee_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PrimaryIpsIdActionsAssignPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PrimaryIpsIdActionsAssignPostBodyBodyModel({
    required this.assigneeType,
    required this.assigneeId,
  });

  factory PrimaryIpsIdActionsAssignPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'assignee_type', r'assignee_id'},
      listKeys: {},
      context: r'PrimaryIpsIdActionsAssignPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return PrimaryIpsIdActionsAssignPostBodyBodyModel(
      assigneeType:
          _i4.PrimaryIpsIdActionsAssignPostBodyBodyAssigneeTypeModel.fromSimple(
            _$values[r'assignee_type'],
            explode: explode,
          ),
      assigneeId: _$values[r'assignee_id'].decodeSimpleInt(
        context: r'PrimaryIpsIdActionsAssignPostBodyBodyModel.assignee_id',
      ),
    );
  }

  factory PrimaryIpsIdActionsAssignPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'PrimaryIpsIdActionsAssignPostBodyBodyModel',
    );
    return PrimaryIpsIdActionsAssignPostBodyBodyModel(
      assigneeType:
          _i4.PrimaryIpsIdActionsAssignPostBodyBodyAssigneeTypeModel.fromJson(
            _$map[r'assignee_type'],
          ),
      assigneeId: _$map[r'assignee_id'].decodeJsonInt(
        context: r'PrimaryIpsIdActionsAssignPostBodyBodyModel.assignee_id',
      ),
    );
  }

  factory PrimaryIpsIdActionsAssignPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'assignee_type', r'assignee_id'},
      listKeys: {},
      context: r'PrimaryIpsIdActionsAssignPostBodyBodyModel',
    );
    return PrimaryIpsIdActionsAssignPostBodyBodyModel(
      assigneeType:
          _i4.PrimaryIpsIdActionsAssignPostBodyBodyAssigneeTypeModel.fromForm(
            _$values[r'assignee_type'],
            explode: explode,
          ),
      assigneeId: _$values[r'assignee_id'].decodeFormInt(
        context: r'PrimaryIpsIdActionsAssignPostBodyBodyModel.assignee_id',
      ),
    );
  }

  /// Type of resource assigning the Primary IP to.
  ///
  /// **Example**:
  /// ```
  /// server
  /// ```
  final _i4.PrimaryIpsIdActionsAssignPostBodyBodyAssigneeTypeModel assigneeType;

  /// ID of a resource of type `assignee_type`.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int assigneeId;

  @_i3.override
  _i3.Object? toJson() => {
    r'assignee_type': this.assigneeType.toJson(),
    r'assignee_id': this.assigneeId,
  };

  PrimaryIpsIdActionsAssignPostBodyBodyModel Function({
    _i4.PrimaryIpsIdActionsAssignPostBodyBodyAssigneeTypeModel? assigneeType,
    _i3.int? assigneeId,
  })
  get copyWith {
    return ({
      _i4.PrimaryIpsIdActionsAssignPostBodyBodyAssigneeTypeModel? assigneeType,
      _i3.int? assigneeId,
    }) => PrimaryIpsIdActionsAssignPostBodyBodyModel(
      assigneeType: assigneeType ?? this.assigneeType,
      assigneeId: assigneeId ?? this.assigneeId,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PrimaryIpsIdActionsAssignPostBodyBodyModel &&
        other.assigneeType == this.assigneeType &&
        other.assigneeId == this.assigneeId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.assigneeType, this.assigneeId]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'assignee_type'] = _i1.PropertyValue.scalar(
      this.assigneeType.toJson(),
    );
    _$result[r'assignee_id'] = _i1.PropertyValue.scalar(
      this.assigneeId.toString(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PrimaryIpsIdActionsAssignPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
