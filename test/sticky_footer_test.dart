import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sticky_footer/sticky_footer.dart';

void main() {
  testWidgets(
      'pins the footer to the bottom of the viewport when content is short',
      (tester) async {
    const footerKey = Key('footer');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StickyFooter(
            footer: SizedBox(height: 40, key: footerKey),
            children: [SizedBox(height: 50)],
          ),
        ),
      ),
    );

    final viewportHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final footerBottom = tester.getBottomLeft(find.byKey(footerKey)).dy;
    expect(footerBottom, closeTo(viewportHeight, 0.5));
  });

  testWidgets(
      'lets the footer scroll away from the bottom when content overflows',
      (tester) async {
    const footerKey = Key('footer');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StickyFooter(
            footer: const SizedBox(height: 40, key: footerKey),
            children: [for (var i = 0; i < 40; i++) const SizedBox(height: 60)],
          ),
        ),
      ),
    );

    final viewportHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final footerBottomBeforeScroll =
        tester.getBottomLeft(find.byKey(footerKey)).dy;
    // With overflowing content the footer sits well past the viewport instead
    // of being pinned to it.
    expect(footerBottomBeforeScroll, greaterThan(viewportHeight));

    await tester.dragUntilVisible(
      find.byKey(footerKey),
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(footerKey), findsOneWidget);
  });
}
