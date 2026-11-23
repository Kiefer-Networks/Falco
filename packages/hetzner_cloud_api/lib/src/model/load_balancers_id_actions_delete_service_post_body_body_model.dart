// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsDeleteServicePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsDeleteServicePostBodyBodyModel({
    required this.listenPort,
  });

  factory LoadBalancersIdActionsDeleteServicePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'listen_port'},
      listKeys: {},
      context: r'LoadBalancersIdActionsDeleteServicePostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdActionsDeleteServicePostBodyBodyModel(
      listenPort: _$values[r'listen_port'].decodeSimpleInt(
        context:
            r'LoadBalancersIdActionsDeleteServicePostBodyBodyModel.listen_port',
      ),
    );
  }

  factory LoadBalancersIdActionsDeleteServicePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsDeleteServicePostBodyBodyModel',
    );
    return LoadBalancersIdActionsDeleteServicePostBodyBodyModel(
      listenPort: _$map[r'listen_port'].decodeJsonInt(
        context:
            r'LoadBalancersIdActionsDeleteServicePostBodyBodyModel.listen_port',
      ),
    );
  }

  factory LoadBalancersIdActionsDeleteServicePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'listen_port'},
      listKeys: {},
      context: r'LoadBalancersIdActionsDeleteServicePostBodyBodyModel',
    );
    return LoadBalancersIdActionsDeleteServicePostBodyBodyModel(
      listenPort: _$values[r'listen_port'].decodeFormInt(
        context:
            r'LoadBalancersIdActionsDeleteServicePostBodyBodyModel.listen_port',
      ),
    );
  }

  /// The listen port of the service you want to delete.
  ///
  /// **Example**:
  /// ```json
  /// 443
  /// ```
  final _i3.int listenPort;

  @_i3.override
  _i3.Object? toJson() => {r'listen_port': this.listenPort};

  LoadBalancersIdActionsDeleteServicePostBodyBodyModel Function({
    _i3.int? listenPort,
  })
  get copyWith {
    return ({_i3.int? listenPort}) =>
        LoadBalancersIdActionsDeleteServicePostBodyBodyModel(
          listenPort: listenPort ?? this.listenPort,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsDeleteServicePostBodyBodyModel &&
        other.listenPort == this.listenPort;
  }

  @_i3.override
  _i3.int get hashCode => this.listenPort.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'listen_port'] = _i1.PropertyValue.scalar(
      this.listenPort.toString(),
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
      r'Cannot uriEncode LoadBalancersIdActionsDeleteServicePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
