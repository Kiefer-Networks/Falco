// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All accounts; invalidated after every change.

@ProviderFor(accounts)
final accountsProvider = AccountsProvider._();

/// All accounts; invalidated after every change.

final class AccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Account>>,
          List<Account>,
          FutureOr<List<Account>>
        >
    with $FutureModifier<List<Account>>, $FutureProvider<List<Account>> {
  /// All accounts; invalidated after every change.
  AccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsHash();

  @$internal
  @override
  $FutureProviderElement<List<Account>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Account>> create(Ref ref) {
    return accounts(ref);
  }
}

String _$accountsHash() => r'35cc159914e584e6a3671448c5b0b8211f3738bd';
