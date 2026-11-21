// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All servers of [scope], every page, every project of the scope (CMP-002).

@ProviderFor(servers)
final serversProvider = ServersFamily._();

/// All servers of [scope], every page, every project of the scope (CMP-002).

final class ServersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CloudServer>>,
          List<CloudServer>,
          FutureOr<List<CloudServer>>
        >
    with
        $FutureModifier<List<CloudServer>>,
        $FutureProvider<List<CloudServer>> {
  /// All servers of [scope], every page, every project of the scope (CMP-002).
  ServersProvider._({
    required ServersFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'serversProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serversHash();

  @override
  String toString() {
    return r'serversProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CloudServer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CloudServer>> create(Ref ref) {
    final argument = this.argument as Scope;
    return servers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serversHash() => r'ab0086c6762a9cd872fcc9bc013c83d2cd045471';

/// All servers of [scope], every page, every project of the scope (CMP-002).

final class ServersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CloudServer>>, Scope> {
  ServersFamily._()
    : super(
        retry: null,
        name: r'serversProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All servers of [scope], every page, every project of the scope (CMP-002).

  ServersProvider call(Scope scope) =>
      ServersProvider._(argument: scope, from: this);

  @override
  String toString() => r'serversProvider';
}

/// One server.

@ProviderFor(server)
final serverProvider = ServerFamily._();

/// One server.

final class ServerProvider
    extends
        $FunctionalProvider<
          AsyncValue<CloudServer>,
          CloudServer,
          FutureOr<CloudServer>
        >
    with $FutureModifier<CloudServer>, $FutureProvider<CloudServer> {
  /// One server.
  ServerProvider._({
    required ServerFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'serverProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serverHash();

  @override
  String toString() {
    return r'serverProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CloudServer> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CloudServer> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return server(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ServerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serverHash() => r'a43000d38e0e2b5d0e56d24364836c81695dce86';

/// One server.

final class ServerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CloudServer>, (ProjectScope, int)> {
  ServerFamily._()
    : super(
        retry: null,
        name: r'serverProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One server.

  ServerProvider call(ProjectScope scope, int serverId) =>
      ServerProvider._(argument: (scope, serverId), from: this);

  @override
  String toString() => r'serverProvider';
}

/// Samples of [metric] over [period], one list per [ServerMetric.keys]
/// entry. One request per metric keeps the `type` parameter unambiguous.

@ProviderFor(serverMetrics)
final serverMetricsProvider = ServerMetricsFamily._();

/// Samples of [metric] over [period], one list per [ServerMetric.keys]
/// entry. One request per metric keeps the `type` parameter unambiguous.

final class ServerMetricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<List<(DateTime, double)>>>,
          List<List<(DateTime, double)>>,
          FutureOr<List<List<(DateTime, double)>>>
        >
    with
        $FutureModifier<List<List<(DateTime, double)>>>,
        $FutureProvider<List<List<(DateTime, double)>>> {
  /// Samples of [metric] over [period], one list per [ServerMetric.keys]
  /// entry. One request per metric keeps the `type` parameter unambiguous.
  ServerMetricsProvider._({
    required ServerMetricsFamily super.from,
    required (ProjectScope, int, ServerMetric, MetricPeriod) super.argument,
  }) : super(
         retry: null,
         name: r'serverMetricsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serverMetricsHash();

  @override
  String toString() {
    return r'serverMetricsProvider'
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
        this.argument as (ProjectScope, int, ServerMetric, MetricPeriod);
    return serverMetrics(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ServerMetricsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serverMetricsHash() => r'b75430b69d1b1851f030ad31d461559c1fdc5f68';

/// Samples of [metric] over [period], one list per [ServerMetric.keys]
/// entry. One request per metric keeps the `type` parameter unambiguous.

final class ServerMetricsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<List<(DateTime, double)>>>,
          (ProjectScope, int, ServerMetric, MetricPeriod)
        > {
  ServerMetricsFamily._()
    : super(
        retry: null,
        name: r'serverMetricsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Samples of [metric] over [period], one list per [ServerMetric.keys]
  /// entry. One request per metric keeps the `type` parameter unambiguous.

  ServerMetricsProvider call(
    ProjectScope scope,
    int serverId,
    ServerMetric metric,
    MetricPeriod period,
  ) => ServerMetricsProvider._(
    argument: (scope, serverId, metric, period),
    from: this,
  );

  @override
  String toString() => r'serverMetricsProvider';
}
