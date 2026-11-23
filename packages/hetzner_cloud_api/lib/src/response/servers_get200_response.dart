// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_get200_body_model.dart'
    as _i2;
import 'package:meta/meta.dart' as _i1;

@_i1.immutable
class ServersGet200Response {
  const ServersGet200Response({required this.body, this.xNext});

  final _i2.ServersGet200BodyModel body;

  final _i3.String? xNext;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersGet200Response &&
        other.body == this.body &&
        other.xNext == this.xNext;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.body, this.xNext]);
  }

  ServersGet200Response Function({
    _i2.ServersGet200BodyModel? body,
    _i3.String? xNext,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i2.ServersGet200BodyModel? body,
      _i3.Object? xNext = _sentinel,
    }) => ServersGet200Response(
      body: body ?? this.body,
      xNext: _i3.identical(xNext, _sentinel)
          ? this.xNext
          : (xNext as _i3.String?),
    );
  }
}
