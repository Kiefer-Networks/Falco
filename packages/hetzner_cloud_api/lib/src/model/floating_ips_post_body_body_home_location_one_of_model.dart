// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Home [Location](#tag/locations) for the [Floating IP](#tag/floating-ips).
///
/// Either the ID or the name of the [Location](#tag/locations).
///
/// Only optional if no [Server](#tag/servers) is provided. Routing is optimized for this [Locations](#tag/locations).
///
@_i2.immutable
sealed class FloatingIpsPostBodyBodyHomeLocationOneOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const FloatingIpsPostBodyBodyHomeLocationOneOfModel();

  factory FloatingIpsPostBodyBodyHomeLocationOneOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    try {
      return FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(
        value.decodeSimpleInt(
          context: r'FloatingIpsPostBodyBodyHomeLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return FloatingIpsPostBodyBodyHomeLocationOneOfModelString(
        value.decodeSimpleString(
          context: r'FloatingIpsPostBodyBodyHomeLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid simple value for FloatingIpsPostBodyBodyHomeLocationOneOfModel',
    );
  }

  factory FloatingIpsPostBodyBodyHomeLocationOneOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    try {
      return FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(
        value.decodeFormInt(
          context: r'FloatingIpsPostBodyBodyHomeLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return FloatingIpsPostBodyBodyHomeLocationOneOfModelString(
        value.decodeFormString(
          context: r'FloatingIpsPostBodyBodyHomeLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid form value for FloatingIpsPostBodyBodyHomeLocationOneOfModel',
    );
  }

  factory FloatingIpsPostBodyBodyHomeLocationOneOfModel.fromJson(
    _i3.Object? json,
  ) {
    if (json is _i3.num) {
      return FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(
        json.decodeJsonInt(
          context: r'FloatingIpsPostBodyBodyHomeLocationOneOfModel',
        ),
      );
    }
    try {
      return FloatingIpsPostBodyBodyHomeLocationOneOfModelString(
        json.decodeJsonString(
          context: r'FloatingIpsPostBodyBodyHomeLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.JsonDecodingException(
      r'Invalid JSON for FloatingIpsPostBodyBodyHomeLocationOneOfModel',
    );
  }

  _i1.EncodingShape get currentEncodingShape {
    return switch (this) {
      FloatingIpsPostBodyBodyHomeLocationOneOfModelString() =>
        _i1.EncodingShape.simple,
      FloatingIpsPostBodyBodyHomeLocationOneOfModelInt() =>
        _i1.EncodingShape.simple,
    };
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FloatingIpsPostBodyBodyHomeLocationOneOfModel: only contains primitive types',
  );

  @_i3.override
  _i3.String toSimple({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool literal = false,
  }) {
    return switch (this) {
      FloatingIpsPostBodyBodyHomeLocationOneOfModelString(:final value) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
      FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(:final value) =>
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
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
    _i3.Map<_i3.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    return switch (this) {
      FloatingIpsPostBodyBodyHomeLocationOneOfModelString(:final value) =>
        value.toForm(
          paramName,
          explode: explode,
          allowEmpty: allowEmpty,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
          textEncoding: textEncoding,
        ),
      FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(:final value) =>
        value.toForm(
          paramName,
          explode: explode,
          allowEmpty: allowEmpty,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
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
      FloatingIpsPostBodyBodyHomeLocationOneOfModelString(:final value) =>
        value.toLabel(explode: explode, allowEmpty: allowEmpty),
      FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(:final value) =>
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
      FloatingIpsPostBodyBodyHomeLocationOneOfModelString(:final value) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
      FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(:final value) =>
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
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    return switch (this) {
      FloatingIpsPostBodyBodyHomeLocationOneOfModelString(:final value) =>
        value.uriEncode(
          allowEmpty: allowEmpty,
          textEncoding: textEncoding,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
        ),
      FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(:final value) =>
        value.uriEncode(
          allowEmpty: allowEmpty,
          textEncoding: textEncoding,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
        ),
    };
  }

  @_i3.override
  _i3.Object? toJson() {
    final (_i3.dynamic _$json, _i3.String? _$discriminator) = switch (this) {
      FloatingIpsPostBodyBodyHomeLocationOneOfModelString(:final value) => (
        value,
        null,
      ),

      FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(:final value) => (
        value,
        null,
      ),
    };
    return _$json;
  }
}

@_i2.immutable
class FloatingIpsPostBodyBodyHomeLocationOneOfModelString
    extends FloatingIpsPostBodyBodyHomeLocationOneOfModel {
  const FloatingIpsPostBodyBodyHomeLocationOneOfModelString(this.value);

  final _i3.String value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FloatingIpsPostBodyBodyHomeLocationOneOfModelString &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}

@_i2.immutable
class FloatingIpsPostBodyBodyHomeLocationOneOfModelInt
    extends FloatingIpsPostBodyBodyHomeLocationOneOfModel {
  const FloatingIpsPostBodyBodyHomeLocationOneOfModelInt(this.value);

  final _i3.int value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FloatingIpsPostBodyBodyHomeLocationOneOfModelInt &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}
