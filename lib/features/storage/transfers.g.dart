// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's transfers; finished uploads refresh the listings.

@ProviderFor(transfers)
final transfersProvider = TransfersProvider._();

/// The app's transfers; finished uploads refresh the listings.

final class TransfersProvider
    extends
        $FunctionalProvider<ObjectTransfers, ObjectTransfers, ObjectTransfers>
    with $Provider<ObjectTransfers> {
  /// The app's transfers; finished uploads refresh the listings.
  TransfersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transfersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transfersHash();

  @$internal
  @override
  $ProviderElement<ObjectTransfers> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObjectTransfers create(Ref ref) {
    return transfers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObjectTransfers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObjectTransfers>(value),
    );
  }
}

String _$transfersHash() => r'40f403829a99ee0e74e8c7d106c24f6cffc26784';

/// Finished transfers, for the snackbar of the object browser.

@ProviderFor(transferEvents)
final transferEventsProvider = TransferEventsProvider._();

/// Finished transfers, for the snackbar of the object browser.

final class TransferEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<TransferEvent>,
          TransferEvent,
          Stream<TransferEvent>
        >
    with $FutureModifier<TransferEvent>, $StreamProvider<TransferEvent> {
  /// Finished transfers, for the snackbar of the object browser.
  TransferEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transferEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transferEventsHash();

  @$internal
  @override
  $StreamProviderElement<TransferEvent> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<TransferEvent> create(Ref ref) {
    return transferEvents(ref);
  }
}

String _$transferEventsHash() => r'0f7792afb3e3976ff3ae023b6a9e2cf9a4ad590d';
