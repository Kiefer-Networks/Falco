// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CertificatesPost201BodyCertificateUsedByArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CertificatesPost201BodyCertificateUsedByArrayModel({
    required this.id,
    required this.$type,
  });

  factory CertificatesPost201BodyCertificateUsedByArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'type'},
      listKeys: {},
      context: r'CertificatesPost201BodyCertificateUsedByArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return CertificatesPost201BodyCertificateUsedByArrayModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'CertificatesPost201BodyCertificateUsedByArrayModel.id',
      ),
      $type: _$values[r'type'].decodeSimpleString(
        context: r'CertificatesPost201BodyCertificateUsedByArrayModel.type',
      ),
    );
  }

  factory CertificatesPost201BodyCertificateUsedByArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'CertificatesPost201BodyCertificateUsedByArrayModel',
    );
    return CertificatesPost201BodyCertificateUsedByArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'CertificatesPost201BodyCertificateUsedByArrayModel.id',
      ),
      $type: _$map[r'type'].decodeJsonString(
        context: r'CertificatesPost201BodyCertificateUsedByArrayModel.type',
      ),
    );
  }

  factory CertificatesPost201BodyCertificateUsedByArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'type'},
      listKeys: {},
      context: r'CertificatesPost201BodyCertificateUsedByArrayModel',
    );
    return CertificatesPost201BodyCertificateUsedByArrayModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'CertificatesPost201BodyCertificateUsedByArrayModel.id',
      ),
      $type: _$values[r'type'].decodeFormString(
        context: r'CertificatesPost201BodyCertificateUsedByArrayModel.type',
      ),
    );
  }

  /// ID of resource referenced.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int id;

  /// Type of resource referenced.
  ///
  /// **Example**:
  /// ```
  /// load_balancer
  /// ```
  final _i3.String $type;

  @_i3.override
  _i3.Object? toJson() => {r'id': this.id, r'type': this.$type};

  CertificatesPost201BodyCertificateUsedByArrayModel Function({
    _i3.int? id,
    _i3.String? $type,
  })
  get copyWith {
    return ({_i3.int? id, _i3.String? $type}) =>
        CertificatesPost201BodyCertificateUsedByArrayModel(
          id: id ?? this.id,
          $type: $type ?? this.$type,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CertificatesPost201BodyCertificateUsedByArrayModel &&
        other.id == this.id &&
        other.$type == this.$type;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.id, this.$type]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    _$result[r'type'] = _i1.PropertyValue.scalar(this.$type);
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
      r'Cannot uriEncode CertificatesPost201BodyCertificateUsedByArrayModel: complex types cannot be URI-encoded',
    );
  }
}
