// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Describes if, when and how the resource is deprecated. If this field is
/// set to `null` the resource is not deprecated. If a value is set, it is
/// considered deprecated.
///
@_i2.immutable
class $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel({
    required this.unavailableAfter,
    required this.announced,
  });

  factory $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'unavailable_after', r'announced'},
      listKeys: {},
      context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel(
      unavailableAfter: _$values[r'unavailable_after'].decodeSimpleDateTime(
        context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.unavailable_after',
      ),
      announced: _$values[r'announced'].decodeSimpleDateTime(
        context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.announced',
      ),
    );
  }

  factory $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel',
    );
    return $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel(
      unavailableAfter: _$map[r'unavailable_after'].decodeJsonDateTime(
        context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.unavailable_after',
      ),
      announced: _$map[r'announced'].decodeJsonDateTime(
        context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.announced',
      ),
    );
  }

  factory $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'unavailable_after', r'announced'},
      listKeys: {},
      context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel',
    );
    return $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel(
      unavailableAfter: _$values[r'unavailable_after'].decodeFormDateTime(
        context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.unavailable_after',
      ),
      announced: _$values[r'announced'].decodeFormDateTime(
        context: r'$RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel.announced',
      ),
    );
  }

  /// Date of the deprecated resource removal.
  ///
  /// Once this date is reached, the resource will not be returned
  /// by resource type "list" endpoint, and the resource can not be
  /// used to create new resources. For example, if this is an
  /// image, you can not create new servers with this image after
  /// the mentioned date.
  ///
  ///
  /// **Example**:
  /// ```
  /// 2023-09-01T00:00:00Z
  /// ```
  final _i3.DateTime unavailableAfter;

  /// Date of the deprecation announcement.
  ///
  ///
  /// **Example**:
  /// ```
  /// 2023-06-01T00:00:00Z
  /// ```
  final _i3.DateTime announced;

  @_i3.override
  _i3.Object? toJson() => {
    r'unavailable_after': this.unavailableAfter.toTimeZonedIso8601String(),
    r'announced': this.announced.toTimeZonedIso8601String(),
  };

  $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel
  Function({_i3.DateTime? unavailableAfter, _i3.DateTime? announced})
  get copyWith {
    return ({_i3.DateTime? unavailableAfter, _i3.DateTime? announced}) =>
        $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel(
          unavailableAfter: unavailableAfter ?? this.unavailableAfter,
          announced: announced ?? this.announced,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel &&
        other.unavailableAfter == this.unavailableAfter &&
        other.announced == this.announced;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.unavailableAfter, this.announced]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'unavailable_after'] = _i1.PropertyValue.scalar(
      this.unavailableAfter.toTimeZonedIso8601String(),
    );
    _$result[r'announced'] = _i1.PropertyValue.scalar(
      this.announced.toTimeZonedIso8601String(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel: complex types cannot be URI-encoded',
    );
  }
}

typedef LoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel =
    $RawLoadBalancersPost201BodyLoadBalancerLoadBalancerTypeDeprecationModel?;
