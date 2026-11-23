// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsIdPutBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsIdPutBodyBodyModel({this.name, this.labels});

  factory FirewallsIdPutBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsIdPutBodyBodyModel: contains complex types',
    );
  }

  factory FirewallsIdPutBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FirewallsIdPutBodyBodyModel');
    return FirewallsIdPutBodyBodyModel(
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'FirewallsIdPutBodyBodyModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) =>
            v.decodeJsonString(context: r'FirewallsIdPutBodyBodyModel.labels'),
        context: r'FirewallsIdPutBodyBodyModel.labels',
      ),
    );
  }

  factory FirewallsIdPutBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsIdPutBodyBodyModel: contains complex types',
    );
  }

  /// Name of the [Firewall](#tag/firewalls).
  ///
  /// Must be unique per Project.
  ///
  ///
  /// **Example**:
  /// ```
  /// new-name
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

  @_i3.override
  _i3.Object? toJson() => {
    if (this.name != null) r'name': this.name,
    if (this.labels != null) r'labels': this.labels,
  };

  FirewallsIdPutBodyBodyModel Function({
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? name = _sentinel, _i3.Object? labels = _sentinel}) =>
        FirewallsIdPutBodyBodyModel(
          name: _i3.identical(name, _sentinel)
              ? this.name
              : (name as _i3.String?),
          labels: _i3.identical(labels, _sentinel)
              ? this.labels
              : (labels as _i3.Map<_i3.String, _i3.String>?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is FirewallsIdPutBodyBodyModel &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([this.name, deepEquals.hash(this.labels)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsIdPutBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsIdPutBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
