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

String _$transfersHash() => r'1b592e2a6dcb37479feb4b5d146de66712134f81';
