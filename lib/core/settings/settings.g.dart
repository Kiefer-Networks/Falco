// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loaded once in `main` before the first frame and overridden there, so
/// theme and language never flash. Tests override it as well.

@ProviderFor(preferences)
final preferencesProvider = PreferencesProvider._();

/// Loaded once in `main` before the first frame and overridden there, so
/// theme and language never flash. Tests override it as well.

final class PreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// Loaded once in `main` before the first frame and overridden there, so
  /// theme and language never flash. Tests override it as well.
  PreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return preferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$preferencesHash() => r'38ba5bf5e754bc64f20e53814c9ddff69a65fd95';

/// The app settings, stored in [SharedPreferences].

@ProviderFor(AppSettings)
final appSettingsProvider = AppSettingsProvider._();

/// The app settings, stored in [SharedPreferences].
final class AppSettingsProvider
    extends $NotifierProvider<AppSettings, Settings> {
  /// The app settings, stored in [SharedPreferences].
  AppSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsHash();

  @$internal
  @override
  AppSettings create() => AppSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Settings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Settings>(value),
    );
  }
}

String _$appSettingsHash() => r'b4798fcfe8e20f4a56c6f3b75cb5c59b1ec28b5a';

/// The app settings, stored in [SharedPreferences].

abstract class _$AppSettings extends $Notifier<Settings> {
  Settings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Settings, Settings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Settings, Settings>,
              Settings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
