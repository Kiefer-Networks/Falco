// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// [Label Selector](#description/label-selector) the [Firewall](#tag/firewalls) is applied to.
///
/// Only set for `type` `label_selector`, otherwise `null`.
///
@_i2.immutable
class FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel({
    required this.selector,
  });

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'selector'},
      listKeys: {},
      context: r'FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel(
      selector: _$values[r'selector'].decodeSimpleString(
        context: r'FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel.selector',
      ),
    );
  }

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel',
    );
    return FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel(
      selector: _$map[r'selector'].decodeJsonString(
        context: r'FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel.selector',
      ),
    );
  }

  factory FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'selector'},
      listKeys: {},
      context: r'FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel',
    );
    return FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel(
      selector: _$values[r'selector'].decodeFormString(
        context: r'FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel.selector',
      ),
    );
  }

  /// The selector.
  ///
  /// **Example**:
  /// ```
  /// env=prod
  /// ```
  final _i3.String selector;

  @_i3.override
  _i3.Object? toJson() => {r'selector': this.selector};

  FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel
  Function({_i3.String? selector})
  get copyWith {
    return ({_i3.String? selector}) =>
        FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel(
          selector: selector ?? this.selector,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel &&
        other.selector == this.selector;
  }

  @_i3.override
  _i3.int get hashCode => this.selector.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'selector'] = _i1.PropertyValue.scalar(this.selector);
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
      r'Cannot uriEncode FirewallsIdActionsApplyToResourcesPostBodyBodyApplyToArrayLabelSelectorModel: complex types cannot be URI-encoded',
    );
  }
}
