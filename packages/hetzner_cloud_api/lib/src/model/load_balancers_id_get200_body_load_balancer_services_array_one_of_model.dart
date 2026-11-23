// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_services_array_one_of_all_of_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_services_array_one_of_all_of_model2.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_services_array_one_of_all_of_model3.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
sealed class LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel();

  factory LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        _i4.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel.fromSimple(
          value,
          explode: explode,
          isHeader: isHeader,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        _i5.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel2.fromSimple(
          value,
          explode: explode,
          isHeader: isHeader,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        _i6.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel3.fromSimple(
          value,
          explode: explode,
          isHeader: isHeader,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid simple value for LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel',
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        _i4.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel.fromForm(
          value,
          explode: explode,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        _i5.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel2.fromForm(
          value,
          explode: explode,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        _i6.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel3.fromForm(
          value,
          explode: explode,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid form value for LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel',
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel.fromJson(
    _i3.Object? json,
  ) {
    final _$discriminator = json is _i3.Map<_i3.String, _i3.Object?>
        ? json[r'protocol']
        : null;
    final _$result = switch (_$discriminator) {
      _ => null,
    };
    if (_$result != null) {
      return _$result;
    }
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        _i4.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel.fromJson(
          json,
        ),
      );
    } on _i3.Object catch (_) {}
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        _i5.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel2.fromJson(
          json,
        ),
      );
    } on _i3.Object catch (_) {}
    try {
      return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        _i6.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel3.fromJson(
          json,
        ),
      );
    } on _i3.Object catch (_) {}
    throw _i1.JsonDecodingException(
      r'Invalid JSON for LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel',
    );
  }

  _i1.EncodingShape get currentEncodingShape {
    return switch (this) {
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.currentEncodingShape,
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.currentEncodingShape,
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        :final value,
      ) =>
        value.currentEncodingShape,
    };
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    return switch (this) {
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.parameterProperties(allowEmpty: allowEmpty),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.parameterProperties(allowEmpty: allowEmpty),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        :final value,
      ) =>
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
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        :final value,
      ) =>
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
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
    _i3.Map<_i3.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    return switch (this) {
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.toForm(
          paramName,
          explode: explode,
          allowEmpty: allowEmpty,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
          fieldEncodings: fieldEncodings,
          textEncoding: textEncoding,
        ),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.toForm(
          paramName,
          explode: explode,
          allowEmpty: allowEmpty,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
          fieldEncodings: fieldEncodings,
          textEncoding: textEncoding,
        ),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        :final value,
      ) =>
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
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.toLabel(explode: explode, allowEmpty: allowEmpty),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.toLabel(explode: explode, allowEmpty: allowEmpty),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        :final value,
      ) =>
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
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        :final value,
      ) =>
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
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    return switch (this) {
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel: variant contains complex type',
        ),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel: variant contains complex type',
        ),
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel: variant contains complex type',
        ),
    };
  }

  @_i3.override
  _i3.Object? toJson() {
    final (_i3.dynamic _$json, _i3.String? _$discriminator) = switch (this) {
      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        (value.toJson(), null),

      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        (value.toJson(), null),

      LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        :final value,
      ) =>
        (value.toJson(), null),
    };
    if (_$discriminator != null && _$json is _i3.Map<_i3.String, _i3.Object?>) {
      final _$map = <_i3.String, _i3.Object?>{..._$json};
      _$map.putIfAbsent(r'protocol', () => _$discriminator);
      return _$map;
    }
    return _$json;
  }
}

@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf
    extends LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel {
  const LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf(
    this.value,
  );

  final _i6.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel3
  value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOf &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}

@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel
    extends LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel {
  const LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
    this.value,
  );

  final _i5.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel2
  value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}

@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2
    extends LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel {
  const LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
    this.value,
  );

  final _i4.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel
  value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModelAllOfModel2 &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}
