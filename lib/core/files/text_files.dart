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

/// [bytes] as UTF-8 text; null when they are not.
String? decodeText(List<int> bytes) {
  try {
    return utf8.decode(bytes);
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
    if ((await file.length() ?? 0) > maxBytes) {
      return (text: null, tooLarge: true);
    }
    return (text: decodeText(await file.xFile.readAsBytes()), tooLarge: false);
  }

  /// Lets the user pick any file to upload (OBJ-007); null when
  /// cancelled. A picked document without a path is copied to a
  /// temporary file named like it.
  Future<File?> pickFile() async {
    final f = (await FilePicker.pickFiles()).firstOrNull;
    if (f == null) return null;
    if (f.path case final path?) return File(path);
    final dir = await Directory.systemTemp.createTemp('falco-upload');
    final copy = '${dir.path}/${f.name}';
    await f.xFile.saveTo(copy);
    return File(copy);
  }

  /// Lets the user save [text] as [name]; false when cancelled.
  Future<bool> save(String name, String text) async =>
      await FilePicker.saveFile(
        fileName: name,
        bytes: utf8.encode(text),
        mimeType: 'text/plain',
      ) !=
      null;
}

@Riverpod(keepAlive: true)
TextFiles textFiles(Ref ref) => const TextFiles();
