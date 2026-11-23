// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsAttachIsoPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsAttachIsoPostBodyBodyModel({required this.iso});

  factory ServersIdActionsAttachIsoPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'iso'},
      listKeys: {},
      context: r'ServersIdActionsAttachIsoPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdActionsAttachIsoPostBodyBodyModel(
      iso: _$values[r'iso'].decodeSimpleString(
        context: r'ServersIdActionsAttachIsoPostBodyBodyModel.iso',
      ),
    );
  }

  factory ServersIdActionsAttachIsoPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsAttachIsoPostBodyBodyModel',
    );
    return ServersIdActionsAttachIsoPostBodyBodyModel(
      iso: _$map[r'iso'].decodeJsonString(
        context: r'ServersIdActionsAttachIsoPostBodyBodyModel.iso',
      ),
    );
  }

  factory ServersIdActionsAttachIsoPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'iso'},
      listKeys: {},
      context: r'ServersIdActionsAttachIsoPostBodyBodyModel',
    );
    return ServersIdActionsAttachIsoPostBodyBodyModel(
      iso: _$values[r'iso'].decodeFormString(
        context: r'ServersIdActionsAttachIsoPostBodyBodyModel.iso',
      ),
    );
  }

  /// ID or name of ISO to attach to the Server as listed in GET `/isos`.
  ///
  /// **Example**:
  /// ```
  /// FreeBSD-11.0-RELEASE-amd64-dvd1
  /// ```
  final _i3.String iso;

  @_i3.override
  _i3.Object? toJson() => {r'iso': this.iso};

  ServersIdActionsAttachIsoPostBodyBodyModel Function({_i3.String? iso})
  get copyWith {
    return ({_i3.String? iso}) =>
        ServersIdActionsAttachIsoPostBodyBodyModel(iso: iso ?? this.iso);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdActionsAttachIsoPostBodyBodyModel &&
        other.iso == this.iso;
  }

  @_i3.override
  _i3.int get hashCode => this.iso.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'iso'] = _i1.PropertyValue.scalar(this.iso);
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
      r'Cannot uriEncode ServersIdActionsAttachIsoPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
