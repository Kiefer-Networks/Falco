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

/// Object Storage location of a project, null without keys.

@ProviderFor(projectS3)
final projectS3Provider = ProjectS3Family._();

/// Object Storage location of a project, null without keys.

final class ProjectS3Provider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Object Storage location of a project, null without keys.
  ProjectS3Provider._({
    required ProjectS3Family super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectS3Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectS3Hash();

  @override
  String toString() {
    return r'projectS3Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return projectS3(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectS3Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectS3Hash() => r'ce90c8294b8eed5e437384b8e83a87ad5d9c95b8';

/// Object Storage location of a project, null without keys.

final class ProjectS3Family extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  ProjectS3Family._()
    : super(
        retry: null,
        name: r'projectS3Provider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Object Storage location of a project, null without keys.

  ProjectS3Provider call(String projectId) =>
      ProjectS3Provider._(argument: projectId, from: this);

  @override
  String toString() => r'projectS3Provider';
}
