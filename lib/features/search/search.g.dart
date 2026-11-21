// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every resource of every account (SUC-002), from the providers the
/// lists use. Kept alive, so a search opened again starts on loaded data;
/// a source whose refresh fails keeps its last data (offline).

@ProviderFor(searchIndex)
final searchIndexProvider = SearchIndexProvider._();

/// Every resource of every account (SUC-002), from the providers the
/// lists use. Kept alive, so a search opened again starts on loaded data;
/// a source whose refresh fails keeps its last data (offline).

final class SearchIndexProvider
    extends
        $FunctionalProvider<
          SearchIndexState,
          SearchIndexState,
          SearchIndexState
        >
    with $Provider<SearchIndexState> {
  /// Every resource of every account (SUC-002), from the providers the
  /// lists use. Kept alive, so a search opened again starts on loaded data;
  /// a source whose refresh fails keeps its last data (offline).
  SearchIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchIndexProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchIndexHash();

  @$internal
  @override
  $ProviderElement<SearchIndexState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchIndexState create(Ref ref) {
    return searchIndex(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchIndexState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchIndexState>(value),
    );
  }
}

String _$searchIndexHash() => r'aaefcc31551e33406d4eea97c0e9bf9e5d78110e';

/// The last searches, newest first, kept on the device.

@ProviderFor(RecentSearches)
final recentSearchesProvider = RecentSearchesProvider._();

/// The last searches, newest first, kept on the device.
final class RecentSearchesProvider
    extends $NotifierProvider<RecentSearches, List<String>> {
  /// The last searches, newest first, kept on the device.
  RecentSearchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchesHash();

  @$internal
  @override
  RecentSearches create() => RecentSearches();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentSearchesHash() => r'319e512a4ef9e80a64ae15e80b7b548c66e1c3db';

/// The last searches, newest first, kept on the device.

abstract class _$RecentSearches extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
