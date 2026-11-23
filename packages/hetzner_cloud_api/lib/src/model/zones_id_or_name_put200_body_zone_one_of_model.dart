// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_put200_body_zone_one_of_all_of_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_put200_body_zone_one_of_all_of_model2.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
sealed class ZonesIdOrNamePut200BodyZoneOneOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ZonesIdOrNamePut200BodyZoneOneOfModel();

  factory ZonesIdOrNamePut200BodyZoneOneOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    try {
      return ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(
        _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel.fromSimple(
          value,
          explode: explode,
          isHeader: isHeader,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(
        _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2.fromSimple(
          value,
          explode: explode,
          isHeader: isHeader,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid simple value for ZonesIdOrNamePut200BodyZoneOneOfModel',
    );
  }

  factory ZonesIdOrNamePut200BodyZoneOneOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    try {
      return ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(
        _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel.fromForm(
          value,
          explode: explode,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(
        _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2.fromForm(
          value,
          explode: explode,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid form value for ZonesIdOrNamePut200BodyZoneOneOfModel',
    );
  }

  factory ZonesIdOrNamePut200BodyZoneOneOfModel.fromJson(_i3.Object? json) {
    final _$discriminator = json is _i3.Map<_i3.String, _i3.Object?>
        ? json[r'mode']
        : null;
    final _$result = switch (_$discriminator) {
      _ => null,
    };
    if (_$result != null) {
      return _$result;
    }
    try {
      return ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(
        _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel.fromJson(json),
      );
    } on _i3.Object catch (_) {}
    try {
      return ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(
        _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2.fromJson(json),
      );
    } on _i3.Object catch (_) {}
    throw _i1.JsonDecodingException(
      r'Invalid JSON for ZonesIdOrNamePut200BodyZoneOneOfModel',
    );
  }

  _i1.EncodingShape get currentEncodingShape {
    return switch (this) {
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(:final value) =>
        value.currentEncodingShape,
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(:final value) =>
        value.currentEncodingShape,
    };
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    return switch (this) {
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(:final value) =>
        value.parameterProperties(allowEmpty: allowEmpty),
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(:final value) =>
        value.parameterProperties(allowEmpty: allowEmpty),
    };
  }

  @_i3.override
  _i3.String toSimple({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool literal = false,
  }) {
    return switch (this) {
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(:final value) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(:final value) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
    };
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toForm(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
    _i3.Map<_i3.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    return switch (this) {
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(:final value) => value.toForm(
        paramName,
        explode: explode,
        allowEmpty: allowEmpty,
        useQueryComponent: useQueryComponent,
        allowReserved: allowReserved,
        fieldEncodings: fieldEncodings,
        textEncoding: textEncoding,
      ),
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(:final value) =>
        value.toForm(
          paramName,
          explode: explode,
          allowEmpty: allowEmpty,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
          fieldEncodings: fieldEncodings,
          textEncoding: textEncoding,
        ),
    };
  }

  @_i3.override
  _i3.String toLabel({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    return switch (this) {
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(:final value) => value.toLabel(
        explode: explode,
        allowEmpty: allowEmpty,
      ),
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(:final value) =>
        value.toLabel(explode: explode, allowEmpty: allowEmpty),
    };
  }

  @_i3.override
  _i3.String toMatrix(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    return switch (this) {
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(:final value) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(:final value) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
    };
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toDeepObject(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toDeepObject(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toPipeDelimited(
    _i3.String paramName, {
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toPipeDelimited(
      paramName,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toSpaceDelimited(
    _i3.String paramName, {
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toSpaceDelimited(
      paramName,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    return switch (this) {
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOf() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode ZonesIdOrNamePut200BodyZoneOneOfModel: variant contains complex type',
        ),
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode ZonesIdOrNamePut200BodyZoneOneOfModel: variant contains complex type',
        ),
    };
  }

  @_i3.override
  _i3.Object? toJson() {
    final (_i3.dynamic _$json, _i3.String? _$discriminator) = switch (this) {
      ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(:final value) => (
        value.toJson(),
        null,
      ),

      ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(:final value) => (
        value.toJson(),
        null,
      ),
    };
    if (_$discriminator != null && _$json is _i3.Map<_i3.String, _i3.Object?>) {
      final _$map = <_i3.String, _i3.Object?>{..._$json};
      _$map.putIfAbsent(r'mode', () => _$discriminator);
      return _$map;
    }
    return _$json;
  }
}

@_i2.immutable
class ZonesIdOrNamePut200BodyZoneOneOfModelAllOf
    extends ZonesIdOrNamePut200BodyZoneOneOfModel {
  const ZonesIdOrNamePut200BodyZoneOneOfModelAllOf(this.value);

  final _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNamePut200BodyZoneOneOfModelAllOf &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}

@_i2.immutable
class ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel
    extends ZonesIdOrNamePut200BodyZoneOneOfModel {
  const ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel(this.value);

  final _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2 value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNamePut200BodyZoneOneOfModelAllOfModel &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}
