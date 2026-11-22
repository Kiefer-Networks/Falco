// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firewalls.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All firewalls of [scope] (NET-001).

@ProviderFor(firewalls)
final firewallsProvider = FirewallsFamily._();

/// All firewalls of [scope] (NET-001).

final class FirewallsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Firewall>>,
          List<Firewall>,
          FutureOr<List<Firewall>>
        >
    with $FutureModifier<List<Firewall>>, $FutureProvider<List<Firewall>> {
  /// All firewalls of [scope] (NET-001).
  FirewallsProvider._({
    required FirewallsFamily super.from,
    required Scope super.argument,
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
  $FutureProviderElement<List<Firewall>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Firewall>> create(Ref ref) {
    final argument = this.argument as Scope;
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

String _$firewallsHash() => r'8ee650deeb43e38325028e5be6c87dc3398fde04';

/// All firewalls of [scope] (NET-001).

final class FirewallsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Firewall>>, Scope> {
  FirewallsFamily._()
    : super(
        retry: null,
        name: r'firewallsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All firewalls of [scope] (NET-001).

  FirewallsProvider call(Scope scope) =>
      FirewallsProvider._(argument: scope, from: this);

  @override
  String toString() => r'firewallsProvider';
}

/// One firewall (NET-004, NET-013).

@ProviderFor(firewall)
final firewallProvider = FirewallFamily._();

/// One firewall (NET-004, NET-013).

final class FirewallProvider
    extends
        $FunctionalProvider<AsyncValue<Firewall>, Firewall, FutureOr<Firewall>>
    with $FutureModifier<Firewall>, $FutureProvider<Firewall> {
  /// One firewall (NET-004, NET-013).
  FirewallProvider._({
    required FirewallFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'firewallProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$firewallHash();

  @override
  String toString() {
    return r'firewallProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Firewall> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Firewall> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return firewall(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is FirewallProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$firewallHash() => r'6e8d06ddc1c8bc9cf86ed35b4ac4308ce710fd29';

/// One firewall (NET-004, NET-013).

final class FirewallFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Firewall>, (ProjectScope, int)> {
  FirewallFamily._()
    : super(
        retry: null,
        name: r'firewallProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One firewall (NET-004, NET-013).

  FirewallProvider call(ProjectScope scope, int firewallId) =>
      FirewallProvider._(argument: (scope, firewallId), from: this);

  @override
  String toString() => r'firewallProvider';
}
