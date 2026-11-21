// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_files.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(textFiles)
final textFilesProvider = TextFilesProvider._();

final class TextFilesProvider
    extends $FunctionalProvider<TextFiles, TextFiles, TextFiles>
    with $Provider<TextFiles> {
  TextFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'textFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$textFilesHash();

  @$internal
  @override
  $ProviderElement<TextFiles> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TextFiles create(Ref ref) {
    return textFiles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TextFiles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TextFiles>(value),
    );
  }
}

String _$textFilesHash() => r'5e501f24f34ae1b752840337c09b3268bc55fba6';
