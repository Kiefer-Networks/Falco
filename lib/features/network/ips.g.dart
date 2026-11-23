// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ips.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All IPs of [kind] in [scope] (NET-018, NET-031).

@ProviderFor(publicIps)
final publicIpsProvider = PublicIpsFamily._();

/// All IPs of [kind] in [scope] (NET-018, NET-031).

final class PublicIpsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PublicIp>>,
          List<PublicIp>,
          FutureOr<List<PublicIp>>
        >
    with $FutureModifier<List<PublicIp>>, $FutureProvider<List<PublicIp>> {
  /// All IPs of [kind] in [scope] (NET-018, NET-031).
  PublicIpsProvider._({
    required PublicIpsFamily super.from,
    required (Scope, IpKind) super.argument,
  }) : super(
         retry: null,
         name: r'publicIpsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publicIpsHash();

  @override
  String toString() {
    return r'publicIpsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<PublicIp>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PublicIp>> create(Ref ref) {
    final argument = this.argument as (Scope, IpKind);
    return publicIps(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicIpsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicIpsHash() => r'86a9ee015f890cbda6141974e93e696c74405d36';

/// All IPs of [kind] in [scope] (NET-018, NET-031).

final class PublicIpsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PublicIp>>, (Scope, IpKind)> {
  PublicIpsFamily._()
    : super(
        retry: null,
        name: r'publicIpsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All IPs of [kind] in [scope] (NET-018, NET-031).

  PublicIpsProvider call(Scope scope, IpKind kind) =>
      PublicIpsProvider._(argument: (scope, kind), from: this);

  @override
  String toString() => r'publicIpsProvider';
}

/// One IP (NET-024, NET-034).

@ProviderFor(publicIp)
final publicIpProvider = PublicIpFamily._();

/// One IP (NET-024, NET-034).

final class PublicIpProvider
    extends
        $FunctionalProvider<AsyncValue<PublicIp>, PublicIp, FutureOr<PublicIp>>
    with $FutureModifier<PublicIp>, $FutureProvider<PublicIp> {
  /// One IP (NET-024, NET-034).
  PublicIpProvider._({
    required PublicIpFamily super.from,
    required (ProjectScope, IpKind, int) super.argument,
  }) : super(
         retry: null,
         name: r'publicIpProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publicIpHash();

  @override
  String toString() {
    return r'publicIpProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PublicIp> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PublicIp> create(Ref ref) {
    final argument = this.argument as (ProjectScope, IpKind, int);
    return publicIp(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicIpProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicIpHash() => r'1eb1aeac604cec81857c13afde2203fb94290ccd';

/// One IP (NET-024, NET-034).

final class PublicIpFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PublicIp>,
          (ProjectScope, IpKind, int)
        > {
  PublicIpFamily._()
    : super(
        retry: null,
        name: r'publicIpProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One IP (NET-024, NET-034).

  PublicIpProvider call(ProjectScope scope, IpKind kind, int ipId) =>
      PublicIpProvider._(argument: (scope, kind, ipId), from: this);

  @override
  String toString() => r'publicIpProvider';
}
