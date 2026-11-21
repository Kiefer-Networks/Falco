// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Registers the OFL license of the bundled IBM Plex fonts so it appears
/// on the licenses page. Call once before `runApp`.
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(const [
      'IBM Plex Sans',
      'IBM Plex Mono',
    ], text);
  });
}
