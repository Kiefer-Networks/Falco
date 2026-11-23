// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_boxes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All Storage Boxes of [scope] (STB-001).

@ProviderFor(storageBoxes)
final storageBoxesProvider = StorageBoxesFamily._();

/// All Storage Boxes of [scope] (STB-001).

final class StorageBoxesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StorageBox>>,
          List<StorageBox>,
          FutureOr<List<StorageBox>>
        >
    with $FutureModifier<List<StorageBox>>, $FutureProvider<List<StorageBox>> {
  /// All Storage Boxes of [scope] (STB-001).
  StorageBoxesProvider._({
    required StorageBoxesFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'storageBoxesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storageBoxesHash();

  @override
  String toString() {
    return r'storageBoxesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<StorageBox>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StorageBox>> create(Ref ref) {
    final argument = this.argument as Scope;
    return storageBoxes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StorageBoxesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storageBoxesHash() => r'76858b6a1a6a327152122168337e456d26097d27';

/// All Storage Boxes of [scope] (STB-001).

final class StorageBoxesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<StorageBox>>, Scope> {
  StorageBoxesFamily._()
    : super(
        retry: null,
        name: r'storageBoxesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All Storage Boxes of [scope] (STB-001).

  StorageBoxesProvider call(Scope scope) =>
      StorageBoxesProvider._(argument: scope, from: this);

  @override
  String toString() => r'storageBoxesProvider';
}

/// One Storage Box (STB-005).

@ProviderFor(storageBox)
final storageBoxProvider = StorageBoxFamily._();

/// One Storage Box (STB-005).

final class StorageBoxProvider
    extends
        $FunctionalProvider<
          AsyncValue<StorageBox>,
          StorageBox,
          FutureOr<StorageBox>
        >
    with $FutureModifier<StorageBox>, $FutureProvider<StorageBox> {
  /// One Storage Box (STB-005).
  StorageBoxProvider._({
    required StorageBoxFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'storageBoxProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storageBoxHash();

  @override
  String toString() {
    return r'storageBoxProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<StorageBox> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<StorageBox> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return storageBox(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is StorageBoxProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storageBoxHash() => r'63b8bdddafb851cb1eea1e85fc7501552a7b821b';

/// One Storage Box (STB-005).

final class StorageBoxFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StorageBox>, (ProjectScope, int)> {
  StorageBoxFamily._()
    : super(
        retry: null,
        name: r'storageBoxProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One Storage Box (STB-005).

  StorageBoxProvider call(ProjectScope scope, int boxId) =>
      StorageBoxProvider._(argument: (scope, boxId), from: this);

  @override
  String toString() => r'storageBoxProvider';
}

/// Snapshots of a box, newest first (STB-013).

@ProviderFor(boxSnapshots)
final boxSnapshotsProvider = BoxSnapshotsFamily._();

/// Snapshots of a box, newest first (STB-013).

final class BoxSnapshotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BoxSnapshot>>,
          List<BoxSnapshot>,
          FutureOr<List<BoxSnapshot>>
        >
    with
        $FutureModifier<List<BoxSnapshot>>,
        $FutureProvider<List<BoxSnapshot>> {
  /// Snapshots of a box, newest first (STB-013).
  BoxSnapshotsProvider._({
    required BoxSnapshotsFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'boxSnapshotsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boxSnapshotsHash();

  @override
  String toString() {
    return r'boxSnapshotsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<BoxSnapshot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BoxSnapshot>> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return boxSnapshots(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BoxSnapshotsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boxSnapshotsHash() => r'751d29f135173965b9fd37c34fa455cd833740d3';

/// Snapshots of a box, newest first (STB-013).

final class BoxSnapshotsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<BoxSnapshot>>,
          (ProjectScope, int)
        > {
  BoxSnapshotsFamily._()
    : super(
        retry: null,
        name: r'boxSnapshotsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Snapshots of a box, newest first (STB-013).

  BoxSnapshotsProvider call(ProjectScope scope, int boxId) =>
      BoxSnapshotsProvider._(argument: (scope, boxId), from: this);

  @override
  String toString() => r'boxSnapshotsProvider';
}

/// One snapshot (STB-035).

@ProviderFor(boxSnapshot)
final boxSnapshotProvider = BoxSnapshotFamily._();

/// One snapshot (STB-035).

final class BoxSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<BoxSnapshot>,
          BoxSnapshot,
          FutureOr<BoxSnapshot>
        >
    with $FutureModifier<BoxSnapshot>, $FutureProvider<BoxSnapshot> {
  /// One snapshot (STB-035).
  BoxSnapshotProvider._({
    required BoxSnapshotFamily super.from,
    required (ProjectScope, int, int) super.argument,
  }) : super(
         retry: null,
         name: r'boxSnapshotProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boxSnapshotHash();

  @override
  String toString() {
    return r'boxSnapshotProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<BoxSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BoxSnapshot> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int, int);
    return boxSnapshot(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is BoxSnapshotProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boxSnapshotHash() => r'6105ab7f3cabd7edc75fd593822288fb0536e435';

/// One snapshot (STB-035).

final class BoxSnapshotFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<BoxSnapshot>,
          (ProjectScope, int, int)
        > {
  BoxSnapshotFamily._()
    : super(
        retry: null,
        name: r'boxSnapshotProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One snapshot (STB-035).

  BoxSnapshotProvider call(ProjectScope scope, int boxId, int snapshotId) =>
      BoxSnapshotProvider._(argument: (scope, boxId, snapshotId), from: this);

  @override
  String toString() => r'boxSnapshotProvider';
}

/// Subaccounts of a box (STB-017).

@ProviderFor(subaccounts)
final subaccountsProvider = SubaccountsFamily._();

/// Subaccounts of a box (STB-017).

final class SubaccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Subaccount>>,
          List<Subaccount>,
          FutureOr<List<Subaccount>>
        >
    with $FutureModifier<List<Subaccount>>, $FutureProvider<List<Subaccount>> {
  /// Subaccounts of a box (STB-017).
  SubaccountsProvider._({
    required SubaccountsFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'subaccountsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subaccountsHash();

  @override
  String toString() {
    return r'subaccountsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Subaccount>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Subaccount>> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return subaccounts(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SubaccountsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subaccountsHash() => r'8c907e8bbbd17b5b99692cd46dca9b6a3168bee6';

/// Subaccounts of a box (STB-017).

final class SubaccountsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Subaccount>>,
          (ProjectScope, int)
        > {
  SubaccountsFamily._()
    : super(
        retry: null,
        name: r'subaccountsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Subaccounts of a box (STB-017).

  SubaccountsProvider call(ProjectScope scope, int boxId) =>
      SubaccountsProvider._(argument: (scope, boxId), from: this);

  @override
  String toString() => r'subaccountsProvider';
}

/// One subaccount (STB-032).

@ProviderFor(subaccount)
final subaccountProvider = SubaccountFamily._();

/// One subaccount (STB-032).

final class SubaccountProvider
    extends
        $FunctionalProvider<
          AsyncValue<Subaccount>,
          Subaccount,
          FutureOr<Subaccount>
        >
    with $FutureModifier<Subaccount>, $FutureProvider<Subaccount> {
  /// One subaccount (STB-032).
  SubaccountProvider._({
    required SubaccountFamily super.from,
    required (ProjectScope, int, int) super.argument,
  }) : super(
         retry: null,
         name: r'subaccountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subaccountHash();

  @override
  String toString() {
    return r'subaccountProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Subaccount> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Subaccount> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int, int);
    return subaccount(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is SubaccountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subaccountHash() => r'23bc2352e33f875ed82ddf8b984ec161fdc78be8';

/// One subaccount (STB-032).

final class SubaccountFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Subaccount>,
          (ProjectScope, int, int)
        > {
  SubaccountFamily._()
    : super(
        retry: null,
        name: r'subaccountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One subaccount (STB-032).

  SubaccountProvider call(ProjectScope scope, int boxId, int subaccountId) =>
      SubaccountProvider._(argument: (scope, boxId, subaccountId), from: this);

  @override
  String toString() => r'subaccountProvider';
}

/// Top level folders of a box, for a subaccount's home (STB-025).

@ProviderFor(boxFolders)
final boxFoldersProvider = BoxFoldersFamily._();

/// Top level folders of a box, for a subaccount's home (STB-025).

final class BoxFoldersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Top level folders of a box, for a subaccount's home (STB-025).
  BoxFoldersProvider._({
    required BoxFoldersFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'boxFoldersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boxFoldersHash();

  @override
  String toString() {
    return r'boxFoldersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return boxFolders(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BoxFoldersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boxFoldersHash() => r'072d0a1f5df4e65422aa5938ec36019600e00087';

/// Top level folders of a box, for a subaccount's home (STB-025).

final class BoxFoldersFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<String>>, (ProjectScope, int)> {
  BoxFoldersFamily._()
    : super(
        retry: null,
        name: r'boxFoldersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Top level folders of a box, for a subaccount's home (STB-025).

  BoxFoldersProvider call(ProjectScope scope, int boxId) =>
      BoxFoldersProvider._(argument: (scope, boxId), from: this);

  @override
  String toString() => r'boxFoldersProvider';
}

/// All box types, current ones first (STB-002, STB-029).

@ProviderFor(boxTypes)
final boxTypesProvider = BoxTypesFamily._();

/// All box types, current ones first (STB-002, STB-029).

final class BoxTypesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BoxType>>,
          List<BoxType>,
          FutureOr<List<BoxType>>
        >
    with $FutureModifier<List<BoxType>>, $FutureProvider<List<BoxType>> {
  /// All box types, current ones first (STB-002, STB-029).
  BoxTypesProvider._({
    required BoxTypesFamily super.from,
    required ProjectScope super.argument,
  }) : super(
         retry: null,
         name: r'boxTypesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boxTypesHash();

  @override
  String toString() {
    return r'boxTypesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BoxType>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BoxType>> create(Ref ref) {
    final argument = this.argument as ProjectScope;
    return boxTypes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BoxTypesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boxTypesHash() => r'709f3865ee9edf9214c89f5879c7bfc787ed1dd2';

/// All box types, current ones first (STB-002, STB-029).

final class BoxTypesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BoxType>>, ProjectScope> {
  BoxTypesFamily._()
    : super(
        retry: null,
        name: r'boxTypesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All box types, current ones first (STB-002, STB-029).

  BoxTypesProvider call(ProjectScope scope) =>
      BoxTypesProvider._(argument: scope, from: this);

  @override
  String toString() => r'boxTypesProvider';
}

/// One box type with its prices (STB-037).

@ProviderFor(boxType)
final boxTypeProvider = BoxTypeFamily._();

/// One box type with its prices (STB-037).

final class BoxTypeProvider
    extends $FunctionalProvider<AsyncValue<BoxType>, BoxType, FutureOr<BoxType>>
    with $FutureModifier<BoxType>, $FutureProvider<BoxType> {
  /// One box type with its prices (STB-037).
  BoxTypeProvider._({
    required BoxTypeFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'boxTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boxTypeHash();

  @override
  String toString() {
    return r'boxTypeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<BoxType> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<BoxType> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return boxType(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BoxTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boxTypeHash() => r'a5fdb2fe02999875272cb1299c4a0d90ba6daa99';

/// One box type with its prices (STB-037).

final class BoxTypeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BoxType>, (ProjectScope, int)> {
  BoxTypeFamily._()
    : super(
        retry: null,
        name: r'boxTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One box type with its prices (STB-037).

  BoxTypeProvider call(ProjectScope scope, int typeId) =>
      BoxTypeProvider._(argument: (scope, typeId), from: this);

  @override
  String toString() => r'boxTypeProvider';
}

/// Actions of one box, newest first (STB-026).

@ProviderFor(boxActions)
final boxActionsProvider = BoxActionsFamily._();

/// Actions of one box, newest first (STB-026).

final class BoxActionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActionProgress>>,
          List<ActionProgress>,
          FutureOr<List<ActionProgress>>
        >
    with
        $FutureModifier<List<ActionProgress>>,
        $FutureProvider<List<ActionProgress>> {
  /// Actions of one box, newest first (STB-026).
  BoxActionsProvider._({
    required BoxActionsFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'boxActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boxActionsHash();

  @override
  String toString() {
    return r'boxActionsProvider'
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
    final argument = this.argument as (ProjectScope, int);
    return boxActions(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BoxActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boxActionsHash() => r'faee8086b50854a10bf2ceb589af44111f995b9f';

/// Actions of one box, newest first (STB-026).

final class BoxActionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ActionProgress>>,
          (ProjectScope, int)
        > {
  BoxActionsFamily._()
    : super(
        retry: null,
        name: r'boxActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Actions of one box, newest first (STB-026).

  BoxActionsProvider call(ProjectScope scope, int boxId) =>
      BoxActionsProvider._(argument: (scope, boxId), from: this);

  @override
  String toString() => r'boxActionsProvider';
}
