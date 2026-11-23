// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i3;
import 'dart:core' as _i1;

import 'package:dio/dio.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

abstract base class DioOperation<T> {
  DioOperation(this.baseUrl, this.clientAccessor);

  final _i1.String baseUrl;

  final _i2.Dio Function() clientAccessor;

  _i3.Future<_i4.TonikResult<T, _i2.Response<_i1.Object?>>> execute({
    _i4.TonikCancellation? cancellation,
    required DioOperationRequest Function() prepare,
    required T Function(_i2.Response<_i1.List<_i1.int>>) decode,
  }) {
    late final _DioPreparedRequest prepared;
    try {
      final request = prepare();
      final baseUri = _i1.Uri.parse(this.baseUrl);
      final pathResult = request.path;
      final newPath = baseUri.path.endsWith('/')
          ? '${baseUri.path.substring(0, baseUri.path.length - 1)}/${pathResult.join('/')}'
          : '${baseUri.path}/${pathResult.join('/')}';
      final uri = baseUri.replace(path: newPath, query: request.query);
      prepared = _DioPreparedRequest(uri, request.data, request.options);
    } on _i1.Object catch (exception, stackTrace) {
      return _i3.Future.value(
        _i4.TonikError<T, _i2.Response<_i1.Object?>>(
          exception,
          stackTrace: stackTrace,
          type: _i4.TonikErrorType.encoding,
          response: null,
        ),
      );
    }

    return _complete(
      dispatched: _dispatchSync<T>(
        prepared: prepared,
        cancellation: cancellation,
      ),
      decode: decode,
    );
  }

  _i3.Future<_i4.TonikResult<T, _i2.Response<_i1.Object?>>> executeAsync({
    _i4.TonikCancellation? cancellation,
    required _i3.Future<DioOperationRequest> Function() prepare,
    required T Function(_i2.Response<_i1.List<_i1.int>>) decode,
  }) async {
    late final _DioPreparedRequest prepared;
    try {
      final request = await prepare();
      final baseUri = _i1.Uri.parse(this.baseUrl);
      final pathResult = request.path;
      final newPath = baseUri.path.endsWith('/')
          ? '${baseUri.path.substring(0, baseUri.path.length - 1)}/${pathResult.join('/')}'
          : '${baseUri.path}/${pathResult.join('/')}';
      final uri = baseUri.replace(path: newPath, query: request.query);
      prepared = _DioPreparedRequest(uri, request.data, request.options);
    } on _i1.Object catch (exception, stackTrace) {
      return _i4.TonikError<T, _i2.Response<_i1.Object?>>(
        exception,
        stackTrace: stackTrace,
        type: _i4.TonikErrorType.encoding,
        response: null,
      );
    }

    return _complete(
      dispatched: _dispatch<T>(prepared: prepared, cancellation: cancellation),
      decode: decode,
    );
  }

  _i3.Future<_i4.TonikResult<void, _i2.Response<_i1.Object?>>> executeVoid({
    _i4.TonikCancellation? cancellation,
    required DioOperationRequest Function() prepare,
    required void Function(_i2.Response<_i1.List<_i1.int>>) decode,
  }) {
    late final _DioPreparedRequest prepared;
    try {
      final request = prepare();
      final baseUri = _i1.Uri.parse(this.baseUrl);
      final pathResult = request.path;
      final newPath = baseUri.path.endsWith('/')
          ? '${baseUri.path.substring(0, baseUri.path.length - 1)}/${pathResult.join('/')}'
          : '${baseUri.path}/${pathResult.join('/')}';
      final uri = baseUri.replace(path: newPath, query: request.query);
      prepared = _DioPreparedRequest(uri, request.data, request.options);
    } on _i1.Object catch (exception, stackTrace) {
      return _i3.Future.value(
        _i4.TonikError<void, _i2.Response<_i1.Object?>>(
          exception,
          stackTrace: stackTrace,
          type: _i4.TonikErrorType.encoding,
          response: null,
        ),
      );
    }

    return _completeVoid(
      dispatched: _dispatchSync<void>(
        prepared: prepared,
        cancellation: cancellation,
      ),
      decode: decode,
    );
  }

  _i3.Future<_i4.TonikResult<void, _i2.Response<_i1.Object?>>>
  executeVoidAsync({
    _i4.TonikCancellation? cancellation,
    required _i3.Future<DioOperationRequest> Function() prepare,
    required void Function(_i2.Response<_i1.List<_i1.int>>) decode,
  }) async {
    late final _DioPreparedRequest prepared;
    try {
      final request = await prepare();
      final baseUri = _i1.Uri.parse(this.baseUrl);
      final pathResult = request.path;
      final newPath = baseUri.path.endsWith('/')
          ? '${baseUri.path.substring(0, baseUri.path.length - 1)}/${pathResult.join('/')}'
          : '${baseUri.path}/${pathResult.join('/')}';
      final uri = baseUri.replace(path: newPath, query: request.query);
      prepared = _DioPreparedRequest(uri, request.data, request.options);
    } on _i1.Object catch (exception, stackTrace) {
      return _i4.TonikError<void, _i2.Response<_i1.Object?>>(
        exception,
        stackTrace: stackTrace,
        type: _i4.TonikErrorType.encoding,
        response: null,
      );
    }

    return _completeVoid(
      dispatched: _dispatch<void>(
        prepared: prepared,
        cancellation: cancellation,
      ),
      decode: decode,
    );
  }

  _i3.Future<_i4.TonikResult<T, _i2.Response<_i1.Object?>>> _complete({
    required _i3.Future<_DioDispatchResult<T>> dispatched,
    required T Function(_i2.Response<_i1.List<_i1.int>>) decode,
  }) async {
    final result = await dispatched;
    final error = result.error;
    if (error != null) return error;
    final response = result.response!;
    final T value;
    try {
      value = decode(response);
    } on _i1.Object catch (exception, stackTrace) {
      return _i4.TonikError<T, _i2.Response<_i1.Object?>>(
        exception,
        stackTrace: stackTrace,
        type: _i4.TonikErrorType.decoding,
        response: response,
      );
    }
    return _i4.TonikSuccess<T, _i2.Response<_i1.Object?>>(value, response);
  }

  _i3.Future<_i4.TonikResult<void, _i2.Response<_i1.Object?>>> _completeVoid({
    required _i3.Future<_DioDispatchResult<void>> dispatched,
    required void Function(_i2.Response<_i1.List<_i1.int>>) decode,
  }) async {
    final result = await dispatched;
    final error = result.error;
    if (error != null) return error;
    final response = result.response!;
    try {
      decode(response);
    } on _i1.Object catch (exception, stackTrace) {
      return _i4.TonikError<void, _i2.Response<_i1.Object?>>(
        exception,
        stackTrace: stackTrace,
        type: _i4.TonikErrorType.decoding,
        response: response,
      );
    }
    return _i4.TonikSuccess<void, _i2.Response<_i1.Object?>>(null, response);
  }

  _i3.Future<_DioDispatchResult<V>> _dispatchSync<V>({
    required _DioPreparedRequest prepared,
    required _i4.TonikCancellation? cancellation,
  }) {
    _i2.CancelToken? cancelToken;
    if (cancellation != null) {
      cancelToken = _i2.CancelToken();
      if (cancellation.isCancelled) {
        cancelToken.cancel(cancellation.reason);
        return _i3.Future.value(
          _DioDispatchResult<V>(
            _i4.TonikError<V, _i2.Response<_i1.Object?>>(
              cancelToken.cancelError!,
              stackTrace: cancelToken.cancelError!.stackTrace,
              type: _i4.TonikErrorType.cancelled,
              response: null,
            ),
            null,
          ),
        );
      }
      _i3.unawaited(
        cancellation.whenCancelled.then((_) {
          cancelToken!.cancel(cancellation.reason);
        }),
      );
    }
    late final _i2.Dio client;
    try {
      client = this.clientAccessor();
    } on _i1.Object catch (exception, stackTrace) {
      return _i3.Future.value(
        _DioDispatchResult<V>(
          _i4.TonikError<V, _i2.Response<_i1.Object?>>(
            exception,
            stackTrace: stackTrace,
            type: _i4.TonikErrorType.other,
            response: null,
          ),
          null,
        ),
      );
    }
    try {
      final response = client.requestUri<_i1.List<_i1.int>>(
        prepared.uri,
        data: prepared.data,
        options: prepared.options,
        cancelToken: cancelToken,
      );
      return response.then<_DioDispatchResult<V>>(
        (value) => _DioDispatchResult<V>(null, value),
        onError: (exception, stackTrace) {
          if (exception is _i2.DioException) {
            final type = exception.type == _i2.DioExceptionType.cancel
                ? _i4.TonikErrorType.cancelled
                : _i4.TonikErrorType.network;
            return _DioDispatchResult<V>(
              _i4.TonikError<V, _i2.Response<_i1.Object?>>(
                exception,
                stackTrace: stackTrace,
                type: type,
                response: exception.response,
              ),
              null,
            );
          }
          return _DioDispatchResult<V>(
            _i4.TonikError<V, _i2.Response<_i1.Object?>>(
              exception,
              stackTrace: stackTrace,
              type: _i4.TonikErrorType.network,
              response: null,
            ),
            null,
          );
        },
      );
    } on _i2.DioException catch (exception, stackTrace) {
      final type = exception.type == _i2.DioExceptionType.cancel
          ? _i4.TonikErrorType.cancelled
          : _i4.TonikErrorType.network;
      return _i3.Future.value(
        _DioDispatchResult<V>(
          _i4.TonikError<V, _i2.Response<_i1.Object?>>(
            exception,
            stackTrace: stackTrace,
            type: type,
            response: exception.response,
          ),
          null,
        ),
      );
    } on _i1.Object catch (exception, stackTrace) {
      return _i3.Future.value(
        _DioDispatchResult<V>(
          _i4.TonikError<V, _i2.Response<_i1.Object?>>(
            exception,
            stackTrace: stackTrace,
            type: _i4.TonikErrorType.network,
            response: null,
          ),
          null,
        ),
      );
    }
  }

  _i3.Future<_DioDispatchResult<V>> _dispatch<V>({
    required _DioPreparedRequest prepared,
    required _i4.TonikCancellation? cancellation,
  }) async {
    _i2.CancelToken? cancelToken;
    if (cancellation != null) {
      cancelToken = _i2.CancelToken();
      if (cancellation.isCancelled) {
        cancelToken.cancel(cancellation.reason);
        return _DioDispatchResult<V>(
          _i4.TonikError<V, _i2.Response<_i1.Object?>>(
            cancelToken.cancelError!,
            stackTrace: cancelToken.cancelError!.stackTrace,
            type: _i4.TonikErrorType.cancelled,
            response: null,
          ),
          null,
        );
      }
      _i3.unawaited(
        cancellation.whenCancelled.then((_) {
          cancelToken!.cancel(cancellation.reason);
        }),
      );
    }

    final _i2.Dio client;
    try {
      client = this.clientAccessor();
    } on _i1.Object catch (exception, stackTrace) {
      return _DioDispatchResult<V>(
        _i4.TonikError<V, _i2.Response<_i1.Object?>>(
          exception,
          stackTrace: stackTrace,
          type: _i4.TonikErrorType.other,
          response: null,
        ),
        null,
      );
    }

    final _i2.Response<_i1.List<_i1.int>> response;
    try {
      response = await client.requestUri<_i1.List<_i1.int>>(
        prepared.uri,
        data: prepared.data,
        options: prepared.options,
        cancelToken: cancelToken,
      );
    } on _i2.DioException catch (exception, stackTrace) {
      if (exception.type == _i2.DioExceptionType.cancel) {
        return _DioDispatchResult<V>(
          _i4.TonikError<V, _i2.Response<_i1.Object?>>(
            exception,
            stackTrace: stackTrace,
            type: _i4.TonikErrorType.cancelled,
            response: exception.response,
          ),
          null,
        );
      }
      return _DioDispatchResult<V>(
        _i4.TonikError<V, _i2.Response<_i1.Object?>>(
          exception,
          stackTrace: stackTrace,
          type: _i4.TonikErrorType.network,
          response: exception.response,
        ),
        null,
      );
    } on _i1.Object catch (exception, stackTrace) {
      return _DioDispatchResult<V>(
        _i4.TonikError<V, _i2.Response<_i1.Object?>>(
          exception,
          stackTrace: stackTrace,
          type: _i4.TonikErrorType.network,
          response: null,
        ),
        null,
      );
    }
    return _DioDispatchResult<V>(null, response);
  }
}

final class DioOperationRequest {
  DioOperationRequest({
    required this.path,
    required this.query,
    required this.data,
    required this.options,
  });

  final _i1.List<_i1.String> path;

  final _i1.String? query;

  final _i1.Object? data;

  final _i2.Options options;
}

class _DioPreparedRequest {
  _DioPreparedRequest(this.uri, this.data, this.options);

  final _i1.Uri uri;

  final _i1.Object? data;

  final _i2.Options options;
}

class _DioDispatchResult<T> {
  _DioDispatchResult(this.error, this.response);

  final _i4.TonikError<T, _i2.Response<_i1.Object?>>? error;

  final _i2.Response<_i1.List<_i1.int>>? response;
}
