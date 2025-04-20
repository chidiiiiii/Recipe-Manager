// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:model_flutter/main.dart'; // Make sure this matches your actual project path

void main() {
  testWidgets('Main menu loads with all buttons', (WidgetTester tester) async {
    // Build the RecipeApp and trigger a frame
    await tester.pumpWidget(RecipeApp());

    // Check that all main menu buttons are present
    expect(find.text('Add Recipe'), findsOneWidget);
    expect(find.text('View Recipes'), findsOneWidget);
    expect(find.text('Edit Recipes'), findsOneWidget);
    expect(find.text('Delete Recipes'), findsOneWidget);
  });
}
