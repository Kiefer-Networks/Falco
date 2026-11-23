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

String _$placementGroupsHash() => r'5deed683cfbe622d360aca40639d077d6931833e';

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

/// One placement group with its servers (CMP-069). Read as raw JSON: a
/// type unknown to the spec decodes, but cannot be encoded again.

@ProviderFor(placementGroup)
final placementGroupProvider = PlacementGroupFamily._();

/// One placement group with its servers (CMP-069). Read as raw JSON: a
/// type unknown to the spec decodes, but cannot be encoded again.

final class PlacementGroupProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlacementGroup>,
          PlacementGroup,
          FutureOr<PlacementGroup>
        >
    with $FutureModifier<PlacementGroup>, $FutureProvider<PlacementGroup> {
  /// One placement group with its servers (CMP-069). Read as raw JSON: a
  /// type unknown to the spec decodes, but cannot be encoded again.
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

String _$placementGroupHash() => r'869e66485dc0695d3a5d78e5ba9cb6d7d13bce31';

/// One placement group with its servers (CMP-069). Read as raw JSON: a
/// type unknown to the spec decodes, but cannot be encoded again.

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

  /// One placement group with its servers (CMP-069). Read as raw JSON: a
  /// type unknown to the spec decodes, but cannot be encoded again.

  PlacementGroupProvider call(ProjectScope scope, int groupId) =>
      PlacementGroupProvider._(argument: (scope, groupId), from: this);

  @override
  String toString() => r'placementGroupProvider';
}
