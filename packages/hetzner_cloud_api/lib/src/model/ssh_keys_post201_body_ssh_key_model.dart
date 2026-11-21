// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SshKeysPost201BodySshKeyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SshKeysPost201BodySshKeyModel({
    required this.id,
    required this.name,
    required this.fingerprint,
    required this.publicKey,
    required this.labels,
    required this.created,
  });

  factory SshKeysPost201BodySshKeyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SshKeysPost201BodySshKeyModel: contains complex types',
    );
  }

  factory SshKeysPost201BodySshKeyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SshKeysPost201BodySshKeyModel');
    return SshKeysPost201BodySshKeyModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'SshKeysPost201BodySshKeyModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'SshKeysPost201BodySshKeyModel.name',
      ),
      fingerprint: _$map[r'fingerprint'].decodeJsonString(
        context: r'SshKeysPost201BodySshKeyModel.fingerprint',
      ),
      publicKey: _$map[r'public_key'].decodeJsonString(
        context: r'SshKeysPost201BodySshKeyModel.public_key',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'SshKeysPost201BodySshKeyModel.labels',
        ),
        context: r'SshKeysPost201BodySshKeyModel.labels',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'SshKeysPost201BodySshKeyModel.created',
      ),
    );
  }

  factory SshKeysPost201BodySshKeyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SshKeysPost201BodySshKeyModel: contains complex types',
    );
  }

  /// ID of the [SSH Key](#tag/ssh-keys).
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

  /// MD5 fingerprint of the SSH public key.
  ///
  /// **Example**:
  /// ```
  /// b7:2f:30:a0:2f:6c:58:6c:21:04:58:61:ba:06:3b:2f
  /// ```
  final _i3.String fingerprint;

  /// Public key.
  ///
  /// **Example**:
  /// ```
  /// ssh-rsa AAAjjk76kgf...Xt
  /// ```
  final _i3.String publicKey;

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

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'fingerprint': this.fingerprint,
    r'public_key': this.publicKey,
    r'labels': this.labels,
    r'created': this.created.toTimeZonedIso8601String(),
  };

  SshKeysPost201BodySshKeyModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? fingerprint,
    _i3.String? publicKey,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.DateTime? created,
  })
  get copyWith {
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.String? fingerprint,
      _i3.String? publicKey,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.DateTime? created,
    }) => SshKeysPost201BodySshKeyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fingerprint: fingerprint ?? this.fingerprint,
      publicKey: publicKey ?? this.publicKey,
      labels: labels ?? this.labels,
      created: created ?? this.created,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is SshKeysPost201BodySshKeyModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.fingerprint == this.fingerprint &&
        other.publicKey == this.publicKey &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.created == this.created;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.fingerprint,
      this.publicKey,
      deepEquals.hash(this.labels),
      this.created,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for SshKeysPost201BodySshKeyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SshKeysPost201BodySshKeyModel: complex types cannot be URI-encoded',
    );
  }
}
