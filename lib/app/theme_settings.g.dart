// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Surface variant and accent of the app. Not persisted yet (Phase 3).

@ProviderFor(ThemeSettings)
final themeSettingsProvider = ThemeSettingsProvider._();

/// Surface variant and accent of the app. Not persisted yet (Phase 3).
final class ThemeSettingsProvider
    extends
        $NotifierProvider<
          ThemeSettings,
          ({AccentPreset accent, FalcoVariant variant})
        > {
  /// Surface variant and accent of the app. Not persisted yet (Phase 3).
  ThemeSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeSettingsHash();

  @$internal
  @override
  ThemeSettings create() => ThemeSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ({AccentPreset accent, FalcoVariant variant}) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<({AccentPreset accent, FalcoVariant variant})>(
            value,
          ),
    );
  }
}

String _$themeSettingsHash() => r'e871b104d38280207e1a32617e1f4dd95ef88ed5';

/// Surface variant and accent of the app. Not persisted yet (Phase 3).

abstract class _$ThemeSettings
    extends $Notifier<({AccentPreset accent, FalcoVariant variant})> {
  ({AccentPreset accent, FalcoVariant variant}) build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              ({AccentPreset accent, FalcoVariant variant}),
              ({AccentPreset accent, FalcoVariant variant})
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({AccentPreset accent, FalcoVariant variant}),
                ({AccentPreset accent, FalcoVariant variant})
              >,
              ({AccentPreset accent, FalcoVariant variant}),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
