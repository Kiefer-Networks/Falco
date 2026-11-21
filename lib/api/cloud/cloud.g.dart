// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Creates the pinned Cloud API dio with an auth interceptor. Tests
/// override this with a fake transport.

@ProviderFor(cloudDio)
final cloudDioProvider = CloudDioProvider._();

/// Creates the pinned Cloud API dio with an auth interceptor. Tests
/// override this with a fake transport.

final class CloudDioProvider
    extends
        $FunctionalProvider<
          Dio Function(Interceptor auth),
          Dio Function(Interceptor auth),
          Dio Function(Interceptor auth)
        >
    with $Provider<Dio Function(Interceptor auth)> {
  /// Creates the pinned Cloud API dio with an auth interceptor. Tests
  /// override this with a fake transport.
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

/// Creates the pinned Storage Box API dio with an auth interceptor. Tests
/// override this with a fake transport.

@ProviderFor(storageBoxDio)
final storageBoxDioProvider = StorageBoxDioProvider._();

/// Creates the pinned Storage Box API dio with an auth interceptor. Tests
/// override this with a fake transport.

final class StorageBoxDioProvider
    extends
        $FunctionalProvider<
          Dio Function(Interceptor auth),
          Dio Function(Interceptor auth),
          Dio Function(Interceptor auth)
        >
    with $Provider<Dio Function(Interceptor auth)> {
  /// Creates the pinned Storage Box API dio with an auth interceptor. Tests
  /// override this with a fake transport.
  StorageBoxDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageBoxDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageBoxDioHash();

  @$internal
  @override
  $ProviderElement<Dio Function(Interceptor auth)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Dio Function(Interceptor auth) create(Ref ref) {
    return storageBoxDio(ref);
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

String _$storageBoxDioHash() => r'91adcdafabc9f89cc9d58d6a140f5fb3384f5a31';

/// The Storage Box API of one project, with the project's Cloud token.

@ProviderFor(storageBoxApi)
final storageBoxApiProvider = StorageBoxApiFamily._();

/// The Storage Box API of one project, with the project's Cloud token.

final class StorageBoxApiProvider
    extends $FunctionalProvider<box.Server, box.Server, box.Server>
    with $Provider<box.Server> {
  /// The Storage Box API of one project, with the project's Cloud token.
  StorageBoxApiProvider._({
    required StorageBoxApiFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'storageBoxApiProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storageBoxApiHash();

  @override
  String toString() {
    return r'storageBoxApiProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<box.Server> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  box.Server create(Ref ref) {
    final argument = this.argument as String;
    return storageBoxApi(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(box.Server value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<box.Server>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StorageBoxApiProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storageBoxApiHash() => r'fa343af76e5af97ae50c0c72e020f45cb9d109da';

/// The Storage Box API of one project, with the project's Cloud token.

final class StorageBoxApiFamily extends $Family
    with $FunctionalFamilyOverride<box.Server, String> {
  StorageBoxApiFamily._()
    : super(
        retry: null,
        name: r'storageBoxApiProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The Storage Box API of one project, with the project's Cloud token.

  StorageBoxApiProvider call(String projectId) =>
      StorageBoxApiProvider._(argument: projectId, from: this);

  @override
  String toString() => r'storageBoxApiProvider';
}
