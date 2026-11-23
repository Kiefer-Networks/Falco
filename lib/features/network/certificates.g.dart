// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificates.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All certificates of [scope] (NET-079).

@ProviderFor(certificates)
final certificatesProvider = CertificatesFamily._();

/// All certificates of [scope] (NET-079).

final class CertificatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Certificate>>,
          List<Certificate>,
          FutureOr<List<Certificate>>
        >
    with
        $FutureModifier<List<Certificate>>,
        $FutureProvider<List<Certificate>> {
  /// All certificates of [scope] (NET-079).
  CertificatesProvider._({
    required CertificatesFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'certificatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$certificatesHash();

  @override
  String toString() {
    return r'certificatesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Certificate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Certificate>> create(Ref ref) {
    final argument = this.argument as Scope;
    return certificates(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CertificatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$certificatesHash() => r'affb90307290ea684ca2455fed284d9628342117';

/// All certificates of [scope] (NET-079).

final class CertificatesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Certificate>>, Scope> {
  CertificatesFamily._()
    : super(
        retry: null,
        name: r'certificatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All certificates of [scope] (NET-079).

  CertificatesProvider call(Scope scope) =>
      CertificatesProvider._(argument: scope, from: this);

  @override
  String toString() => r'certificatesProvider';
}

/// One certificate (NET-082).

@ProviderFor(certificate)
final certificateProvider = CertificateFamily._();

/// One certificate (NET-082).

final class CertificateProvider
    extends
        $FunctionalProvider<
          AsyncValue<Certificate>,
          Certificate,
          FutureOr<Certificate>
        >
    with $FutureModifier<Certificate>, $FutureProvider<Certificate> {
  /// One certificate (NET-082).
  CertificateProvider._({
    required CertificateFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'certificateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$certificateHash();

  @override
  String toString() {
    return r'certificateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Certificate> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Certificate> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return certificate(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CertificateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$certificateHash() => r'72738feb9b3e4f73d97c9c0c363682116e627ac6';

/// One certificate (NET-082).

final class CertificateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Certificate>, (ProjectScope, int)> {
  CertificateFamily._()
    : super(
        retry: null,
        name: r'certificateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One certificate (NET-082).

  CertificateProvider call(ProjectScope scope, int certificateId) =>
      CertificateProvider._(argument: (scope, certificateId), from: this);

  @override
  String toString() => r'certificateProvider';
}
