import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:word_guess_game/app/widgets/confetti_overlay.dart';

void main() {
  testWidgets('confetti overlay renders ConfettiWidget', (
    WidgetTester tester,
  ) async {
    final controller = ConfettiController(
      duration: const Duration(milliseconds: 300),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConfettiOverlay(controller: controller),
        ),
      ),
    );

    expect(find.byType(ConfettiWidget), findsOneWidget);
  });
}
