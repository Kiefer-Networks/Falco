// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scope_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app wide scope repository.

@ProviderFor(scopeRepository)
final scopeRepositoryProvider = ScopeRepositoryProvider._();

/// The app wide scope repository.

final class ScopeRepositoryProvider
    extends
        $FunctionalProvider<ScopeRepository, ScopeRepository, ScopeRepository>
    with $Provider<ScopeRepository> {
  /// The app wide scope repository.
  ScopeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scopeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scopeRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScopeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScopeRepository create(Ref ref) {
    return scopeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScopeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScopeRepository>(value),
    );
  }
}

String _$scopeRepositoryHash() => r'e454ae3c935017f162c0300d59aaeb7ebe998cbb';
