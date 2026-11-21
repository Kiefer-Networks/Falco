// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Actions of a project, newest first: every resource type with an
/// action list. With [serverId] those of one server. All pages, like
/// every list (BUG-022).

@ProviderFor(activity)
final activityProvider = ActivityFamily._();

/// Actions of a project, newest first: every resource type with an
/// action list. With [serverId] those of one server. All pages, like
/// every list (BUG-022).

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
  /// Actions of a project, newest first: every resource type with an
  /// action list. With [serverId] those of one server. All pages, like
  /// every list (BUG-022).
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

String _$activityHash() => r'c1fd076eccfb881cfa56c1b303d71026d50a39cc';

/// Actions of a project, newest first: every resource type with an
/// action list. With [serverId] those of one server. All pages, like
/// every list (BUG-022).

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

  /// Actions of a project, newest first: every resource type with an
  /// action list. With [serverId] those of one server. All pages, like
  /// every list (BUG-022).

  ActivityProvider call(ProjectScope scope, int? serverId) =>
      ActivityProvider._(argument: (scope, serverId), from: this);

  @override
  String toString() => r'activityProvider';
}

/// Follows the actions of one project and, when one ends, refreshes what
/// it touched (QRS-028).

@ProviderFor(actionTracker)
final actionTrackerProvider = ActionTrackerFamily._();

/// Follows the actions of one project and, when one ends, refreshes what
/// it touched (QRS-028).

final class ActionTrackerProvider
    extends $FunctionalProvider<ActionTracker, ActionTracker, ActionTracker>
    with $Provider<ActionTracker> {
  /// Follows the actions of one project and, when one ends, refreshes what
  /// it touched (QRS-028).
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

String _$actionTrackerHash() => r'74b8ca16430baa88a9704a6d99dfc91d1a95e682';

/// Follows the actions of one project and, when one ends, refreshes what
/// it touched (QRS-028).

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

  /// Follows the actions of one project and, when one ends, refreshes what
  /// it touched (QRS-028).

  ActionTrackerProvider call(ProjectScope scope) =>
      ActionTrackerProvider._(argument: scope, from: this);

  @override
  String toString() => r'actionTrackerProvider';
}

/// Follows the Storage Box actions of one project (api.hetzner.com has
/// its own action ids) and refreshes what they touched (STB-027).

@ProviderFor(storageBoxTracker)
final storageBoxTrackerProvider = StorageBoxTrackerFamily._();

/// Follows the Storage Box actions of one project (api.hetzner.com has
/// its own action ids) and refreshes what they touched (STB-027).

final class StorageBoxTrackerProvider
    extends $FunctionalProvider<ActionTracker, ActionTracker, ActionTracker>
    with $Provider<ActionTracker> {
  /// Follows the Storage Box actions of one project (api.hetzner.com has
  /// its own action ids) and refreshes what they touched (STB-027).
  StorageBoxTrackerProvider._({
    required StorageBoxTrackerFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'storageBoxTrackerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storageBoxTrackerHash();

  @override
  String toString() {
    return r'storageBoxTrackerProvider'
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
    return storageBoxTracker(ref, argument);
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
    return other is StorageBoxTrackerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storageBoxTrackerHash() => r'f1d6a78451326c4a4565a3935dd3ed9801039559';

/// Follows the Storage Box actions of one project (api.hetzner.com has
/// its own action ids) and refreshes what they touched (STB-027).

final class StorageBoxTrackerFamily extends $Family
    with $FunctionalFamilyOverride<ActionTracker, ProjectScope> {
  StorageBoxTrackerFamily._()
    : super(
        retry: null,
        name: r'storageBoxTrackerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Follows the Storage Box actions of one project (api.hetzner.com has
  /// its own action ids) and refreshes what they touched (STB-027).

  StorageBoxTrackerProvider call(ProjectScope scope) =>
      StorageBoxTrackerProvider._(argument: scope, from: this);

  @override
  String toString() => r'storageBoxTrackerProvider';
}

/// The latest tracked action touching resource [type] [id]: the running
/// one when the page opens, then every update until it ends. Read from
/// the tracker, so progress survives leaving and reopening the page.

@ProviderFor(trackedAction)
final trackedActionProvider = TrackedActionFamily._();

/// The latest tracked action touching resource [type] [id]: the running
/// one when the page opens, then every update until it ends. Read from
/// the tracker, so progress survives leaving and reopening the page.

final class TrackedActionProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActionProgress?>,
          ActionProgress?,
          Stream<ActionProgress?>
        >
    with $FutureModifier<ActionProgress?>, $StreamProvider<ActionProgress?> {
  /// The latest tracked action touching resource [type] [id]: the running
  /// one when the page opens, then every update until it ends. Read from
  /// the tracker, so progress survives leaving and reopening the page.
  TrackedActionProvider._({
    required TrackedActionFamily super.from,
    required (ProjectScope, String, int) super.argument,
  }) : super(
         retry: null,
         name: r'trackedActionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trackedActionHash();

  @override
  String toString() {
    return r'trackedActionProvider'
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
    final argument = this.argument as (ProjectScope, String, int);
    return trackedAction(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackedActionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trackedActionHash() => r'7d467b4a3497ea72b2f186600251b64c4cfe1962';

/// The latest tracked action touching resource [type] [id]: the running
/// one when the page opens, then every update until it ends. Read from
/// the tracker, so progress survives leaving and reopening the page.

final class TrackedActionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<ActionProgress?>,
          (ProjectScope, String, int)
        > {
  TrackedActionFamily._()
    : super(
        retry: null,
        name: r'trackedActionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The latest tracked action touching resource [type] [id]: the running
  /// one when the page opens, then every update until it ends. Read from
  /// the tracker, so progress survives leaving and reopening the page.

  TrackedActionProvider call(ProjectScope scope, String type, int id) =>
      TrackedActionProvider._(argument: (scope, type, id), from: this);

  @override
  String toString() => r'trackedActionProvider';
}
