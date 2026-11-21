// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Locations of the project.

@ProviderFor(locations)
final locationsProvider = LocationsFamily._();

/// Locations of the project.

final class LocationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Named>>,
          List<Named>,
          FutureOr<List<Named>>
        >
    with $FutureModifier<List<Named>>, $FutureProvider<List<Named>> {
  /// Locations of the project.
  LocationsProvider._({
    required LocationsFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'locationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$locationsHash();

  @override
  String toString() {
    return r'locationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Named>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Named>> create(Ref ref) {
    final argument = this.argument as ProjectScope;
    return locations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$locationsHash() => r'b28287dd55c4654134448b7714844dc485dc8ace';

/// Locations of the project.

final class LocationsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Named>>, ProjectScope> {
  LocationsFamily._()
    : super(
        retry: null,
        name: r'locationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Locations of the project.

  LocationsProvider call(ProjectScope scope) =>
      LocationsProvider._(argument: scope, from: this);

  @override
  String toString() => r'locationsProvider';
}

/// Server types with prices per location.

@ProviderFor(serverTypes)
final serverTypesProvider = ServerTypesFamily._();

/// Server types with prices per location.

final class ServerTypesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ServerType>>,
          List<ServerType>,
          FutureOr<List<ServerType>>
        >
    with $FutureModifier<List<ServerType>>, $FutureProvider<List<ServerType>> {
  /// Server types with prices per location.
  ServerTypesProvider._({
    required ServerTypesFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'serverTypesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serverTypesHash();

  @override
  String toString() {
    return r'serverTypesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ServerType>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ServerType>> create(Ref ref) {
    final argument = this.argument as ProjectScope;
    return serverTypes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServerTypesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serverTypesHash() => r'4b8e1df9e2095d22178ac3440768d2126f1523d6';

/// Server types with prices per location.

final class ServerTypesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ServerType>>, ProjectScope> {
  ServerTypesFamily._()
    : super(
        retry: null,
        name: r'serverTypesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Server types with prices per location.

  ServerTypesProvider call(ProjectScope scope) =>
      ServerTypesProvider._(argument: scope, from: this);

  @override
  String toString() => r'serverTypesProvider';
}

/// ISOs of the project (public and private), deprecated ones marked in
/// [Named.detail] by the caller (CMP-035).

@ProviderFor(isos)
final isosProvider = IsosFamily._();

/// ISOs of the project (public and private), deprecated ones marked in
/// [Named.detail] by the caller (CMP-035).

final class IsosProvider
    extends
        $FunctionalProvider<
          AsyncValue<
            List<({String? architecture, bool deprecated, Named iso})>
          >,
          List<({String? architecture, bool deprecated, Named iso})>,
          FutureOr<List<({String? architecture, bool deprecated, Named iso})>>
        >
    with
        $FutureModifier<
          List<({String? architecture, bool deprecated, Named iso})>
        >,
        $FutureProvider<
          List<({String? architecture, bool deprecated, Named iso})>
        > {
  /// ISOs of the project (public and private), deprecated ones marked in
  /// [Named.detail] by the caller (CMP-035).
  IsosProvider._({
    required IsosFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'isosProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isosHash();

  @override
  String toString() {
    return r'isosProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<
    List<({String? architecture, bool deprecated, Named iso})>
  >
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<({String? architecture, bool deprecated, Named iso})>> create(
    Ref ref,
  ) {
    final argument = this.argument as ProjectScope;
    return isos(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsosProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isosHash() => r'ad1dcc04e33f39558a674a95c276aece556ec95f';

/// ISOs of the project (public and private), deprecated ones marked in
/// [Named.detail] by the caller (CMP-035).

final class IsosFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<({String? architecture, bool deprecated, Named iso})>>,
          ProjectScope
        > {
  IsosFamily._()
    : super(
        retry: null,
        name: r'isosProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ISOs of the project (public and private), deprecated ones marked in
  /// [Named.detail] by the caller (CMP-035).

  IsosProvider call(ProjectScope scope) =>
      IsosProvider._(argument: scope, from: this);

  @override
  String toString() => r'isosProvider';
}

/// Private networks of the project (CMP-081).

@ProviderFor(networks)
final networksProvider = NetworksFamily._();

/// Private networks of the project (CMP-081).

final class NetworksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Named>>,
          List<Named>,
          FutureOr<List<Named>>
        >
    with $FutureModifier<List<Named>>, $FutureProvider<List<Named>> {
  /// Private networks of the project (CMP-081).
  NetworksProvider._({
    required NetworksFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'networksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$networksHash();

  @override
  String toString() {
    return r'networksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Named>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Named>> create(Ref ref) {
    final argument = this.argument as ProjectScope;
    return networks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NetworksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$networksHash() => r'a4674853708c6fa6a6c0b544d2ce3b01f00a60a3';

/// Private networks of the project (CMP-081).

final class NetworksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Named>>, ProjectScope> {
  NetworksFamily._()
    : super(
        retry: null,
        name: r'networksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Private networks of the project (CMP-081).

  NetworksProvider call(ProjectScope scope) =>
      NetworksProvider._(argument: scope, from: this);

  @override
  String toString() => r'networksProvider';
}

/// Firewalls of the project (CMP-082).

@ProviderFor(firewalls)
final firewallsProvider = FirewallsFamily._();

/// Firewalls of the project (CMP-082).

final class FirewallsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Named>>,
          List<Named>,
          FutureOr<List<Named>>
        >
    with $FutureModifier<List<Named>>, $FutureProvider<List<Named>> {
  /// Firewalls of the project (CMP-082).
  FirewallsProvider._({
    required FirewallsFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'firewallsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$firewallsHash();

  @override
  String toString() {
    return r'firewallsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Named>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Named>> create(Ref ref) {
    final argument = this.argument as ProjectScope;
    return firewalls(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FirewallsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$firewallsHash() => r'a16d7684c1607b4eea817f2817a92385e2f21a0e';

/// Firewalls of the project (CMP-082).

final class FirewallsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Named>>, ProjectScope> {
  FirewallsFamily._()
    : super(
        retry: null,
        name: r'firewallsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Firewalls of the project (CMP-082).

  FirewallsProvider call(ProjectScope scope) =>
      FirewallsProvider._(argument: scope, from: this);

  @override
  String toString() => r'firewallsProvider';
}

/// Currency and volume prices of the project (CMP-078).

@ProviderFor(pricing)
final pricingProvider = PricingFamily._();

/// Currency and volume prices of the project (CMP-078).

final class PricingProvider
    extends $FunctionalProvider<AsyncValue<Pricing>, Pricing, FutureOr<Pricing>>
    with $FutureModifier<Pricing>, $FutureProvider<Pricing> {
  /// Currency and volume prices of the project (CMP-078).
  PricingProvider._({
    required PricingFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'pricingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pricingHash();

  @override
  String toString() {
    return r'pricingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Pricing> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Pricing> create(Ref ref) {
    final argument = this.argument as ProjectScope;
    return pricing(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PricingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pricingHash() => r'4d7548e4bdeef5656ebeeec700d63c967aacda6d';

/// Currency and volume prices of the project (CMP-078).

final class PricingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Pricing>, ProjectScope> {
  PricingFamily._()
    : super(
        retry: null,
        name: r'pricingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Currency and volume prices of the project (CMP-078).

  PricingProvider call(ProjectScope scope) =>
      PricingProvider._(argument: scope, from: this);

  @override
  String toString() => r'pricingProvider';
}
