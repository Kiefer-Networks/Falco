// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// S3 access of the app.

@ProviderFor(s3Access)
final s3AccessProvider = S3AccessProvider._();

/// S3 access of the app.

final class S3AccessProvider
    extends $FunctionalProvider<S3Access, S3Access, S3Access>
    with $Provider<S3Access> {
  /// S3 access of the app.
  S3AccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r's3AccessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$s3AccessHash();

  @$internal
  @override
  $ProviderElement<S3Access> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  S3Access create(Ref ref) {
    return s3Access(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(S3Access value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<S3Access>(value),
    );
  }
}

String _$s3AccessHash() => r'329acbb5633cb56ac3e1e354b3c0e61dc13e7c3a';

/// Buckets of every project of [scope] with S3 keys, at all locations
/// (OBJ-001, OBJ-020). Null when no project has keys.

@ProviderFor(buckets)
final bucketsProvider = BucketsFamily._();

/// Buckets of every project of [scope] with S3 keys, at all locations
/// (OBJ-001, OBJ-020). Null when no project has keys.

final class BucketsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Bucket>?>,
          List<Bucket>?,
          FutureOr<List<Bucket>?>
        >
    with $FutureModifier<List<Bucket>?>, $FutureProvider<List<Bucket>?> {
  /// Buckets of every project of [scope] with S3 keys, at all locations
  /// (OBJ-001, OBJ-020). Null when no project has keys.
  BucketsProvider._({
    required BucketsFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'bucketsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bucketsHash();

  @override
  String toString() {
    return r'bucketsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Bucket>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Bucket>?> create(Ref ref) {
    final argument = this.argument as Scope;
    return buckets(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BucketsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bucketsHash() => r'508f3d24f30be0e92250db333f8e02052c2d5a53';

/// Buckets of every project of [scope] with S3 keys, at all locations
/// (OBJ-001, OBJ-020). Null when no project has keys.

final class BucketsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Bucket>?>, Scope> {
  BucketsFamily._()
    : super(
        retry: null,
        name: r'bucketsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Buckets of every project of [scope] with S3 keys, at all locations
  /// (OBJ-001, OBJ-020). Null when no project has keys.

  BucketsProvider call(Scope scope) =>
      BucketsProvider._(argument: scope, from: this);

  @override
  String toString() => r'bucketsProvider';
}

/// Versioning (`Enabled`, `Suspended` or null) and visibility of a bucket
/// (OBJ-004).

@ProviderFor(bucketSettings)
final bucketSettingsProvider = BucketSettingsFamily._();

/// Versioning (`Enabled`, `Suspended` or null) and visibility of a bucket
/// (OBJ-004).

final class BucketSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<({bool public, String? versioning})>,
          ({bool public, String? versioning}),
          FutureOr<({bool public, String? versioning})>
        >
    with
        $FutureModifier<({bool public, String? versioning})>,
        $FutureProvider<({bool public, String? versioning})> {
  /// Versioning (`Enabled`, `Suspended` or null) and visibility of a bucket
  /// (OBJ-004).
  BucketSettingsProvider._({
    required BucketSettingsFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'bucketSettingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bucketSettingsHash();

  @override
  String toString() {
    return r'bucketSettingsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<({bool public, String? versioning})> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<({bool public, String? versioning})> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return bucketSettings(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is BucketSettingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bucketSettingsHash() => r'dd4583cae45859935232744602fc9c7e6f25deb8';

/// Versioning (`Enabled`, `Suspended` or null) and visibility of a bucket
/// (OBJ-004).

final class BucketSettingsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<({bool public, String? versioning})>,
          (String, String, String)
        > {
  BucketSettingsFamily._()
    : super(
        retry: null,
        name: r'bucketSettingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Versioning (`Enabled`, `Suspended` or null) and visibility of a bucket
  /// (OBJ-004).

  BucketSettingsProvider call(
    String projectId,
    String location,
    String bucket,
  ) => BucketSettingsProvider._(
    argument: (projectId, location, bucket),
    from: this,
  );

  @override
  String toString() => r'bucketSettingsProvider';
}

/// Folders and objects below [prefix] (OBJ-006).

@ProviderFor(objects)
final objectsProvider = ObjectsFamily._();

/// Folders and objects below [prefix] (OBJ-006).

final class ObjectsProvider
    extends
        $FunctionalProvider<
          AsyncValue<({List<String> folders, List<S3Object> objects})>,
          ({List<String> folders, List<S3Object> objects}),
          FutureOr<({List<String> folders, List<S3Object> objects})>
        >
    with
        $FutureModifier<({List<String> folders, List<S3Object> objects})>,
        $FutureProvider<({List<String> folders, List<S3Object> objects})> {
  /// Folders and objects below [prefix] (OBJ-006).
  ObjectsProvider._({
    required ObjectsFamily super.from,
    required (String, String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'objectsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$objectsHash();

  @override
  String toString() {
    return r'objectsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<({List<String> folders, List<S3Object> objects})>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<({List<String> folders, List<S3Object> objects})> create(Ref ref) {
    final argument = this.argument as (String, String, String, String);
    return objects(ref, argument.$1, argument.$2, argument.$3, argument.$4);
  }

  @override
  bool operator ==(Object other) {
    return other is ObjectsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$objectsHash() => r'810038045f67b3bfaff7f82dd84664fcb7d5c177';

/// Folders and objects below [prefix] (OBJ-006).

final class ObjectsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<({List<String> folders, List<S3Object> objects})>,
          (String, String, String, String)
        > {
  ObjectsFamily._()
    : super(
        retry: null,
        name: r'objectsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Folders and objects below [prefix] (OBJ-006).

  ObjectsProvider call(
    String projectId,
    String location,
    String bucket,
    String prefix,
  ) => ObjectsProvider._(
    argument: (projectId, location, bucket, prefix),
    from: this,
  );

  @override
  String toString() => r'objectsProvider';
}

/// Versions of one object (OBJ-023).

@ProviderFor(objectVersions)
final objectVersionsProvider = ObjectVersionsFamily._();

/// Versions of one object (OBJ-023).

final class ObjectVersionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<S3Version>>,
          List<S3Version>,
          FutureOr<List<S3Version>>
        >
    with $FutureModifier<List<S3Version>>, $FutureProvider<List<S3Version>> {
  /// Versions of one object (OBJ-023).
  ObjectVersionsProvider._({
    required ObjectVersionsFamily super.from,
    required (String, String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'objectVersionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$objectVersionsHash();

  @override
  String toString() {
    return r'objectVersionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<S3Version>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<S3Version>> create(Ref ref) {
    final argument = this.argument as (String, String, String, String);
    return objectVersions(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ObjectVersionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$objectVersionsHash() => r'9d02c472bc910ccbd78ed50650e798d06b4b601e';

/// Versions of one object (OBJ-023).

final class ObjectVersionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<S3Version>>,
          (String, String, String, String)
        > {
  ObjectVersionsFamily._()
    : super(
        retry: null,
        name: r'objectVersionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Versions of one object (OBJ-023).

  ObjectVersionsProvider call(
    String projectId,
    String location,
    String bucket,
    String key,
  ) => ObjectVersionsProvider._(
    argument: (projectId, location, bucket, key),
    from: this,
  );

  @override
  String toString() => r'objectVersionsProvider';
}

/// Size, date, type and ETag of one object (OBJ-010).

@ProviderFor(objectInfo)
final objectInfoProvider = ObjectInfoFamily._();

/// Size, date, type and ETag of one object (OBJ-010).

final class ObjectInfoProvider
    extends
        $FunctionalProvider<AsyncValue<S3Object>, S3Object, FutureOr<S3Object>>
    with $FutureModifier<S3Object>, $FutureProvider<S3Object> {
  /// Size, date, type and ETag of one object (OBJ-010).
  ObjectInfoProvider._({
    required ObjectInfoFamily super.from,
    required (String, String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'objectInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$objectInfoHash();

  @override
  String toString() {
    return r'objectInfoProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<S3Object> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<S3Object> create(Ref ref) {
    final argument = this.argument as (String, String, String, String);
    return objectInfo(ref, argument.$1, argument.$2, argument.$3, argument.$4);
  }

  @override
  bool operator ==(Object other) {
    return other is ObjectInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$objectInfoHash() => r'489177dec966781aa4bc55e3a6733414fa019a5d';

/// Size, date, type and ETag of one object (OBJ-010).

final class ObjectInfoFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<S3Object>,
          (String, String, String, String)
        > {
  ObjectInfoFamily._()
    : super(
        retry: null,
        name: r'objectInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Size, date, type and ETag of one object (OBJ-010).

  ObjectInfoProvider call(
    String projectId,
    String location,
    String bucket,
    String key,
  ) => ObjectInfoProvider._(
    argument: (projectId, location, bucket, key),
    from: this,
  );

  @override
  String toString() => r'objectInfoProvider';
}
