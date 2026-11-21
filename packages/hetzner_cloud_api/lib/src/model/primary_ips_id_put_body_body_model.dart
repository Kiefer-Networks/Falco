// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PrimaryIpsIdPutBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PrimaryIpsIdPutBodyBodyModel({
    this.name,
    this.labels,
    this.autoDelete = autoDeleteDefault,
  });

  factory PrimaryIpsIdPutBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PrimaryIpsIdPutBodyBodyModel: contains complex types',
    );
  }

  factory PrimaryIpsIdPutBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PrimaryIpsIdPutBodyBodyModel');
    return PrimaryIpsIdPutBodyBodyModel(
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'PrimaryIpsIdPutBodyBodyModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) =>
            v.decodeJsonString(context: r'PrimaryIpsIdPutBodyBodyModel.labels'),
        context: r'PrimaryIpsIdPutBodyBodyModel.labels',
      ),
      autoDelete: _$map.containsKey(r'auto_delete')
          ? _$map[r'auto_delete'].decodeJsonBool(
              context: r'PrimaryIpsIdPutBodyBodyModel.auto_delete',
            )
          : autoDeleteDefault,
    );
  }

  factory PrimaryIpsIdPutBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PrimaryIpsIdPutBodyBodyModel: contains complex types',
    );
  }

  static const _i3.bool autoDeleteDefault = false;

  /// Name of the Resource. Must be unique per Project.
  ///
  /// **Example**:
  /// ```
  /// my-resource
  /// ```
  final _i3.String? name;

  /// User-defined labels (`key/value` pairs) for the Resource.
  ///
  /// Note that the set of [Labels](#description/labels) provided in the request will overwrite the
  /// existing one.
  ///
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
  final _i3.Map<_i3.String, _i3.String>? labels;

  /// Auto deletion state.
  ///
  /// If enabled the [Primary IP](#tag/primary-ips) will be deleted once the assigned resource gets deleted.
  ///
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? autoDelete;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.name != null) r'name': this.name,
    if (this.labels != null) r'labels': this.labels,
    if (this.autoDelete != null) r'auto_delete': this.autoDelete,
  };

  PrimaryIpsIdPutBodyBodyModel Function({
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.bool? autoDelete,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? name = _sentinel,
      _i3.Object? labels = _sentinel,
      _i3.Object? autoDelete = _sentinel,
    }) => PrimaryIpsIdPutBodyBodyModel(
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      autoDelete: _i3.identical(autoDelete, _sentinel)
          ? this.autoDelete
          : (autoDelete as _i3.bool?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is PrimaryIpsIdPutBodyBodyModel &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.autoDelete == this.autoDelete;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      deepEquals.hash(this.labels),
      this.autoDelete,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PrimaryIpsIdPutBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PrimaryIpsIdPutBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
