import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_09/counter_page.dart';

void main() {
  group("CounterPage", () {
    testWidgets('shows Count: 0 at the start', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CounterPage()));

      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets("shows Count: 1 after tapping the add button", (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CounterPage()));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text("Count: 1"), findsOneWidget);
    });

    testWidgets('shows Count: -1 after tapping the remove button', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CounterPage()));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('Count: -1'), findsOneWidget);
    });
  });
}
