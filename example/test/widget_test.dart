import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sticky_footer_example/main.dart';

void main() {
  testWidgets('demo starts with 3 items and can add more', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('Item 3'), findsOneWidget);
    expect(find.text('Item 4'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Item 4'), findsOneWidget);
  });
}
