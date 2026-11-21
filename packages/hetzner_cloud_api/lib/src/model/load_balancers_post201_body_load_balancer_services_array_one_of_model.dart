// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_services_array_one_of_all_of_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_services_array_one_of_all_of_model2.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_services_array_one_of_all_of_model3.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
sealed class LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel();

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    try {
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel.fromSimple(
          value,
          explode: explode,
          isHeader: isHeader,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        _i5.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel2.fromSimple(
          value,
          explode: explode,
          isHeader: isHeader,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        _i6.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel3.fromSimple(
          value,
          explode: explode,
          isHeader: isHeader,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid simple value for LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel',
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    try {
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel.fromForm(
          value,
          explode: explode,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        _i5.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel2.fromForm(
          value,
          explode: explode,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    try {
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        _i6.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel3.fromForm(
          value,
          explode: explode,
        ),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid form value for LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel',
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel.fromJson(
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
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel.fromJson(
          json,
        ),
      );
    } on _i3.Object catch (_) {}
    try {
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        _i5.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel2.fromJson(
          json,
        ),
      );
    } on _i3.Object catch (_) {}
    try {
      return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        _i6.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel3.fromJson(
          json,
        ),
      );
    } on _i3.Object catch (_) {}
    throw _i1.JsonDecodingException(
      r'Invalid JSON for LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel',
    );
  }

  _i1.EncodingShape get currentEncodingShape {
    return switch (this) {
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.currentEncodingShape,
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.currentEncodingShape,
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
        :final value,
      ) =>
        value.currentEncodingShape,
    };
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    return switch (this) {
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.parameterProperties(allowEmpty: allowEmpty),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.parameterProperties(allowEmpty: allowEmpty),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
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
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
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
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
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
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
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
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
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
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.toLabel(explode: explode, allowEmpty: allowEmpty),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.toLabel(explode: explode, allowEmpty: allowEmpty),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
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
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
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
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel: variant contains complex type',
        ),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel: variant contains complex type',
        ),
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel: variant contains complex type',
        ),
    };
  }

  @_i3.override
  _i3.Object? toJson() {
    final (_i3.dynamic _$json, _i3.String? _$discriminator) = switch (this) {
      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
        :final value,
      ) =>
        (value.toJson(), null),

      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
        :final value,
      ) =>
        (value.toJson(), null),

      LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
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
class LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf
    extends LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel {
  const LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf(
    this.value,
  );

  final _i6.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel3
  value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOf &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}

@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel
    extends LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel {
  const LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel(
    this.value,
  );

  final _i5.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel2
  value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}

@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2
    extends LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel {
  const LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2(
    this.value,
  );

  final _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel
  value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModelAllOfModel2 &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => this.value.hashCode;
}
