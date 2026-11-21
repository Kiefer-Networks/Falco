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

String _$serversHash() => r'34cef612b706488098f76fe1312edbadcf023b0b';

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

/// Actions of [scope], newest first; of one server when [serverId] is set.
/// All pages are loaded like every list (BUG-022).
// ponytail: project activity covers server actions only; the other
// resource types join with their areas (Phase 4 to 8).

@ProviderFor(activity)
final activityProvider = ActivityFamily._();

/// Actions of [scope], newest first; of one server when [serverId] is set.
/// All pages are loaded like every list (BUG-022).
// ponytail: project activity covers server actions only; the other
// resource types join with their areas (Phase 4 to 8).

final class ActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActionProgress>>,
          List<ActionProgress>,
          FutureOr<List<ActionProgress>>
        >
    with
        $FutureModifier<List<ActionProgress>>,
        $FutureProvider<List<ActionProgress>> {
  /// Actions of [scope], newest first; of one server when [serverId] is set.
  /// All pages are loaded like every list (BUG-022).
  // ponytail: project activity covers server actions only; the other
  // resource types join with their areas (Phase 4 to 8).
  ActivityProvider._({
    required ActivityFamily super.from,
    required (ProjectScope, int?) super.argument,
  }) : super(
         retry: null,
         name: r'activityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityHash();

  @override
  String toString() {
    return r'activityProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ActionProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActionProgress>> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int?);
    return activity(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityHash() => r'5b05f13563b793ecb21e1ca678a4fb5a2306f84e';

/// Actions of [scope], newest first; of one server when [serverId] is set.
/// All pages are loaded like every list (BUG-022).
// ponytail: project activity covers server actions only; the other
// resource types join with their areas (Phase 4 to 8).

final class ActivityFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ActionProgress>>,
          (ProjectScope, int?)
        > {
  ActivityFamily._()
    : super(
        retry: null,
        name: r'activityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Actions of [scope], newest first; of one server when [serverId] is set.
  /// All pages are loaded like every list (BUG-022).
  // ponytail: project activity covers server actions only; the other
  // resource types join with their areas (Phase 4 to 8).

  ActivityProvider call(ProjectScope scope, int? serverId) =>
      ActivityProvider._(argument: (scope, serverId), from: this);

  @override
  String toString() => r'activityProvider';
}

/// Follows the actions of one project and, when one ends, reloads what it
/// touched: the server, every server list and the activity (QRS-028).

@ProviderFor(actionTracker)
final actionTrackerProvider = ActionTrackerFamily._();

/// Follows the actions of one project and, when one ends, reloads what it
/// touched: the server, every server list and the activity (QRS-028).

final class ActionTrackerProvider
    extends $FunctionalProvider<ActionTracker, ActionTracker, ActionTracker>
    with $Provider<ActionTracker> {
  /// Follows the actions of one project and, when one ends, reloads what it
  /// touched: the server, every server list and the activity (QRS-028).
  ActionTrackerProvider._({
    required ActionTrackerFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'actionTrackerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$actionTrackerHash();

  @override
  String toString() {
    return r'actionTrackerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ActionTracker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActionTracker create(Ref ref) {
    final argument = this.argument as ProjectScope;
    return actionTracker(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionTracker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionTracker>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActionTrackerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$actionTrackerHash() => r'57ea42e8aadf43fdca9385dd20d1d8ef08a7e9ea';

/// Follows the actions of one project and, when one ends, reloads what it
/// touched: the server, every server list and the activity (QRS-028).

final class ActionTrackerFamily extends $Family
    with $FunctionalFamilyOverride<ActionTracker, ProjectScope> {
  ActionTrackerFamily._()
    : super(
        retry: null,
        name: r'actionTrackerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Follows the actions of one project and, when one ends, reloads what it
  /// touched: the server, every server list and the activity (QRS-028).

  ActionTrackerProvider call(ProjectScope scope) =>
      ActionTrackerProvider._(argument: scope, from: this);

  @override
  String toString() => r'actionTrackerProvider';
}

/// The latest tracked action touching server [serverId]: the running one
/// when the page opens, then every update until it ends. Read from the
/// tracker, so the progress survives leaving and reopening the page.

@ProviderFor(serverAction)
final serverActionProvider = ServerActionFamily._();

/// The latest tracked action touching server [serverId]: the running one
/// when the page opens, then every update until it ends. Read from the
/// tracker, so the progress survives leaving and reopening the page.

final class ServerActionProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActionProgress?>,
          ActionProgress?,
          Stream<ActionProgress?>
        >
    with $FutureModifier<ActionProgress?>, $StreamProvider<ActionProgress?> {
  /// The latest tracked action touching server [serverId]: the running one
  /// when the page opens, then every update until it ends. Read from the
  /// tracker, so the progress survives leaving and reopening the page.
  ServerActionProvider._({
    required ServerActionFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'serverActionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serverActionHash();

  @override
  String toString() {
    return r'serverActionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<ActionProgress?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ActionProgress?> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return serverAction(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ServerActionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serverActionHash() => r'3b8b2f1dc8e9e42601fbe450b597fe1a5363f81a';

/// The latest tracked action touching server [serverId]: the running one
/// when the page opens, then every update until it ends. Read from the
/// tracker, so the progress survives leaving and reopening the page.

final class ServerActionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<ActionProgress?>,
          (ProjectScope, int)
        > {
  ServerActionFamily._()
    : super(
        retry: null,
        name: r'serverActionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The latest tracked action touching server [serverId]: the running one
  /// when the page opens, then every update until it ends. Read from the
  /// tracker, so the progress survives leaving and reopening the page.

  ServerActionProvider call(ProjectScope scope, int serverId) =>
      ServerActionProvider._(argument: (scope, serverId), from: this);

  @override
  String toString() => r'serverActionProvider';
}
