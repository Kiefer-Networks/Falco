// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FloatingIpsIdActionsAssignPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FloatingIpsIdActionsAssignPostBodyBodyModel({required this.server});

  factory FloatingIpsIdActionsAssignPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'server'},
      listKeys: {},
      context: r'FloatingIpsIdActionsAssignPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return FloatingIpsIdActionsAssignPostBodyBodyModel(
      server: _$values[r'server'].decodeSimpleNullableInt(
        context: r'FloatingIpsIdActionsAssignPostBodyBodyModel.server',
      ),
    );
  }

  factory FloatingIpsIdActionsAssignPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FloatingIpsIdActionsAssignPostBodyBodyModel',
    );
    return FloatingIpsIdActionsAssignPostBodyBodyModel(
      server: _$map[r'server'].decodeJsonNullableInt(
        context: r'FloatingIpsIdActionsAssignPostBodyBodyModel.server',
      ),
    );
  }

  factory FloatingIpsIdActionsAssignPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'server'},
      listKeys: {},
      context: r'FloatingIpsIdActionsAssignPostBodyBodyModel',
    );
    return FloatingIpsIdActionsAssignPostBodyBodyModel(
      server: _$values[r'server'].decodeFormNullableInt(
        context: r'FloatingIpsIdActionsAssignPostBodyBodyModel.server',
      ),
    );
  }

  /// [Server](#tag/servers) the [Floating IP](#tag/floating-ips) is assigned to.
  ///
  /// `null` if not assigned.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int? server;

  @_i3.override
  _i3.Object? toJson() => {r'server': this.server};

  FloatingIpsIdActionsAssignPostBodyBodyModel Function({_i3.int? server})
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? server = _sentinel}) =>
        FloatingIpsIdActionsAssignPostBodyBodyModel(
          server: _i3.identical(server, _sentinel)
              ? this.server
              : (server as _i3.int?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FloatingIpsIdActionsAssignPostBodyBodyModel &&
        other.server == this.server;
  }

  @_i3.override
  _i3.int get hashCode => this.server.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.server != null) {
      _$result[r'server'] = _i1.PropertyValue.scalar(this.server!.toString());
    }
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
      r'Cannot uriEncode FloatingIpsIdActionsAssignPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
