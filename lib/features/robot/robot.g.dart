// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'robot.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Robot webservice of an account; the login is read per request.
/// A login Robot refuses before it ever succeeded is wrong: every
/// request with it fails at once as [Unauthorized]. Once a login
/// succeeded, a refusal blocks only that path, a section the login may
/// not use. Either way it is sent again only after the stored login
/// changes (ROB-002). A changed login or a removed account rebuilds the
/// client.

@ProviderFor(robotApi)
final robotApiProvider = RobotApiFamily._();

/// The Robot webservice of an account; the login is read per request.
/// A login Robot refuses before it ever succeeded is wrong: every
/// request with it fails at once as [Unauthorized]. Once a login
/// succeeded, a refusal blocks only that path, a section the login may
/// not use. Either way it is sent again only after the stored login
/// changes (ROB-002). A changed login or a removed account rebuilds the
/// client.

final class RobotApiProvider
    extends $FunctionalProvider<RobotClient, RobotClient, RobotClient>
    with $Provider<RobotClient> {
  /// The Robot webservice of an account; the login is read per request.
  /// A login Robot refuses before it ever succeeded is wrong: every
  /// request with it fails at once as [Unauthorized]. Once a login
  /// succeeded, a refusal blocks only that path, a section the login may
  /// not use. Either way it is sent again only after the stored login
  /// changes (ROB-002). A changed login or a removed account rebuilds the
  /// client.
  RobotApiProvider._({
    required RobotApiFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotApiProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotApiHash();

  @override
  String toString() {
    return r'robotApiProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<RobotClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RobotClient create(Ref ref) {
    final argument = this.argument as String;
    return robotApi(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RobotClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RobotClient>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RobotApiProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotApiHash() => r'60c693e05c46d714204bdd21ee397968e884d989';

/// The Robot webservice of an account; the login is read per request.
/// A login Robot refuses before it ever succeeded is wrong: every
/// request with it fails at once as [Unauthorized]. Once a login
/// succeeded, a refusal blocks only that path, a section the login may
/// not use. Either way it is sent again only after the stored login
/// changes (ROB-002). A changed login or a removed account rebuilds the
/// client.

final class RobotApiFamily extends $Family
    with $FunctionalFamilyOverride<RobotClient, String> {
  RobotApiFamily._()
    : super(
        retry: null,
        name: r'robotApiProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The Robot webservice of an account; the login is read per request.
  /// A login Robot refuses before it ever succeeded is wrong: every
  /// request with it fails at once as [Unauthorized]. Once a login
  /// succeeded, a refusal blocks only that path, a section the login may
  /// not use. Either way it is sent again only after the stored login
  /// changes (ROB-002). A changed login or a removed account rebuilds the
  /// client.

  RobotApiProvider call(String accountId) =>
      RobotApiProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotApiProvider';
}

@ProviderFor(robotServers)
final robotServersProvider = RobotServersFamily._();

final class RobotServersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RobotServer>>,
          List<RobotServer>,
          FutureOr<List<RobotServer>>
        >
    with
        $FutureModifier<List<RobotServer>>,
        $FutureProvider<List<RobotServer>> {
  RobotServersProvider._({
    required RobotServersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotServersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotServersHash();

  @override
  String toString() {
    return r'robotServersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RobotServer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RobotServer>> create(Ref ref) {
    final argument = this.argument as String;
    return robotServers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotServersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotServersHash() => r'e823cf13c196b5812d4749150db52c8a62ea5ec1';

final class RobotServersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RobotServer>>, String> {
  RobotServersFamily._()
    : super(
        retry: null,
        name: r'robotServersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotServersProvider call(String accountId) =>
      RobotServersProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotServersProvider';
}

@ProviderFor(robotServer)
final robotServerProvider = RobotServerFamily._();

final class RobotServerProvider
    extends
        $FunctionalProvider<
          AsyncValue<RobotServer>,
          RobotServer,
          FutureOr<RobotServer>
        >
    with $FutureModifier<RobotServer>, $FutureProvider<RobotServer> {
  RobotServerProvider._({
    required RobotServerFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'robotServerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotServerHash();

  @override
  String toString() {
    return r'robotServerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RobotServer> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RobotServer> create(Ref ref) {
    final argument = this.argument as (String, int);
    return robotServer(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotServerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotServerHash() => r'31242a13a0cb2d7c07ad01c7ac18736a6d408a3d';

final class RobotServerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RobotServer>, (String, int)> {
  RobotServerFamily._()
    : super(
        retry: null,
        name: r'robotServerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotServerProvider call(String accountId, int number) =>
      RobotServerProvider._(argument: (accountId, number), from: this);

  @override
  String toString() => r'robotServerProvider';
}

/// Reset types of every server (ROB-036), for the list quick actions.

@ProviderFor(robotResets)
final robotResetsProvider = RobotResetsFamily._();

/// Reset types of every server (ROB-036), for the list quick actions.

final class RobotResetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, List<String>>>,
          Map<int, List<String>>,
          FutureOr<Map<int, List<String>>>
        >
    with
        $FutureModifier<Map<int, List<String>>>,
        $FutureProvider<Map<int, List<String>>> {
  /// Reset types of every server (ROB-036), for the list quick actions.
  RobotResetsProvider._({
    required RobotResetsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotResetsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotResetsHash();

  @override
  String toString() {
    return r'robotResetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<int, List<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, List<String>>> create(Ref ref) {
    final argument = this.argument as String;
    return robotResets(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotResetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotResetsHash() => r'b4d931d4c8c52cc9ed797e020007815ad63dcab6';

/// Reset types of every server (ROB-036), for the list quick actions.

final class RobotResetsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<int, List<String>>>, String> {
  RobotResetsFamily._()
    : super(
        retry: null,
        name: r'robotResetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Reset types of every server (ROB-036), for the list quick actions.

  RobotResetsProvider call(String accountId) =>
      RobotResetsProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotResetsProvider';
}

/// Reset types of one server (ROB-035, BUG-012).

@ProviderFor(robotResetTypes)
final robotResetTypesProvider = RobotResetTypesFamily._();

/// Reset types of one server (ROB-035, BUG-012).

final class RobotResetTypesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Reset types of one server (ROB-035, BUG-012).
  RobotResetTypesProvider._({
    required RobotResetTypesFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'robotResetTypesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotResetTypesHash();

  @override
  String toString() {
    return r'robotResetTypesProvider'
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
    final argument = this.argument as (String, int);
    return robotResetTypes(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotResetTypesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotResetTypesHash() => r'580f8a02401cd94c2f81e9982593eef5e679dd23';

/// Reset types of one server (ROB-035, BUG-012).

final class RobotResetTypesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, (String, int)> {
  RobotResetTypesFamily._()
    : super(
        retry: null,
        name: r'robotResetTypesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Reset types of one server (ROB-035, BUG-012).

  RobotResetTypesProvider call(String accountId, int number) =>
      RobotResetTypesProvider._(argument: (accountId, number), from: this);

  @override
  String toString() => r'robotResetTypesProvider';
}

@ProviderFor(robotWol)
final robotWolProvider = RobotWolFamily._();

final class RobotWolProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  RobotWolProvider._({
    required RobotWolFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'robotWolProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotWolHash();

  @override
  String toString() {
    return r'robotWolProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as (String, int);
    return robotWol(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotWolProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotWolHash() => r'76a43942d8d6ef6e2d744842b5712245500f063c';

final class RobotWolFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, (String, int)> {
  RobotWolFamily._()
    : super(
        retry: null,
        name: r'robotWolProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotWolProvider call(String accountId, int number) =>
      RobotWolProvider._(argument: (accountId, number), from: this);

  @override
  String toString() => r'robotWolProvider';
}

/// Every boot configuration of a server (ROB-037).

@ProviderFor(robotBoot)
final robotBootProvider = RobotBootFamily._();

/// Every boot configuration of a server (ROB-037).

final class RobotBootProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, BootOption>>,
          Map<String, BootOption>,
          FutureOr<Map<String, BootOption>>
        >
    with
        $FutureModifier<Map<String, BootOption>>,
        $FutureProvider<Map<String, BootOption>> {
  /// Every boot configuration of a server (ROB-037).
  RobotBootProvider._({
    required RobotBootFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'robotBootProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotBootHash();

  @override
  String toString() {
    return r'robotBootProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, BootOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, BootOption>> create(Ref ref) {
    final argument = this.argument as (String, int);
    return robotBoot(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotBootProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotBootHash() => r'c3d8aa7ff348c15f3869b1aa71082007719ddfa1';

/// Every boot configuration of a server (ROB-037).

final class RobotBootFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, BootOption>>,
          (String, int)
        > {
  RobotBootFamily._()
    : super(
        retry: null,
        name: r'robotBootProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every boot configuration of a server (ROB-037).

  RobotBootProvider call(String accountId, int number) =>
      RobotBootProvider._(argument: (accountId, number), from: this);

  @override
  String toString() => r'robotBootProvider';
}

@ProviderFor(robotCancellation)
final robotCancellationProvider = RobotCancellationFamily._();

final class RobotCancellationProvider
    extends
        $FunctionalProvider<
          AsyncValue<RobotCancellation>,
          RobotCancellation,
          FutureOr<RobotCancellation>
        >
    with
        $FutureModifier<RobotCancellation>,
        $FutureProvider<RobotCancellation> {
  RobotCancellationProvider._({
    required RobotCancellationFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'robotCancellationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotCancellationHash();

  @override
  String toString() {
    return r'robotCancellationProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RobotCancellation> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RobotCancellation> create(Ref ref) {
    final argument = this.argument as (String, int);
    return robotCancellation(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotCancellationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotCancellationHash() => r'dd1f06f7f81cb03e3bd41f8b041541c26fec7619';

final class RobotCancellationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RobotCancellation>, (String, int)> {
  RobotCancellationFamily._()
    : super(
        retry: null,
        name: r'robotCancellationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotCancellationProvider call(String accountId, int number) =>
      RobotCancellationProvider._(argument: (accountId, number), from: this);

  @override
  String toString() => r'robotCancellationProvider';
}

@ProviderFor(robotRdns)
final robotRdnsProvider = RobotRdnsFamily._();

final class RobotRdnsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RobotRdns>>,
          List<RobotRdns>,
          FutureOr<List<RobotRdns>>
        >
    with $FutureModifier<List<RobotRdns>>, $FutureProvider<List<RobotRdns>> {
  RobotRdnsProvider._({
    required RobotRdnsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotRdnsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotRdnsHash();

  @override
  String toString() {
    return r'robotRdnsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RobotRdns>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RobotRdns>> create(Ref ref) {
    final argument = this.argument as String;
    return robotRdns(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotRdnsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotRdnsHash() => r'c6397e5b9ea72381cfe02ad4332fadcf4a47dabc';

final class RobotRdnsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RobotRdns>>, String> {
  RobotRdnsFamily._()
    : super(
        retry: null,
        name: r'robotRdnsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotRdnsProvider call(String accountId) =>
      RobotRdnsProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotRdnsProvider';
}

@ProviderFor(robotFailovers)
final robotFailoversProvider = RobotFailoversFamily._();

final class RobotFailoversProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RobotFailover>>,
          List<RobotFailover>,
          FutureOr<List<RobotFailover>>
        >
    with
        $FutureModifier<List<RobotFailover>>,
        $FutureProvider<List<RobotFailover>> {
  RobotFailoversProvider._({
    required RobotFailoversFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotFailoversProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotFailoversHash();

  @override
  String toString() {
    return r'robotFailoversProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RobotFailover>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RobotFailover>> create(Ref ref) {
    final argument = this.argument as String;
    return robotFailovers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotFailoversProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotFailoversHash() => r'6597f32b6b16920835479f5c8aaa8569651e2e39';

final class RobotFailoversFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RobotFailover>>, String> {
  RobotFailoversFamily._()
    : super(
        retry: null,
        name: r'robotFailoversProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotFailoversProvider call(String accountId) =>
      RobotFailoversProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotFailoversProvider';
}

@ProviderFor(robotVSwitches)
final robotVSwitchesProvider = RobotVSwitchesFamily._();

final class RobotVSwitchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RobotVSwitch>>,
          List<RobotVSwitch>,
          FutureOr<List<RobotVSwitch>>
        >
    with
        $FutureModifier<List<RobotVSwitch>>,
        $FutureProvider<List<RobotVSwitch>> {
  RobotVSwitchesProvider._({
    required RobotVSwitchesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotVSwitchesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotVSwitchesHash();

  @override
  String toString() {
    return r'robotVSwitchesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RobotVSwitch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RobotVSwitch>> create(Ref ref) {
    final argument = this.argument as String;
    return robotVSwitches(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotVSwitchesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotVSwitchesHash() => r'd0623397448f2661345343254c38a2b999c470d4';

final class RobotVSwitchesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RobotVSwitch>>, String> {
  RobotVSwitchesFamily._()
    : super(
        retry: null,
        name: r'robotVSwitchesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotVSwitchesProvider call(String accountId) =>
      RobotVSwitchesProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotVSwitchesProvider';
}

@ProviderFor(robotVSwitch)
final robotVSwitchProvider = RobotVSwitchFamily._();

final class RobotVSwitchProvider
    extends
        $FunctionalProvider<
          AsyncValue<RobotVSwitch>,
          RobotVSwitch,
          FutureOr<RobotVSwitch>
        >
    with $FutureModifier<RobotVSwitch>, $FutureProvider<RobotVSwitch> {
  RobotVSwitchProvider._({
    required RobotVSwitchFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'robotVSwitchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotVSwitchHash();

  @override
  String toString() {
    return r'robotVSwitchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RobotVSwitch> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RobotVSwitch> create(Ref ref) {
    final argument = this.argument as (String, int);
    return robotVSwitch(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotVSwitchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotVSwitchHash() => r'1fabe4701323a126a0877121589d3334fdc95064';

final class RobotVSwitchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RobotVSwitch>, (String, int)> {
  RobotVSwitchFamily._()
    : super(
        retry: null,
        name: r'robotVSwitchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotVSwitchProvider call(String accountId, int id) =>
      RobotVSwitchProvider._(argument: (accountId, id), from: this);

  @override
  String toString() => r'robotVSwitchProvider';
}

@ProviderFor(robotKeys)
final robotKeysProvider = RobotKeysFamily._();

final class RobotKeysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RobotKey>>,
          List<RobotKey>,
          FutureOr<List<RobotKey>>
        >
    with $FutureModifier<List<RobotKey>>, $FutureProvider<List<RobotKey>> {
  RobotKeysProvider._({
    required RobotKeysFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotKeysProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotKeysHash();

  @override
  String toString() {
    return r'robotKeysProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RobotKey>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RobotKey>> create(Ref ref) {
    final argument = this.argument as String;
    return robotKeys(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotKeysProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotKeysHash() => r'233fe3ca2de602c63bcfa21d63e1c6af59d84237';

final class RobotKeysFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RobotKey>>, String> {
  RobotKeysFamily._()
    : super(
        retry: null,
        name: r'robotKeysProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotKeysProvider call(String accountId) =>
      RobotKeysProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotKeysProvider';
}

@ProviderFor(robotKey)
final robotKeyProvider = RobotKeyFamily._();

final class RobotKeyProvider
    extends
        $FunctionalProvider<AsyncValue<RobotKey>, RobotKey, FutureOr<RobotKey>>
    with $FutureModifier<RobotKey>, $FutureProvider<RobotKey> {
  RobotKeyProvider._({
    required RobotKeyFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'robotKeyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotKeyHash();

  @override
  String toString() {
    return r'robotKeyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RobotKey> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<RobotKey> create(Ref ref) {
    final argument = this.argument as (String, String);
    return robotKey(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotKeyHash() => r'48eeb5ff4eff8836a4f3e9435053b0b4619d535f';

final class RobotKeyFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RobotKey>, (String, String)> {
  RobotKeyFamily._()
    : super(
        retry: null,
        name: r'robotKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotKeyProvider call(String accountId, String fingerprint) =>
      RobotKeyProvider._(argument: (accountId, fingerprint), from: this);

  @override
  String toString() => r'robotKeyProvider';
}

@ProviderFor(robotAddresses)
final robotAddressesProvider = RobotAddressesFamily._();

final class RobotAddressesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RobotAddress>>,
          List<RobotAddress>,
          FutureOr<List<RobotAddress>>
        >
    with
        $FutureModifier<List<RobotAddress>>,
        $FutureProvider<List<RobotAddress>> {
  RobotAddressesProvider._({
    required RobotAddressesFamily super.from,
    required (String, AddressKind) super.argument,
  }) : super(
         retry: null,
         name: r'robotAddressesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotAddressesHash();

  @override
  String toString() {
    return r'robotAddressesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<RobotAddress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RobotAddress>> create(Ref ref) {
    final argument = this.argument as (String, AddressKind);
    return robotAddresses(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotAddressesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotAddressesHash() => r'91c8e13a1a059abb5d6297f5b7564ea53cffde72';

final class RobotAddressesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<RobotAddress>>,
          (String, AddressKind)
        > {
  RobotAddressesFamily._()
    : super(
        retry: null,
        name: r'robotAddressesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotAddressesProvider call(String accountId, AddressKind kind) =>
      RobotAddressesProvider._(argument: (accountId, kind), from: this);

  @override
  String toString() => r'robotAddressesProvider';
}

@ProviderFor(robotAddress)
final robotAddressProvider = RobotAddressFamily._();

final class RobotAddressProvider
    extends
        $FunctionalProvider<
          AsyncValue<RobotAddress>,
          RobotAddress,
          FutureOr<RobotAddress>
        >
    with $FutureModifier<RobotAddress>, $FutureProvider<RobotAddress> {
  RobotAddressProvider._({
    required RobotAddressFamily super.from,
    required (String, AddressKind, String) super.argument,
  }) : super(
         retry: null,
         name: r'robotAddressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotAddressHash();

  @override
  String toString() {
    return r'robotAddressProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RobotAddress> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RobotAddress> create(Ref ref) {
    final argument = this.argument as (String, AddressKind, String);
    return robotAddress(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotAddressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotAddressHash() => r'9e5057c94fb6bd2af64d08fa4bb8dd8499f75126';

final class RobotAddressFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RobotAddress>,
          (String, AddressKind, String)
        > {
  RobotAddressFamily._()
    : super(
        retry: null,
        name: r'robotAddressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotAddressProvider call(String accountId, AddressKind kind, String ip) =>
      RobotAddressProvider._(argument: (accountId, kind, ip), from: this);

  @override
  String toString() => r'robotAddressProvider';
}

/// The separate MAC: `(possible, mac)`.

@ProviderFor(robotMac)
final robotMacProvider = RobotMacFamily._();

/// The separate MAC: `(possible, mac)`.

final class RobotMacProvider
    extends
        $FunctionalProvider<
          AsyncValue<(bool, String?)>,
          (bool, String?),
          FutureOr<(bool, String?)>
        >
    with $FutureModifier<(bool, String?)>, $FutureProvider<(bool, String?)> {
  /// The separate MAC: `(possible, mac)`.
  RobotMacProvider._({
    required RobotMacFamily super.from,
    required (String, AddressKind, String) super.argument,
  }) : super(
         retry: null,
         name: r'robotMacProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotMacHash();

  @override
  String toString() {
    return r'robotMacProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<(bool, String?)> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<(bool, String?)> create(Ref ref) {
    final argument = this.argument as (String, AddressKind, String);
    return robotMac(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotMacProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotMacHash() => r'd5c7dd477127af7c7a7ac27d209f2f87afa769ff';

/// The separate MAC: `(possible, mac)`.

final class RobotMacFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<(bool, String?)>,
          (String, AddressKind, String)
        > {
  RobotMacFamily._()
    : super(
        retry: null,
        name: r'robotMacProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The separate MAC: `(possible, mac)`.

  RobotMacProvider call(String accountId, AddressKind kind, String ip) =>
      RobotMacProvider._(argument: (accountId, kind, ip), from: this);

  @override
  String toString() => r'robotMacProvider';
}

@ProviderFor(robotAddressCancellation)
final robotAddressCancellationProvider = RobotAddressCancellationFamily._();

final class RobotAddressCancellationProvider
    extends
        $FunctionalProvider<
          AsyncValue<AddressCancellation>,
          AddressCancellation,
          FutureOr<AddressCancellation>
        >
    with
        $FutureModifier<AddressCancellation>,
        $FutureProvider<AddressCancellation> {
  RobotAddressCancellationProvider._({
    required RobotAddressCancellationFamily super.from,
    required (String, AddressKind, String) super.argument,
  }) : super(
         retry: null,
         name: r'robotAddressCancellationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotAddressCancellationHash();

  @override
  String toString() {
    return r'robotAddressCancellationProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AddressCancellation> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AddressCancellation> create(Ref ref) {
    final argument = this.argument as (String, AddressKind, String);
    return robotAddressCancellation(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotAddressCancellationProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotAddressCancellationHash() =>
    r'096fbdca1abac461377d79c131fc9b78f3977779';

final class RobotAddressCancellationFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<AddressCancellation>,
          (String, AddressKind, String)
        > {
  RobotAddressCancellationFamily._()
    : super(
        retry: null,
        name: r'robotAddressCancellationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotAddressCancellationProvider call(
    String accountId,
    AddressKind kind,
    String ip,
  ) => RobotAddressCancellationProvider._(
    argument: (accountId, kind, ip),
    from: this,
  );

  @override
  String toString() => r'robotAddressCancellationProvider';
}

@ProviderFor(robotFirewall)
final robotFirewallProvider = RobotFirewallFamily._();

final class RobotFirewallProvider
    extends
        $FunctionalProvider<
          AsyncValue<RobotFirewall>,
          RobotFirewall,
          FutureOr<RobotFirewall>
        >
    with $FutureModifier<RobotFirewall>, $FutureProvider<RobotFirewall> {
  RobotFirewallProvider._({
    required RobotFirewallFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'robotFirewallProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotFirewallHash();

  @override
  String toString() {
    return r'robotFirewallProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RobotFirewall> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RobotFirewall> create(Ref ref) {
    final argument = this.argument as (String, int);
    return robotFirewall(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotFirewallProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotFirewallHash() => r'6ae507559c9611f7c1cf0bb394dfc8482feda7a5';

final class RobotFirewallFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RobotFirewall>, (String, int)> {
  RobotFirewallFamily._()
    : super(
        retry: null,
        name: r'robotFirewallProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotFirewallProvider call(String accountId, int number) =>
      RobotFirewallProvider._(argument: (accountId, number), from: this);

  @override
  String toString() => r'robotFirewallProvider';
}

@ProviderFor(robotTemplates)
final robotTemplatesProvider = RobotTemplatesFamily._();

final class RobotTemplatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RobotFirewall>>,
          List<RobotFirewall>,
          FutureOr<List<RobotFirewall>>
        >
    with
        $FutureModifier<List<RobotFirewall>>,
        $FutureProvider<List<RobotFirewall>> {
  RobotTemplatesProvider._({
    required RobotTemplatesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotTemplatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotTemplatesHash();

  @override
  String toString() {
    return r'robotTemplatesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RobotFirewall>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RobotFirewall>> create(Ref ref) {
    final argument = this.argument as String;
    return robotTemplates(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotTemplatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotTemplatesHash() => r'12fbfd834a71bd484fd7513ea8f66574886ecf78';

final class RobotTemplatesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RobotFirewall>>, String> {
  RobotTemplatesFamily._()
    : super(
        retry: null,
        name: r'robotTemplatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RobotTemplatesProvider call(String accountId) =>
      RobotTemplatesProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotTemplatesProvider';
}

/// One template. Robot documents no name in the single template answer,
/// so an empty one comes from the list (ROB-058); without it the apply
/// confirmation would have nothing to type and Save would clear the name.

@ProviderFor(robotTemplate)
final robotTemplateProvider = RobotTemplateFamily._();

/// One template. Robot documents no name in the single template answer,
/// so an empty one comes from the list (ROB-058); without it the apply
/// confirmation would have nothing to type and Save would clear the name.

final class RobotTemplateProvider
    extends
        $FunctionalProvider<
          AsyncValue<RobotFirewall>,
          RobotFirewall,
          FutureOr<RobotFirewall>
        >
    with $FutureModifier<RobotFirewall>, $FutureProvider<RobotFirewall> {
  /// One template. Robot documents no name in the single template answer,
  /// so an empty one comes from the list (ROB-058); without it the apply
  /// confirmation would have nothing to type and Save would clear the name.
  RobotTemplateProvider._({
    required RobotTemplateFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'robotTemplateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotTemplateHash();

  @override
  String toString() {
    return r'robotTemplateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RobotFirewall> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RobotFirewall> create(Ref ref) {
    final argument = this.argument as (String, int);
    return robotTemplate(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotTemplateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotTemplateHash() => r'eb9378d53f87286df22d34047a833de30e6952b0';

/// One template. Robot documents no name in the single template answer,
/// so an empty one comes from the list (ROB-058); without it the apply
/// confirmation would have nothing to type and Save would clear the name.

final class RobotTemplateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RobotFirewall>, (String, int)> {
  RobotTemplateFamily._()
    : super(
        retry: null,
        name: r'robotTemplateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One template. Robot documents no name in the single template answer,
  /// so an empty one comes from the list (ROB-058); without it the apply
  /// confirmation would have nothing to type and Save would clear the name.

  RobotTemplateProvider call(String accountId, int id) =>
      RobotTemplateProvider._(argument: (accountId, id), from: this);

  @override
  String toString() => r'robotTemplateProvider';
}

/// Traffic of [address] in the running month (ROB-008). Robot has data
/// for days that passed, so on the 1st it shows nothing yet.

@ProviderFor(robotMonthTraffic)
final robotMonthTrafficProvider = RobotMonthTrafficFamily._();

/// Traffic of [address] in the running month (ROB-008). Robot has data
/// for days that passed, so on the 1st it shows nothing yet.

final class RobotMonthTrafficProvider
    extends
        $FunctionalProvider<AsyncValue<Traffic?>, Traffic?, FutureOr<Traffic?>>
    with $FutureModifier<Traffic?>, $FutureProvider<Traffic?> {
  /// Traffic of [address] in the running month (ROB-008). Robot has data
  /// for days that passed, so on the 1st it shows nothing yet.
  RobotMonthTrafficProvider._({
    required RobotMonthTrafficFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'robotMonthTrafficProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotMonthTrafficHash();

  @override
  String toString() {
    return r'robotMonthTrafficProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Traffic?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Traffic?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return robotMonthTraffic(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RobotMonthTrafficProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotMonthTrafficHash() => r'e512d61c2db76568c56d808fa3315cf358404912';

/// Traffic of [address] in the running month (ROB-008). Robot has data
/// for days that passed, so on the 1st it shows nothing yet.

final class RobotMonthTrafficFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Traffic?>, (String, String)> {
  RobotMonthTrafficFamily._()
    : super(
        retry: null,
        name: r'robotMonthTrafficProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Traffic of [address] in the running month (ROB-008). Robot has data
  /// for days that passed, so on the 1st it shows nothing yet.

  RobotMonthTrafficProvider call(String accountId, String address) =>
      RobotMonthTrafficProvider._(argument: (accountId, address), from: this);

  @override
  String toString() => r'robotMonthTrafficProvider';
}

/// Robot changes of this app session, newest first. Robot has no action
/// list of its own, so the app records what it did (ROB-016).

@ProviderFor(RobotActivity)
final robotActivityProvider = RobotActivityFamily._();

/// Robot changes of this app session, newest first. Robot has no action
/// list of its own, so the app records what it did (ROB-016).
final class RobotActivityProvider
    extends $NotifierProvider<RobotActivity, List<ActionProgress>> {
  /// Robot changes of this app session, newest first. Robot has no action
  /// list of its own, so the app records what it did (ROB-016).
  RobotActivityProvider._({
    required RobotActivityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'robotActivityProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$robotActivityHash();

  @override
  String toString() {
    return r'robotActivityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RobotActivity create() => RobotActivity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ActionProgress> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ActionProgress>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RobotActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$robotActivityHash() => r'2481545e9d62c42a8245b281d0bb5a04819281a5';

/// Robot changes of this app session, newest first. Robot has no action
/// list of its own, so the app records what it did (ROB-016).

final class RobotActivityFamily extends $Family
    with
        $ClassFamilyOverride<
          RobotActivity,
          List<ActionProgress>,
          List<ActionProgress>,
          List<ActionProgress>,
          String
        > {
  RobotActivityFamily._()
    : super(
        retry: null,
        name: r'robotActivityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Robot changes of this app session, newest first. Robot has no action
  /// list of its own, so the app records what it did (ROB-016).

  RobotActivityProvider call(String accountId) =>
      RobotActivityProvider._(argument: accountId, from: this);

  @override
  String toString() => r'robotActivityProvider';
}

/// Robot changes of this app session, newest first. Robot has no action
/// list of its own, so the app records what it did (ROB-016).

abstract class _$RobotActivity extends $Notifier<List<ActionProgress>> {
  late final _$args = ref.$arg as String;
  String get accountId => _$args;

  List<ActionProgress> build(String accountId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ActionProgress>, List<ActionProgress>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ActionProgress>, List<ActionProgress>>,
              List<ActionProgress>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
