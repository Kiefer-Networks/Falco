// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const FalcoApp());
}

/// Root widget. Phase 0 only proves that the toolchain builds and runs on
/// Android and iOS; theme, routing and features arrive in later phases.
class FalcoApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Falco',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1113),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF2A33A),
          surface: Color(0xFF16191C),
          onSurface: Color(0xFFE8E6E1),
        ),
      ),
      home: const Scaffold(body: Center(child: Text('Falco'))),
    );
  }
}
