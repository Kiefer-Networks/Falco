// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Creates the pinned Robot dio with an auth interceptor. Tests override
/// this with a fake transport.

@ProviderFor(robotDio)
final robotDioProvider = RobotDioProvider._();

/// Creates the pinned Robot dio with an auth interceptor. Tests override
/// this with a fake transport.

final class RobotDioProvider
    extends
        $FunctionalProvider<
          Dio Function(Interceptor auth),
          Dio Function(Interceptor auth),
          Dio Function(Interceptor auth)
        >
    with $Provider<Dio Function(Interceptor auth)> {
  /// Creates the pinned Robot dio with an auth interceptor. Tests override
  /// this with a fake transport.
  RobotDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'robotDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$robotDioHash();

  @$internal
  @override
  $ProviderElement<Dio Function(Interceptor auth)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Dio Function(Interceptor auth) create(Ref ref) {
    return robotDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio Function(Interceptor auth) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio Function(Interceptor auth)>(
        value,
      ),
    );
  }
}

String _$robotDioHash() => r'd8d548a446536a9f2712807ceb83eeb4235e343f';

/// Creates the signing S3 dio for given credentials. Tests override this.

@ProviderFor(s3Dio)
final s3DioProvider = S3DioProvider._();

/// Creates the signing S3 dio for given credentials. Tests override this.

final class S3DioProvider
    extends
        $FunctionalProvider<
          Dio Function(S3Credentials c),
          Dio Function(S3Credentials c),
          Dio Function(S3Credentials c)
        >
    with $Provider<Dio Function(S3Credentials c)> {
  /// Creates the signing S3 dio for given credentials. Tests override this.
  S3DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r's3DioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$s3DioHash();

  @$internal
  @override
  $ProviderElement<Dio Function(S3Credentials c)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Dio Function(S3Credentials c) create(Ref ref) {
    return s3Dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio Function(S3Credentials c) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio Function(S3Credentials c)>(
        value,
      ),
    );
  }
}

String _$s3DioHash() => r'510676755d0c56404a02ce2b060c51ba64a7a63f';
