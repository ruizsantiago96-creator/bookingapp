// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookingapp/main.dart';
import 'package:bookingapp/pages/home.dart';

void main() {
  testWidgets('La pantalla inicial muestra la imagen del hotel',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
