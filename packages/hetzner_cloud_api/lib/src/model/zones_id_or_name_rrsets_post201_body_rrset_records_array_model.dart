// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Record of a [RRSet](#tag/zone-rrsets).
///
/// The `value` is used to identify the record in an [RRSet](#tag/zone-rrsets).
///
@_i2.immutable
class ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel({
    required this.value,
    this.comment,
  });

  factory ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'value', r'comment'},
      listKeys: {},
      context: r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel(
      value: _$values[r'value'].decodeSimpleString(
        context: r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.value',
      ),
      comment: _$values[r'comment'].decodeSimpleNullableString(
        context:
            r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.comment',
      ),
    );
  }

  factory ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel',
    );
    return ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel(
      value: _$map[r'value'].decodeJsonString(
        context: r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.value',
      ),
      comment: _$map[r'comment'].decodeJsonNullableString(
        context:
            r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.comment',
      ),
    );
  }

  factory ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'value', r'comment'},
      listKeys: {},
      context: r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel',
    );
    return ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel(
      value: _$values[r'value'].decodeFormString(
        context: r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.value',
      ),
      comment: _$values[r'comment'].decodeFormNullableString(
        context:
            r'ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel.comment',
      ),
    );
  }

  /// Value of the record.
  ///
  /// For details about accepted values, see the [DNS record types documentation](https://docs.hetzner.com/networking/dns/record-types/overview/).
  ///
  ///
  /// **Example**:
  /// ```
  /// 198.51.100.1
  /// ```
  final _i3.String value;

  /// Comment of the record.
  ///
  /// **Example**:
  /// ```
  /// My web server at Hetzner Cloud.
  /// ```
  final _i3.String? comment;

  @_i3.override
  _i3.Object? toJson() => {
    r'value': this.value,
    if (this.comment != null) r'comment': this.comment,
  };

  ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel Function({
    _i3.String? value,
    _i3.String? comment,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.String? value, _i3.Object? comment = _sentinel}) =>
        ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel(
          value: value ?? this.value,
          comment: _i3.identical(comment, _sentinel)
              ? this.comment
              : (comment as _i3.String?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel &&
        other.value == this.value &&
        other.comment == this.comment;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.value, this.comment]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'value'] = _i1.PropertyValue.scalar(this.value);
    if (this.comment != null) {
      _$result[r'comment'] = _i1.PropertyValue.scalar(this.comment!);
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameRrsetsPost201BodyRrsetRecordsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
