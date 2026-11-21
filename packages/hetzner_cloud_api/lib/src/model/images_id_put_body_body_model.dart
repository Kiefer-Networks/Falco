// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/images_id_put_body_body_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ImagesIdPutBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ImagesIdPutBodyBodyModel({this.description, this.$type, this.labels});

  factory ImagesIdPutBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ImagesIdPutBodyBodyModel: contains complex types',
    );
  }

  factory ImagesIdPutBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ImagesIdPutBodyBodyModel');
    return ImagesIdPutBodyBodyModel(
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'ImagesIdPutBodyBodyModel.description',
      ),
      $type: _$map[r'type'] == null
          ? null
          : _i4.ImagesIdPutBodyBodyTypeModel.fromJson(_$map[r'type']),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(context: r'ImagesIdPutBodyBodyModel.labels'),
        context: r'ImagesIdPutBodyBodyModel.labels',
      ),
    );
  }

  factory ImagesIdPutBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ImagesIdPutBodyBodyModel: contains complex types',
    );
  }

  /// New description of Image.
  ///
  /// **Example**:
  /// ```
  /// My new Image description
  /// ```
  final _i3.String? description;

  /// Destination Image type to convert to.
  final _i4.ImagesIdPutBodyBodyTypeModel? $type;

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

  @_i3.override
  _i3.Object? toJson() => {
    if (this.description != null) r'description': this.description,
    if (this.$type != null) r'type': this.$type?.toJson(),
    if (this.labels != null) r'labels': this.labels,
  };

  ImagesIdPutBodyBodyModel Function({
    _i3.String? description,
    _i4.ImagesIdPutBodyBodyTypeModel? $type,
    _i3.Map<_i3.String, _i3.String>? labels,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? description = _sentinel,
      _i3.Object? $type = _sentinel,
      _i3.Object? labels = _sentinel,
    }) => ImagesIdPutBodyBodyModel(
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i4.ImagesIdPutBodyBodyTypeModel?),
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is ImagesIdPutBodyBodyModel &&
        other.description == this.description &&
        other.$type == this.$type &&
        _$deepEquals.equals(other.labels, this.labels);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.description,
      this.$type,
      deepEquals.hash(this.labels),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ImagesIdPutBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ImagesIdPutBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
