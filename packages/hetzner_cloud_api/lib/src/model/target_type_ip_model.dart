// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/target_type_ip_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TargetTypeIpModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TargetTypeIpModel({required this.$type});

  factory TargetTypeIpModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'type'},
      listKeys: {},
      context: r'TargetTypeIpModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return TargetTypeIpModel(
      $type: _i4.TargetTypeIpTypeModel.fromSimple(
        _$values[r'type'],
        explode: explode,
      ),
    );
  }

  factory TargetTypeIpModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TargetTypeIpModel');
    return TargetTypeIpModel(
      $type: _i4.TargetTypeIpTypeModel.fromJson(_$map[r'type']),
    );
  }

  factory TargetTypeIpModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'type'},
      listKeys: {},
      context: r'TargetTypeIpModel',
    );
    return TargetTypeIpModel(
      $type: _i4.TargetTypeIpTypeModel.fromForm(
        _$values[r'type'],
        explode: explode,
      ),
    );
  }

  /// Type of the resource.
  final _i4.TargetTypeIpTypeModel $type;

  @_i3.override
  _i3.Object? toJson() => {r'type': this.$type.toJson()};

  TargetTypeIpModel Function({_i4.TargetTypeIpTypeModel? $type}) get copyWith {
    return ({_i4.TargetTypeIpTypeModel? $type}) =>
        TargetTypeIpModel($type: $type ?? this.$type);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TargetTypeIpModel && other.$type == this.$type;
  }

  @_i3.override
  _i3.int get hashCode => this.$type.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'type'] = _i1.PropertyValue.scalar(this.$type.toJson());
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
      r'Cannot uriEncode TargetTypeIpModel: complex types cannot be URI-encoded',
    );
  }
}
