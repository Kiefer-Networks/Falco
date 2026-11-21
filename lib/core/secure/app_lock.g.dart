// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Asks the platform for Face ID, Touch ID, fingerprint or the device PIN
/// (local_auth falls back to the PIN, SET-013, BUG-023). Returns false if
/// the user cancelled and null when the device has no screen lock at all.
/// With a hardware bound vault, opening it is the check, so the user sees
/// one prompt (SET-015). Overridden in tests.

@ProviderFor(authenticator)
final authenticatorProvider = AuthenticatorProvider._();

/// Asks the platform for Face ID, Touch ID, fingerprint or the device PIN
/// (local_auth falls back to the PIN, SET-013, BUG-023). Returns false if
/// the user cancelled and null when the device has no screen lock at all.
/// With a hardware bound vault, opening it is the check, so the user sees
/// one prompt (SET-015). Overridden in tests.

final class AuthenticatorProvider
    extends
        $FunctionalProvider<
          Future<bool?> Function(String reason),
          Future<bool?> Function(String reason),
          Future<bool?> Function(String reason)
        >
    with $Provider<Future<bool?> Function(String reason)> {
  /// Asks the platform for Face ID, Touch ID, fingerprint or the device PIN
  /// (local_auth falls back to the PIN, SET-013, BUG-023). Returns false if
  /// the user cancelled and null when the device has no screen lock at all.
  /// With a hardware bound vault, opening it is the check, so the user sees
  /// one prompt (SET-015). Overridden in tests.
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
  $ProviderElement<Future<bool?> Function(String reason)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<bool?> Function(String reason) create(Ref ref) {
    return authenticator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<bool?> Function(String reason) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<bool?> Function(String reason)>(value),
    );
  }
}

String _$authenticatorHash() => r'dabdb5356210605ca20e0681f418819743f9afef';

/// App lock: locked at start and after the auto lock time in background,
/// both only while the lock is on in the settings (SET-007, SET-010).
/// Before the first account there is nothing to protect: [unlock] then
/// opens without asking, so a first start never prompts (SET-023). The
/// first secret goes into the vault with the platform's own check.

@ProviderFor(AppLock)
final appLockProvider = AppLockProvider._();

/// App lock: locked at start and after the auto lock time in background,
/// both only while the lock is on in the settings (SET-007, SET-010).
/// Before the first account there is nothing to protect: [unlock] then
/// opens without asking, so a first start never prompts (SET-023). The
/// first secret goes into the vault with the platform's own check.
final class AppLockProvider extends $NotifierProvider<AppLock, AppLockState> {
  /// App lock: locked at start and after the auto lock time in background,
  /// both only while the lock is on in the settings (SET-007, SET-010).
  /// Before the first account there is nothing to protect: [unlock] then
  /// opens without asking, so a first start never prompts (SET-023). The
  /// first secret goes into the vault with the platform's own check.
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
  Override overrideWithValue(AppLockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLockState>(value),
    );
  }
}

String _$appLockHash() => r'a6463e627fc62a2c65c6d36b20bc0f42a0bd5c30';

/// App lock: locked at start and after the auto lock time in background,
/// both only while the lock is on in the settings (SET-007, SET-010).
/// Before the first account there is nothing to protect: [unlock] then
/// opens without asking, so a first start never prompts (SET-023). The
/// first secret goes into the vault with the platform's own check.

abstract class _$AppLock extends $Notifier<AppLockState> {
  AppLockState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppLockState, AppLockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLockState, AppLockState>,
              AppLockState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
