// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Asks the platform for Face ID, Touch ID, fingerprint or the device PIN.
/// Returns false if the user cancelled. Overridden in tests.

@ProviderFor(authenticator)
final authenticatorProvider = AuthenticatorProvider._();

/// Asks the platform for Face ID, Touch ID, fingerprint or the device PIN.
/// Returns false if the user cancelled. Overridden in tests.

final class AuthenticatorProvider
    extends
        $FunctionalProvider<
          Future<bool> Function(String reason),
          Future<bool> Function(String reason),
          Future<bool> Function(String reason)
        >
    with $Provider<Future<bool> Function(String reason)> {
  /// Asks the platform for Face ID, Touch ID, fingerprint or the device PIN.
  /// Returns false if the user cancelled. Overridden in tests.
  AuthenticatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticatorHash();

  @$internal
  @override
  $ProviderElement<Future<bool> Function(String reason)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<bool> Function(String reason) create(Ref ref) {
    return authenticator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<bool> Function(String reason) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<bool> Function(String reason)>(value),
    );
  }
}

String _$authenticatorHash() => r'b34327d0c21ee8aca6e013e42fc8fee417baf0fc';

/// App lock: locked at start and after [backgroundTimeout] in background.

@ProviderFor(AppLock)
final appLockProvider = AppLockProvider._();

/// App lock: locked at start and after [backgroundTimeout] in background.
final class AppLockProvider extends $NotifierProvider<AppLock, bool> {
  /// App lock: locked at start and after [backgroundTimeout] in background.
  AppLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockHash();

  @$internal
  @override
  AppLock create() => AppLock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$appLockHash() => r'0b3fd908556b513005d91f45b3d8535399767d8a';

/// App lock: locked at start and after [backgroundTimeout] in background.

abstract class _$AppLock extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
