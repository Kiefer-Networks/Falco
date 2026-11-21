// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/volumes_id_put200_body_volume_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class VolumesIdPut200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const VolumesIdPut200BodyModel({required this.volume});

  factory VolumesIdPut200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for VolumesIdPut200BodyModel: contains complex types',
    );
  }

  factory VolumesIdPut200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'VolumesIdPut200BodyModel');
    return VolumesIdPut200BodyModel(
      volume: _i4.VolumesIdPut200BodyVolumeModel.fromJson(_$map[r'volume']),
    );
  }

  factory VolumesIdPut200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for VolumesIdPut200BodyModel: contains complex types',
    );
  }

  final _i4.VolumesIdPut200BodyVolumeModel volume;

  @_i3.override
  _i3.Object? toJson() => {r'volume': this.volume.toJson()};

  VolumesIdPut200BodyModel Function({
    _i4.VolumesIdPut200BodyVolumeModel? volume,
  })
  get copyWith {
    return ({_i4.VolumesIdPut200BodyVolumeModel? volume}) =>
        VolumesIdPut200BodyModel(volume: volume ?? this.volume);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VolumesIdPut200BodyModel && other.volume == this.volume;
  }

  @_i3.override
  _i3.int get hashCode => this.volume.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for VolumesIdPut200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode VolumesIdPut200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
