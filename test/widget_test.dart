// Basic Flutter widget test for SDUI app
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:server_driven_ui/main.dart';

void main() {
  testWidgets('SDUI app loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ServerDrivenUIApp());
    await tester.pump();

    // Verify that our app title is present
    expect(find.text('Server-Driven UI Demo'), findsOneWidget);
    
    // Verify the app builds without errors
    expect(tester.takeException(), isNull);
  });
}