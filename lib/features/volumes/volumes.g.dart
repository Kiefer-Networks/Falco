// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volumes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All volumes of [scope] (CMP-050).

@ProviderFor(volumes)
final volumesProvider = VolumesFamily._();

/// All volumes of [scope] (CMP-050).

final class VolumesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Volume>>,
          List<Volume>,
          FutureOr<List<Volume>>
        >
    with $FutureModifier<List<Volume>>, $FutureProvider<List<Volume>> {
  /// All volumes of [scope] (CMP-050).
  VolumesProvider._({
    required VolumesFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'volumesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$volumesHash();

  @override
  String toString() {
    return r'volumesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Volume>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Volume>> create(Ref ref) {
    final argument = this.argument as Scope;
    return volumes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VolumesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$volumesHash() => r'6b0cc96a401b247a22691edfcd1c85ba61c71649';

/// All volumes of [scope] (CMP-050).

final class VolumesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Volume>>, Scope> {
  VolumesFamily._()
    : super(
        retry: null,
        name: r'volumesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All volumes of [scope] (CMP-050).

  VolumesProvider call(Scope scope) =>
      VolumesProvider._(argument: scope, from: this);

  @override
  String toString() => r'volumesProvider';
}

/// One volume (CMP-057, CMP-058).

@ProviderFor(volume)
final volumeProvider = VolumeFamily._();

/// One volume (CMP-057, CMP-058).

final class VolumeProvider
    extends $FunctionalProvider<AsyncValue<Volume>, Volume, FutureOr<Volume>>
    with $FutureModifier<Volume>, $FutureProvider<Volume> {
  /// One volume (CMP-057, CMP-058).
  VolumeProvider._({
    required VolumeFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'volumeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$volumeHash();

  @override
  String toString() {
    return r'volumeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Volume> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Volume> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return volume(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is VolumeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$volumeHash() => r'eece544177f320d0aab6e98f0a79a40535ac1907';

/// One volume (CMP-057, CMP-058).

final class VolumeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Volume>, (ProjectScope, int)> {
  VolumeFamily._()
    : super(
        retry: null,
        name: r'volumeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One volume (CMP-057, CMP-058).

  VolumeProvider call(ProjectScope scope, int volumeId) =>
      VolumeProvider._(argument: (scope, volumeId), from: this);

  @override
  String toString() => r'volumeProvider';
}
