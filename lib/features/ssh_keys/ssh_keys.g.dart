// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssh_keys.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All SSH keys of [scope] (CMP-070).

@ProviderFor(sshKeys)
final sshKeysProvider = SshKeysFamily._();

/// All SSH keys of [scope] (CMP-070).

final class SshKeysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SshKey>>,
          List<SshKey>,
          FutureOr<List<SshKey>>
        >
    with $FutureModifier<List<SshKey>>, $FutureProvider<List<SshKey>> {
  /// All SSH keys of [scope] (CMP-070).
  SshKeysProvider._({
    required SshKeysFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'sshKeysProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sshKeysHash();

  @override
  String toString() {
    return r'sshKeysProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SshKey>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SshKey>> create(Ref ref) {
    final argument = this.argument as Scope;
    return sshKeys(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SshKeysProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sshKeysHash() => r'99008c09ae6b6d482a8d11c1820f97d8adb954c7';

/// All SSH keys of [scope] (CMP-070).

final class SshKeysFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SshKey>>, Scope> {
  SshKeysFamily._()
    : super(
        retry: null,
        name: r'sshKeysProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All SSH keys of [scope] (CMP-070).

  SshKeysProvider call(Scope scope) =>
      SshKeysProvider._(argument: scope, from: this);

  @override
  String toString() => r'sshKeysProvider';
}

/// One SSH key (CMP-099).

@ProviderFor(sshKey)
final sshKeyProvider = SshKeyFamily._();

/// One SSH key (CMP-099).

final class SshKeyProvider
    extends $FunctionalProvider<AsyncValue<SshKey>, SshKey, FutureOr<SshKey>>
    with $FutureModifier<SshKey>, $FutureProvider<SshKey> {
  /// One SSH key (CMP-099).
  SshKeyProvider._({
    required SshKeyFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'sshKeyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sshKeyHash();

  @override
  String toString() {
    return r'sshKeyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<SshKey> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SshKey> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return sshKey(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SshKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sshKeyHash() => r'864274752d39c80e3f67a4144817783a42111989';

/// One SSH key (CMP-099).

final class SshKeyFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SshKey>, (ProjectScope, int)> {
  SshKeyFamily._()
    : super(
        retry: null,
        name: r'sshKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One SSH key (CMP-099).

  SshKeyProvider call(ProjectScope scope, int keyId) =>
      SshKeyProvider._(argument: (scope, keyId), from: this);

  @override
  String toString() => r'sshKeyProvider';
}
