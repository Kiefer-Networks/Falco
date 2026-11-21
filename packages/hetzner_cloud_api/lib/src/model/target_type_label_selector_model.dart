// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/target_type_label_selector_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TargetTypeLabelSelectorModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TargetTypeLabelSelectorModel({required this.$type});

  factory TargetTypeLabelSelectorModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'type'},
      listKeys: {},
      context: r'TargetTypeLabelSelectorModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return TargetTypeLabelSelectorModel(
      $type: _i4.TargetTypeLabelSelectorTypeModel.fromSimple(
        _$values[r'type'],
        explode: explode,
      ),
    );
  }

  factory TargetTypeLabelSelectorModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TargetTypeLabelSelectorModel');
    return TargetTypeLabelSelectorModel(
      $type: _i4.TargetTypeLabelSelectorTypeModel.fromJson(_$map[r'type']),
    );
  }

  factory TargetTypeLabelSelectorModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'type'},
      listKeys: {},
      context: r'TargetTypeLabelSelectorModel',
    );
    return TargetTypeLabelSelectorModel(
      $type: _i4.TargetTypeLabelSelectorTypeModel.fromForm(
        _$values[r'type'],
        explode: explode,
      ),
    );
  }

  /// Type of the resource.
  final _i4.TargetTypeLabelSelectorTypeModel $type;

  @_i3.override
  _i3.Object? toJson() => {r'type': this.$type.toJson()};

  TargetTypeLabelSelectorModel Function({
    _i4.TargetTypeLabelSelectorTypeModel? $type,
  })
  get copyWith {
    return ({_i4.TargetTypeLabelSelectorTypeModel? $type}) =>
        TargetTypeLabelSelectorModel($type: $type ?? this.$type);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TargetTypeLabelSelectorModel && other.$type == this.$type;
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
      r'Cannot uriEncode TargetTypeLabelSelectorModel: complex types cannot be URI-encoded',
    );
  }
}
