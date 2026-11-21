// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsRebuildPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsRebuildPostBodyBodyModel({
    required this.image,
    this.userData,
  });

  factory ServersIdActionsRebuildPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'image', r'user_data'},
      listKeys: {},
      context: r'ServersIdActionsRebuildPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdActionsRebuildPostBodyBodyModel(
      image: _$values[r'image'].decodeSimpleString(
        context: r'ServersIdActionsRebuildPostBodyBodyModel.image',
      ),
      userData: _$values[r'user_data'].decodeSimpleNullableString(
        context: r'ServersIdActionsRebuildPostBodyBodyModel.user_data',
      ),
    );
  }

  factory ServersIdActionsRebuildPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsRebuildPostBodyBodyModel',
    );
    return ServersIdActionsRebuildPostBodyBodyModel(
      image: _$map[r'image'].decodeJsonString(
        context: r'ServersIdActionsRebuildPostBodyBodyModel.image',
      ),
      userData: _$map[r'user_data'].decodeJsonNullableString(
        context: r'ServersIdActionsRebuildPostBodyBodyModel.user_data',
      ),
    );
  }

  factory ServersIdActionsRebuildPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'image', r'user_data'},
      listKeys: {},
      context: r'ServersIdActionsRebuildPostBodyBodyModel',
    );
    return ServersIdActionsRebuildPostBodyBodyModel(
      image: _$values[r'image'].decodeFormString(
        context: r'ServersIdActionsRebuildPostBodyBodyModel.image',
      ),
      userData: _$values[r'user_data'].decodeFormNullableString(
        context: r'ServersIdActionsRebuildPostBodyBodyModel.user_data',
      ),
    );
  }

  /// ID or name of Image to rebuilt from.
  ///
  /// **Example**:
  /// ```
  /// ubuntu-24.04
  /// ```
  final _i3.String image;

  /// Cloud-Init user data to use during Server rebuild. This field is limited to 32KiB. If not specified, the Server's previous user_data value will be re-used (if any was set).
  ///
  /// **Example**:
  /// ```
  /// #cloud-config
  /// runcmd:
  /// - [touch, /root/cloud-init-worked]
  ///
  /// ```
  final _i3.String? userData;

  @_i3.override
  _i3.Object? toJson() => {
    r'image': this.image,
    if (this.userData != null) r'user_data': this.userData,
  };

  ServersIdActionsRebuildPostBodyBodyModel Function({
    _i3.String? image,
    _i3.String? userData,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.String? image, _i3.Object? userData = _sentinel}) =>
        ServersIdActionsRebuildPostBodyBodyModel(
          image: image ?? this.image,
          userData: _i3.identical(userData, _sentinel)
              ? this.userData
              : (userData as _i3.String?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdActionsRebuildPostBodyBodyModel &&
        other.image == this.image &&
        other.userData == this.userData;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.image, this.userData]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'image'] = _i1.PropertyValue.scalar(this.image);
    if (this.userData != null) {
      _$result[r'user_data'] = _i1.PropertyValue.scalar(this.userData!);
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
      r'Cannot uriEncode ServersIdActionsRebuildPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
