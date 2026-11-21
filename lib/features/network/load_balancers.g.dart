// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_balancers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All load balancers of [scope] (NET-056).

@ProviderFor(loadBalancers)
final loadBalancersProvider = LoadBalancersFamily._();

/// All load balancers of [scope] (NET-056).

final class LoadBalancersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LoadBalancer>>,
          List<LoadBalancer>,
          FutureOr<List<LoadBalancer>>
        >
    with
        $FutureModifier<List<LoadBalancer>>,
        $FutureProvider<List<LoadBalancer>> {
  /// All load balancers of [scope] (NET-056).
  LoadBalancersProvider._({
    required LoadBalancersFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'loadBalancersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadBalancersHash();

  @override
  String toString() {
    return r'loadBalancersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LoadBalancer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LoadBalancer>> create(Ref ref) {
    final argument = this.argument as Scope;
    return loadBalancers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadBalancersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadBalancersHash() => r'4d37471092db11f55560c0b801b11d4fb9428a62';

/// All load balancers of [scope] (NET-056).

final class LoadBalancersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LoadBalancer>>, Scope> {
  LoadBalancersFamily._()
    : super(
        retry: null,
        name: r'loadBalancersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All load balancers of [scope] (NET-056).

  LoadBalancersProvider call(Scope scope) =>
      LoadBalancersProvider._(argument: scope, from: this);

  @override
  String toString() => r'loadBalancersProvider';
}

/// One load balancer (NET-057, NET-058).

@ProviderFor(loadBalancer)
final loadBalancerProvider = LoadBalancerFamily._();

/// One load balancer (NET-057, NET-058).

final class LoadBalancerProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoadBalancer>,
          LoadBalancer,
          FutureOr<LoadBalancer>
        >
    with $FutureModifier<LoadBalancer>, $FutureProvider<LoadBalancer> {
  /// One load balancer (NET-057, NET-058).
  LoadBalancerProvider._({
    required LoadBalancerFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'loadBalancerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadBalancerHash();

  @override
  String toString() {
    return r'loadBalancerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<LoadBalancer> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoadBalancer> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return loadBalancer(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadBalancerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadBalancerHash() => r'0a3f3599840583c313bf48a5efcec63b5d9ee624';

/// One load balancer (NET-057, NET-058).

final class LoadBalancerFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<LoadBalancer>, (ProjectScope, int)> {
  LoadBalancerFamily._()
    : super(
        retry: null,
        name: r'loadBalancerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One load balancer (NET-057, NET-058).

  LoadBalancerProvider call(ProjectScope scope, int lbId) =>
      LoadBalancerProvider._(argument: (scope, lbId), from: this);

  @override
  String toString() => r'loadBalancerProvider';
}

/// Load balancer types offered (NET-069, NET-091).

@ProviderFor(loadBalancerTypes)
final loadBalancerTypesProvider = LoadBalancerTypesFamily._();

/// Load balancer types offered (NET-069, NET-091).

final class LoadBalancerTypesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LbType>>,
          List<LbType>,
          FutureOr<List<LbType>>
        >
    with $FutureModifier<List<LbType>>, $FutureProvider<List<LbType>> {
  /// Load balancer types offered (NET-069, NET-091).
  LoadBalancerTypesProvider._({
    required LoadBalancerTypesFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'loadBalancerTypesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadBalancerTypesHash();

  @override
  String toString() {
    return r'loadBalancerTypesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LbType>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LbType>> create(Ref ref) {
    final argument = this.argument as ProjectScope;
    return loadBalancerTypes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadBalancerTypesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadBalancerTypesHash() => r'57b42e3059692cf1c6d0b05530986f57a6411ef1';

/// Load balancer types offered (NET-069, NET-091).

final class LoadBalancerTypesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LbType>>, ProjectScope> {
  LoadBalancerTypesFamily._()
    : super(
        retry: null,
        name: r'loadBalancerTypesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Load balancer types offered (NET-069, NET-091).

  LoadBalancerTypesProvider call(ProjectScope scope) =>
      LoadBalancerTypesProvider._(argument: scope, from: this);

  @override
  String toString() => r'loadBalancerTypesProvider';
}

/// Samples of [metric] over [period], one list per series key.

@ProviderFor(loadBalancerMetrics)
final loadBalancerMetricsProvider = LoadBalancerMetricsFamily._();

/// Samples of [metric] over [period], one list per series key.

final class LoadBalancerMetricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<List<(DateTime, double)>>>,
          List<List<(DateTime, double)>>,
          FutureOr<List<List<(DateTime, double)>>>
        >
    with
        $FutureModifier<List<List<(DateTime, double)>>>,
        $FutureProvider<List<List<(DateTime, double)>>> {
  /// Samples of [metric] over [period], one list per series key.
  LoadBalancerMetricsProvider._({
    required LoadBalancerMetricsFamily super.from,
    required (ProjectScope, int, LbMetric, MetricPeriod) super.argument,
  }) : super(
         retry: null,
         name: r'loadBalancerMetricsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadBalancerMetricsHash();

  @override
  String toString() {
    return r'loadBalancerMetricsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<List<(DateTime, double)>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<List<(DateTime, double)>>> create(Ref ref) {
    final argument =
        this.argument as (ProjectScope, int, LbMetric, MetricPeriod);
    return loadBalancerMetrics(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LoadBalancerMetricsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadBalancerMetricsHash() =>
    r'56321d9059f3cae757887915f3db019b182ac6a7';

/// Samples of [metric] over [period], one list per series key.

final class LoadBalancerMetricsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<List<(DateTime, double)>>>,
          (ProjectScope, int, LbMetric, MetricPeriod)
        > {
  LoadBalancerMetricsFamily._()
    : super(
        retry: null,
        name: r'loadBalancerMetricsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Samples of [metric] over [period], one list per series key.

  LoadBalancerMetricsProvider call(
    ProjectScope scope,
    int lbId,
    LbMetric metric,
    MetricPeriod period,
  ) => LoadBalancerMetricsProvider._(
    argument: (scope, lbId, metric, period),
    from: this,
  );

  @override
  String toString() => r'loadBalancerMetricsProvider';
}
