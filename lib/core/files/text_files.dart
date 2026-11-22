// SPDX-License-Identifier: GPL-3.0-or-later
/// Opening and saving text files through the system file dialogs (zone
/// files, DNS-015 and DNS-016). Tests override [textFilesProvider].
library;

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_files.g.dart';

/// A picked text file: its content, or `tooLarge` when it exceeds the
/// limit. `text` is null then, and when the file is not UTF-8 text.
typedef PickedText = ({String? text, bool tooLarge});

/// [bytes] as UTF-8 text without a leading byte order mark; null when
/// they are not UTF-8.
String? decodeText(List<int> bytes) {
  try {
    final text = utf8.decode(bytes);
    return text.startsWith('\uFEFF') ? text.substring(1) : text;
  } on FormatException {
    return null;
  }
}

/// The system file dialogs for text.
class TextFiles {
  const new();

  /// Lets the user pick a file of at most [maxBytes]; null when cancelled.
  Future<PickedText?> pick({required int maxBytes}) async {
    final file = (await FilePicker.pickFiles()).firstOrNull;
    if (file == null) return null;
    try {
      if ((await file.length() ?? 0) > maxBytes) {
        return (text: null, tooLarge: true);
      }
      return (
        text: decodeText(await file.xFile.readAsBytes()),
        tooLarge: false,
      );
    } finally {
      // The picker's copy may be a refused private key.
      if (pickerCopyDir(file.path) case final dir?) {
        try {
          await Directory(dir).delete(recursive: true);
        } on FileSystemException {
          // Already gone.
        }
      }
    }
  }

  /// Lets the user pick any file to upload (OBJ-007); null when
  /// cancelled. A picked document without a path is copied to a
  /// temporary file named like it.
  Future<File?> pickFile() async {
    final f = (await FilePicker.pickFiles()).firstOrNull;
    if (f == null) return null;
    if (f.path case final path?) return File(path);
    final dir = await Directory.systemTemp.createTemp(uploadCopyPrefix);
    final copy = '${dir.path}/${f.name}';
    await f.xFile.saveTo(copy);
    return File(copy);
  }

  /// Lets the user save [text] as [name]; false when cancelled.
  Future<bool> save(String name, String text) async {
    final before = Platform.isIOS ? await _saveFolders() : const <String>{};
    try {
      return await FilePicker.saveFile(
            fileName: name,
            bytes: utf8.encode(text),
            mimeType: 'text/plain',
          ) !=
          null;
    } finally {
      if (Platform.isIOS) await _dropSaveCopy(name, before);
    }
  }

  static Directory get _saveRoot =>
      Directory('${Directory.systemTemp.path}/flutter_file_picker');

  /// The folders in [_saveRoot] now.
  Future<Set<String>> _saveFolders() async {
    try {
      return {
        await for (final e in _saveRoot.list())
          if (e is Directory) e.path,
      };
    } on FileSystemException {
      return {};
    }
  }

  /// iOS writes a saved file to `flutter_file_picker/<uuid>/<name>` in
  /// the temporary folder first and keeps it there; it may be a private
  /// key. Removes only folders holding [name] that this save created (not
  /// in [before]), so picked files of a running upload stay.
  Future<void> _dropSaveCopy(String name, Set<String> before) async {
    for (final dir in (await _saveFolders()).difference(before)) {
      if (!File('$dir/$name').existsSync()) continue;
      try {
        await Directory(dir).delete(recursive: true);
      } on FileSystemException {
        // Already gone.
      }
    }
  }
}

/// The folder file_picker copied a picked file at [path] into:
/// `tmp/flutter_file_picker/<uuid>` on iOS, `cache/file_picker/<uuid>`
/// on Android. Null for any other path, which is not ours to delete.
String? pickerCopyDir(String? path) {
  if (path == null) return null;
  for (final root in ['/tmp/flutter_file_picker/', '/cache/file_picker/']) {
    final i = path.indexOf(root);
    if (i < 0) continue;
    final start = i + root.length;
    final end = path.indexOf('/', start);
    // The file sits in its own folder below the root.
    if (end <= start) return null;
    final uuid = path.substring(start, end);
    return uuid == '.' || uuid == '..' ? null : path.substring(0, end);
  }
  return null;
}

/// Name start of the temporary folders [TextFiles.pickFile] copies a
/// picked document without a path into.
const uploadCopyPrefix = 'falco-upload';

/// The folder holding the copy of a file picked for upload at [path]: the
/// picker's ([pickerCopyDir]) or the temporary one of
/// [TextFiles.pickFile]. Null for any other path, which is not ours.
String? uploadCopyDir(String? path) {
  if (pickerCopyDir(path) case final dir?) return dir;
  if (path == null) return null;
  final dir = File(path).parent;
  // Compared by name: the platform may spell the temporary folder through
  // another link (`/private/var` on iOS).
  return _name(dir).startsWith(uploadCopyPrefix) &&
          _name(dir.parent) == _name(Directory.systemTemp)
      ? dir.path
      : null;
}

String _name(FileSystemEntity e) =>
    e.uri.pathSegments.lastWhere((s) => s.isNotEmpty, orElse: () => '');

/// Deletes the copy of a file picked for upload at [path] (see
/// [uploadCopyDir]); any other path stays.
Future<void> dropUploadCopy(String? path) async {
  if (uploadCopyDir(path) case final dir?) {
    try {
      await Directory(dir).delete(recursive: true);
    } on FileSystemException {
      // Already gone.
    }
  }
}

/// Deletes the folders in [roots] (whose names start with [prefix])
/// holding none of the files [inUse]: copies of picked files left behind.
Future<void> dropUnusedCopies(
  Iterable<Directory> roots,
  Set<String> inUse, {
  String prefix = '',
}) async {
  for (final root in roots) {
    try {
      await for (final dir in root.list()) {
        final name = _name(dir);
        if (dir is! Directory || !name.startsWith(prefix)) continue;
        // By the folder's unique name: the platform may spell the path
        // through another link (`/private/var` on iOS).
        if (inUse.any((p) => p.contains('/$name/'))) continue;
        try {
          await dir.delete(recursive: true);
        } on FileSystemException {
          // In use by the system, or gone.
        }
      }
    } on FileSystemException {
      // No such root.
    }
  }
}

@Riverpod(keepAlive: true)
TextFiles textFiles(Ref ref) => const TextFiles();
