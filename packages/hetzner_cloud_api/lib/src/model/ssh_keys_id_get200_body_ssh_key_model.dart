// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SshKeysIdGet200BodySshKeyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SshKeysIdGet200BodySshKeyModel({
    required this.id,
    required this.name,
    required this.fingerprint,
    required this.publicKey,
    required this.labels,
    required this.created,
  });

  factory SshKeysIdGet200BodySshKeyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SshKeysIdGet200BodySshKeyModel: contains complex types',
    );
  }

  factory SshKeysIdGet200BodySshKeyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SshKeysIdGet200BodySshKeyModel');
    return SshKeysIdGet200BodySshKeyModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'SshKeysIdGet200BodySshKeyModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'SshKeysIdGet200BodySshKeyModel.name',
      ),
      fingerprint: _$map[r'fingerprint'].decodeJsonString(
        context: r'SshKeysIdGet200BodySshKeyModel.fingerprint',
      ),
      publicKey: _$map[r'public_key'].decodeJsonString(
        context: r'SshKeysIdGet200BodySshKeyModel.public_key',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'SshKeysIdGet200BodySshKeyModel.labels',
        ),
        context: r'SshKeysIdGet200BodySshKeyModel.labels',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'SshKeysIdGet200BodySshKeyModel.created',
      ),
    );
  }

  factory SshKeysIdGet200BodySshKeyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SshKeysIdGet200BodySshKeyModel: contains complex types',
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

  SshKeysIdGet200BodySshKeyModel Function({
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
    }) => SshKeysIdGet200BodySshKeyModel(
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
    return other is SshKeysIdGet200BodySshKeyModel &&
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
    r'parameterProperties not supported for SshKeysIdGet200BodySshKeyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SshKeysIdGet200BodySshKeyModel: complex types cannot be URI-encoded',
    );
  }
}
