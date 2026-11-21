// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zones.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All zones of [scope], every project of "All projects" too (DNS-001,
/// BUG-006).

@ProviderFor(zones)
final zonesProvider = ZonesFamily._();

/// All zones of [scope], every project of "All projects" too (DNS-001,
/// BUG-006).

final class ZonesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Zone>>,
          List<Zone>,
          FutureOr<List<Zone>>
        >
    with $FutureModifier<List<Zone>>, $FutureProvider<List<Zone>> {
  /// All zones of [scope], every project of "All projects" too (DNS-001,
  /// BUG-006).
  ZonesProvider._({
    required ZonesFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'zonesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$zonesHash();

  @override
  String toString() {
    return r'zonesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Zone>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Zone>> create(Ref ref) {
    final argument = this.argument as Scope;
    return zones(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ZonesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$zonesHash() => r'2ba48271d239acb46104f58b0c93d4e3507760cb';

/// All zones of [scope], every project of "All projects" too (DNS-001,
/// BUG-006).

final class ZonesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Zone>>, Scope> {
  ZonesFamily._()
    : super(
        retry: null,
        name: r'zonesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All zones of [scope], every project of "All projects" too (DNS-001,
  /// BUG-006).

  ZonesProvider call(Scope scope) =>
      ZonesProvider._(argument: scope, from: this);

  @override
  String toString() => r'zonesProvider';
}

/// One zone (DNS-005).

@ProviderFor(zone)
final zoneProvider = ZoneFamily._();

/// One zone (DNS-005).

final class ZoneProvider
    extends $FunctionalProvider<AsyncValue<Zone>, Zone, FutureOr<Zone>>
    with $FutureModifier<Zone>, $FutureProvider<Zone> {
  /// One zone (DNS-005).
  ZoneProvider._({
    required ZoneFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'zoneProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$zoneHash();

  @override
  String toString() {
    return r'zoneProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Zone> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Zone> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return zone(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ZoneProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$zoneHash() => r'014cc2e8f180e00376ad018b2d05adf716e96e54';

/// One zone (DNS-005).

final class ZoneFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Zone>, (ProjectScope, int)> {
  ZoneFamily._()
    : super(
        retry: null,
        name: r'zoneProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One zone (DNS-005).

  ZoneProvider call(ProjectScope scope, int zoneId) =>
      ZoneProvider._(argument: (scope, zoneId), from: this);

  @override
  String toString() => r'zoneProvider';
}

/// The RRSets of a zone (DNS-006, DNS-023).

@ProviderFor(rrsets)
final rrsetsProvider = RrsetsFamily._();

/// The RRSets of a zone (DNS-006, DNS-023).

final class RrsetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RRSet>>,
          List<RRSet>,
          FutureOr<List<RRSet>>
        >
    with $FutureModifier<List<RRSet>>, $FutureProvider<List<RRSet>> {
  /// The RRSets of a zone (DNS-006, DNS-023).
  RrsetsProvider._({
    required RrsetsFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'rrsetsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rrsetsHash();

  @override
  String toString() {
    return r'rrsetsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<RRSet>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RRSet>> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return rrsets(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RrsetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rrsetsHash() => r'42904702887591ab16a5be30d1065a6b052cc639';

/// The RRSets of a zone (DNS-006, DNS-023).

final class RrsetsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RRSet>>, (ProjectScope, int)> {
  RrsetsFamily._()
    : super(
        retry: null,
        name: r'rrsetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The RRSets of a zone (DNS-006, DNS-023).

  RrsetsProvider call(ProjectScope scope, int zoneId) =>
      RrsetsProvider._(argument: (scope, zoneId), from: this);

  @override
  String toString() => r'rrsetsProvider';
}

/// One RRSet (DNS-027).

@ProviderFor(rrset)
final rrsetProvider = RrsetFamily._();

/// One RRSet (DNS-027).

final class RrsetProvider
    extends $FunctionalProvider<AsyncValue<RRSet>, RRSet, FutureOr<RRSet>>
    with $FutureModifier<RRSet>, $FutureProvider<RRSet> {
  /// One RRSet (DNS-027).
  RrsetProvider._({
    required RrsetFamily super.from,
    required (ProjectScope, int, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'rrsetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rrsetHash();

  @override
  String toString() {
    return r'rrsetProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RRSet> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<RRSet> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int, String, String);
    return rrset(ref, argument.$1, argument.$2, argument.$3, argument.$4);
  }

  @override
  bool operator ==(Object other) {
    return other is RrsetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rrsetHash() => r'bc731fe53c206da58075b5929f25ad08dfa92912';

/// One RRSet (DNS-027).

final class RrsetFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RRSet>,
          (ProjectScope, int, String, String)
        > {
  RrsetFamily._()
    : super(
        retry: null,
        name: r'rrsetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One RRSet (DNS-027).

  RrsetProvider call(
    ProjectScope scope,
    int zoneId,
    String name,
    String type,
  ) => RrsetProvider._(argument: (scope, zoneId, name, type), from: this);

  @override
  String toString() => r'rrsetProvider';
}
