// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in the browser.
class LinkButton extends StatelessWidget {
  /// Creates the button.
  const new({required this.label, required this.url, super.key});

  /// Localized label.
  final String label;

  /// https URL.
  final String url;

  /// Opens a URL; replaced in tests.
  static Future<void> Function(Uri url) open = (url) async {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  };

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: () => open(Uri.parse(url)).ignore(),
    icon: const Icon(Icons.open_in_new, size: 18),
    label: Text(label),
  );
}
