// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'networks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All networks of [scope] (NET-039).

@ProviderFor(networks)
final networksProvider = NetworksFamily._();

/// All networks of [scope] (NET-039).

final class NetworksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CloudNetwork>>,
          List<CloudNetwork>,
          FutureOr<List<CloudNetwork>>
        >
    with
        $FutureModifier<List<CloudNetwork>>,
        $FutureProvider<List<CloudNetwork>> {
  /// All networks of [scope] (NET-039).
  NetworksProvider._({
    required NetworksFamily super.from,
    required Scope super.argument,
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
  $FutureProviderElement<List<CloudNetwork>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CloudNetwork>> create(Ref ref) {
    final argument = this.argument as Scope;
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

String _$networksHash() => r'a27287bff7a58168adfe223a639148d982499ced';

/// All networks of [scope] (NET-039).

final class NetworksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CloudNetwork>>, Scope> {
  NetworksFamily._()
    : super(
        retry: null,
        name: r'networksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All networks of [scope] (NET-039).

  NetworksProvider call(Scope scope) =>
      NetworksProvider._(argument: scope, from: this);

  @override
  String toString() => r'networksProvider';
}

/// One network (NET-043).

@ProviderFor(network)
final networkProvider = NetworkFamily._();

/// One network (NET-043).

final class NetworkProvider
    extends
        $FunctionalProvider<
          AsyncValue<CloudNetwork>,
          CloudNetwork,
          FutureOr<CloudNetwork>
        >
    with $FutureModifier<CloudNetwork>, $FutureProvider<CloudNetwork> {
  /// One network (NET-043).
  NetworkProvider._({
    required NetworkFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'networkProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$networkHash();

  @override
  String toString() {
    return r'networkProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CloudNetwork> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CloudNetwork> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return network(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is NetworkProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$networkHash() => r'854b784b928eed793f60d31b9bb2145febc8acec';

/// One network (NET-043).

final class NetworkFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<CloudNetwork>, (ProjectScope, int)> {
  NetworkFamily._()
    : super(
        retry: null,
        name: r'networkProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One network (NET-043).

  NetworkProvider call(ProjectScope scope, int networkId) =>
      NetworkProvider._(argument: (scope, networkId), from: this);

  @override
  String toString() => r'networkProvider';
}

/// Servers and load balancers of a network (NET-092).

@ProviderFor(networkMembers)
final networkMembersProvider = NetworkMembersFamily._();

/// Servers and load balancers of a network (NET-092).

final class NetworkMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NetworkMember>>,
          List<NetworkMember>,
          FutureOr<List<NetworkMember>>
        >
    with
        $FutureModifier<List<NetworkMember>>,
        $FutureProvider<List<NetworkMember>> {
  /// Servers and load balancers of a network (NET-092).
  NetworkMembersProvider._({
    required NetworkMembersFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'networkMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$networkMembersHash();

  @override
  String toString() {
    return r'networkMembersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<NetworkMember>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NetworkMember>> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return networkMembers(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is NetworkMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$networkMembersHash() => r'770600edf92d4f71c0983e22f66bca15d2e91d3a';

/// Servers and load balancers of a network (NET-092).

final class NetworkMembersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<NetworkMember>>,
          (ProjectScope, int)
        > {
  NetworkMembersFamily._()
    : super(
        retry: null,
        name: r'networkMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Servers and load balancers of a network (NET-092).

  NetworkMembersProvider call(ProjectScope scope, int networkId) =>
      NetworkMembersProvider._(argument: (scope, networkId), from: this);

  @override
  String toString() => r'networkMembersProvider';
}
