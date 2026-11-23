// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i1;

import 'package:dio/dio.dart' as _i3;
import 'package:tonik_util/tonik_util.dart' as _i2;

class _DioClientAdapter {
  _DioClientAdapter(this.baseUrl, this.serverConfig);

  final _i1.String baseUrl;

  final _i2.ServerConfig<_i3.Dio> serverConfig;

  _i3.Dio? _$dio;

  _i1.bool _$ownsDio = false;

  _i1.bool _$isClosed = false;

  final _i1.StateError _$closedError = _i1.StateError(
    'Cannot access Dio after the server has been closed.',
  );

  _i3.Dio get dio {
    if (this._$isClosed) {
      throw this._$closedError;
    }

    final cachedDio = this._$dio;
    if (cachedDio != null) {
      return cachedDio;
    }

    final client = this.serverConfig.client;
    final clientFactory = this.serverConfig.clientFactory;
    final resolvedDio = client ?? clientFactory?.call() ?? _i3.Dio();
    this._$ownsDio = client == null;
    if (this._$ownsDio) {
      resolvedDio.options.baseUrl = this.baseUrl;
    }
    return this._$dio = resolvedDio;
  }

  void close() {
    if (this._$isClosed) {
      return;
    }

    this._$isClosed = true;
    if (this._$ownsDio) {
      this._$dio?.close();
    }
  }
}

sealed class Server {
  Server({required this.baseUrl, required this.serverConfig})
    : _$dioAdapter = _DioClientAdapter(baseUrl, serverConfig);

  final _i1.String baseUrl;

  final _i2.ServerConfig<_i3.Dio> serverConfig;

  final _DioClientAdapter _$dioAdapter;

  _i3.Dio get dio => this._$dioAdapter.dio;

  void close() => this._$dioAdapter.close();
}

/// Server - https://api.hetzner.cloud/v1
class ApiServer extends Server {
  ApiServer({super.serverConfig = const _i2.ServerConfig<_i3.Dio>()})
    : super(baseUrl: r'https://api.hetzner.cloud/v1');
}

/// Custom server with user-defined base URL
class CustomServer extends Server {
  CustomServer({
    required super.baseUrl,
    super.serverConfig = const _i2.ServerConfig<_i3.Dio>(),
  });
}
