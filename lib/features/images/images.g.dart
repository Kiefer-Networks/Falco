// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All images of [scope]: system, app, snapshots and backups.

@ProviderFor(images)
final imagesProvider = ImagesFamily._();

/// All images of [scope]: system, app, snapshots and backups.

final class ImagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CloudImage>>,
          List<CloudImage>,
          FutureOr<List<CloudImage>>
        >
    with $FutureModifier<List<CloudImage>>, $FutureProvider<List<CloudImage>> {
  /// All images of [scope]: system, app, snapshots and backups.
  ImagesProvider._({
    required ImagesFamily super.from,
    required Scope super.argument,
  }) : super(
         retry: null,
         name: r'imagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$imagesHash();

  @override
  String toString() {
    return r'imagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CloudImage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CloudImage>> create(Ref ref) {
    final argument = this.argument as Scope;
    return images(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ImagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$imagesHash() => r'7dbf128ee335e5f666ab2f3a37d45b614c0aee54';

/// All images of [scope]: system, app, snapshots and backups.

final class ImagesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CloudImage>>, Scope> {
  ImagesFamily._()
    : super(
        retry: null,
        name: r'imagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All images of [scope]: system, app, snapshots and backups.

  ImagesProvider call(Scope scope) =>
      ImagesProvider._(argument: scope, from: this);

  @override
  String toString() => r'imagesProvider';
}

/// One image (CMP-093).

@ProviderFor(image)
final imageProvider = ImageFamily._();

/// One image (CMP-093).

final class ImageProvider
    extends
        $FunctionalProvider<
          AsyncValue<CloudImage>,
          CloudImage,
          FutureOr<CloudImage>
        >
    with $FutureModifier<CloudImage>, $FutureProvider<CloudImage> {
  /// One image (CMP-093).
  ImageProvider._({
    required ImageFamily super.from,
    required (ProjectScope, int) super.argument,
  }) : super(
         retry: null,
         name: r'imageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$imageHash();

  @override
  String toString() {
    return r'imageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CloudImage> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CloudImage> create(Ref ref) {
    final argument = this.argument as (ProjectScope, int);
    return image(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ImageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$imageHash() => r'c2767b79baaac2395c7098d601a935b3c9e110b1';

/// One image (CMP-093).

final class ImageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CloudImage>, (ProjectScope, int)> {
  ImageFamily._()
    : super(
        retry: null,
        name: r'imageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One image (CMP-093).

  ImageProvider call(ProjectScope scope, int imageId) =>
      ImageProvider._(argument: (scope, imageId), from: this);

  @override
  String toString() => r'imageProvider';
}
