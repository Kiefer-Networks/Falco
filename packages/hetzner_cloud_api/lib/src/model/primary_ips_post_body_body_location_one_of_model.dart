// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// [Location](#tag/locations) ID or name the [Primary IP](#tag/primary-ips) will be bound to.
///
/// Omit if `assignee_id`/`assignee_type` or `datacenter` are provided.
///
@_i2.immutable
sealed class PrimaryIpsPostBodyBodyLocationOneOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const PrimaryIpsPostBodyBodyLocationOneOfModel();

  factory PrimaryIpsPostBodyBodyLocationOneOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    try {
      return PrimaryIpsPostBodyBodyLocationOneOfModelInt(
        value.decodeSimpleInt(
          context: r'PrimaryIpsPostBodyBodyLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return PrimaryIpsPostBodyBodyLocationOneOfModelString(
        value.decodeSimpleString(
          context: r'PrimaryIpsPostBodyBodyLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid simple value for PrimaryIpsPostBodyBodyLocationOneOfModel',
    );
  }

  factory PrimaryIpsPostBodyBodyLocationOneOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    try {
      return PrimaryIpsPostBodyBodyLocationOneOfModelInt(
        value.decodeFormInt(
          context: r'PrimaryIpsPostBodyBodyLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return PrimaryIpsPostBodyBodyLocationOneOfModelString(
        value.decodeFormString(
          context: r'PrimaryIpsPostBodyBodyLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid form value for PrimaryIpsPostBodyBodyLocationOneOfModel',
    );
  }

  factory PrimaryIpsPostBodyBodyLocationOneOfModel.fromJson(_i3.Object? json) {
    if (json is _i3.num) {
      return PrimaryIpsPostBodyBodyLocationOneOfModelInt(
        json.decodeJsonInt(
          context: r'PrimaryIpsPostBodyBodyLocationOneOfModel',
        ),
      );
    }
    try {
      return PrimaryIpsPostBodyBodyLocationOneOfModelString(
        json.decodeJsonString(
          context: r'PrimaryIpsPostBodyBodyLocationOneOfModel',
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.JsonDecodingException(
      r'Invalid JSON for PrimaryIpsPostBodyBodyLocationOneOfModel',
    );
  }

  _i1.EncodingShape get currentEncodingShape {
    return switch (this) {
      PrimaryIpsPostBodyBodyLocationOneOfModelString() =>
        _i1.EncodingShape.simple,
      PrimaryIpsPostBodyBodyLocationOneOfModelInt() => _i1.EncodingShape.simple,
    };
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PrimaryIpsPostBodyBodyLocationOneOfModel: only contains primitive types',
  );

  @_i3.override
  _i3.String toSimple({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool literal = false,
  }) {
    return switch (this) {
      PrimaryIpsPostBodyBodyLocationOneOfModelString(:final value) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
      PrimaryIpsPostBodyBodyLocationOneOfModelInt(:final value) =>
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
      PrimaryIpsPostBodyBodyLocationOneOfModelString(:final value) =>
        value.toForm(
          paramName,
          explode: explode,
          allowEmpty: allowEmpty,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
          textEncoding: textEncoding,
        ),
      PrimaryIpsPostBodyBodyLocationOneOfModelInt(:final value) => value.toForm(
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
      PrimaryIpsPostBodyBodyLocationOneOfModelString(:final value) =>
        value.toLabel(explode: explode, allowEmpty: allowEmpty),
      PrimaryIpsPostBodyBodyLocationOneOfModelInt(:final value) =>
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
      PrimaryIpsPostBodyBodyLocationOneOfModelString(:final value) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
      PrimaryIpsPostBodyBodyLocationOneOfModelInt(:final value) =>
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
      PrimaryIpsPostBodyBodyLocationOneOfModelString(:final value) =>
        value.uriEncode(
          allowEmpty: allowEmpty,
          textEncoding: textEncoding,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
        ),
      PrimaryIpsPostBodyBodyLocationOneOfModelInt(:final value) =>
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
      PrimaryIpsPostBodyBodyLocationOneOfModelString(:final value) => (
        value,
        null,
      ),

      PrimaryIpsPostBodyBodyLocationOneOfModelInt(:final value) => (
        value,
        null,
      ),
    };
    return _$json;
  }
}

@_i2.immutable
class PrimaryIpsPostBodyBodyLocationOneOfModelString
    extends PrimaryIpsPostBodyBodyLocationOneOfModel {
  const PrimaryIpsPostBodyBodyLocationOneOfModelString(this.value);

  final _i3.String value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PrimaryIpsPostBodyBodyLocationOneOfModelString &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}

@_i2.immutable
class PrimaryIpsPostBodyBodyLocationOneOfModelInt
    extends PrimaryIpsPostBodyBodyLocationOneOfModel {
  const PrimaryIpsPostBodyBodyLocationOneOfModelInt(this.value);

  final _i3.int value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PrimaryIpsPostBodyBodyLocationOneOfModelInt &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}
