import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slotly/main.dart';

class _TestHttpOverrides extends HttpOverrides {}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('Slotly App renders home screen header and title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SlotlyApp()));
    await tester.pumpAndSettle();

    // Verify Slotly App title and display header text
    final richTextFinder = find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText().contains('Book Appointments'),
    );

    expect(richTextFinder, findsOneWidget);
  });
}
