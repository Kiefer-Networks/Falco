// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Creates the pinned Cloud API dio with [auth]. Tests override this with
/// a fake transport.

@ProviderFor(cloudDio)
final cloudDioProvider = CloudDioProvider._();

/// Creates the pinned Cloud API dio with [auth]. Tests override this with
/// a fake transport.

final class CloudDioProvider
    extends
        $FunctionalProvider<
          Dio Function(Interceptor auth),
          Dio Function(Interceptor auth),
          Dio Function(Interceptor auth)
        >
    with $Provider<Dio Function(Interceptor auth)> {
  /// Creates the pinned Cloud API dio with [auth]. Tests override this with
  /// a fake transport.
  CloudDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cloudDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cloudDioHash();

  @$internal
  @override
  $ProviderElement<Dio Function(Interceptor auth)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Dio Function(Interceptor auth) create(Ref ref) {
    return cloudDio(ref);
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

String _$cloudDioHash() => r'0299e451b390f0124bed518c6a4d1886481624cc';

/// The Cloud API of one project. The token is read from the SecretStore
/// per request.

@ProviderFor(cloudApi)
final cloudApiProvider = CloudApiFamily._();

/// The Cloud API of one project. The token is read from the SecretStore
/// per request.

final class CloudApiProvider
    extends $FunctionalProvider<cloud.Server, cloud.Server, cloud.Server>
    with $Provider<cloud.Server> {
  /// The Cloud API of one project. The token is read from the SecretStore
  /// per request.
  CloudApiProvider._({
    required CloudApiFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cloudApiProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cloudApiHash();

  @override
  String toString() {
    return r'cloudApiProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<cloud.Server> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  cloud.Server create(Ref ref) {
    final argument = this.argument as String;
    return cloudApi(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(cloud.Server value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<cloud.Server>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CloudApiProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cloudApiHash() => r'e877b07988b068398ca411b5ddd4e5d0100604b5';

/// The Cloud API of one project. The token is read from the SecretStore
/// per request.

final class CloudApiFamily extends $Family
    with $FunctionalFamilyOverride<cloud.Server, String> {
  CloudApiFamily._()
    : super(
        retry: null,
        name: r'cloudApiProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The Cloud API of one project. The token is read from the SecretStore
  /// per request.

  CloudApiProvider call(String projectId) =>
      CloudApiProvider._(argument: projectId, from: this);

  @override
  String toString() => r'cloudApiProvider';
}
