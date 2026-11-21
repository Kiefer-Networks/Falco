// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement_groups.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All placement groups of [scope] (CMP-065).

@ProviderFor(placementGroups)
final placementGroupsProvider = PlacementGroupsFamily._();

/// All placement groups of [scope] (CMP-065).

final class PlacementGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlacementGroup>>,
          List<PlacementGroup>,
          FutureOr<List<PlacementGroup>>
        >
    with
        $FutureModifier<List<PlacementGroup>>,
        $FutureProvider<List<PlacementGroup>> {
  /// All placement groups of [scope] (CMP-065).
  PlacementGroupsProvider._({
    required PlacementGroupsFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'placementGroupsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$placementGroupsHash();

  @override
  String toString() {
    return r'placementGroupsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PlacementGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PlacementGroup>> create(Ref ref) {
    final argument = this.argument as Scope;
    return placementGroups(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlacementGroupsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$placementGroupsHash() => r'a3ef256a9529ec3d4a0d2da9c4ade5f0682971f0';

/// All placement groups of [scope] (CMP-065).

final class PlacementGroupsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PlacementGroup>>, Scope> {
  PlacementGroupsFamily._()
    : super(
        retry: null,
        name: r'placementGroupsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All placement groups of [scope] (CMP-065).

  PlacementGroupsProvider call(Scope scope) =>
      PlacementGroupsProvider._(argument: scope, from: this);

  @override
  String toString() => r'placementGroupsProvider';
}

/// One placement group with its servers (CMP-069).

@ProviderFor(placementGroup)
final placementGroupProvider = PlacementGroupFamily._();

/// One placement group with its servers (CMP-069).

final class PlacementGroupProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlacementGroup>,
          PlacementGroup,
          FutureOr<PlacementGroup>
        >
    with $FutureModifier<PlacementGroup>, $FutureProvider<PlacementGroup> {
  /// One placement group with its servers (CMP-069).
  PlacementGroupProvider._({
    required PlacementGroupFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'placementGroupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$placementGroupHash();

  @override
  String toString() {
    return r'placementGroupProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PlacementGroup> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlacementGroup> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return placementGroup(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PlacementGroupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$placementGroupHash() => r'a8c1d63b0ef04d576de2246f9aefbbcba6e6b050';

/// One placement group with its servers (CMP-069).

final class PlacementGroupFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PlacementGroup>,
          (ProjectScope, int)
        > {
  PlacementGroupFamily._()
    : super(
        retry: null,
        name: r'placementGroupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One placement group with its servers (CMP-069).

  PlacementGroupProvider call(ProjectScope scope, int groupId) =>
      PlacementGroupProvider._(argument: (scope, groupId), from: this);

  @override
  String toString() => r'placementGroupProvider';
}
