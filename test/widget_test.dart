// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts and shows its name', (tester) async {
    await tester.pumpWidget(const FalcoApp());
    expect(find.text('Falco'), findsOneWidget);
  });
}
