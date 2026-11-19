import 'package:bookingapp/main.dart';
import 'package:bookingapp/pages/home.dart';
import 'package:bookingapp/pages/hotel_detail.dart';
import 'package:bookingapp/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home opens the hotel details and sign-up shells', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    await tester.ensureVisible(find.text('View hotel details'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View hotel details'));
    await tester.pumpAndSettle();
    expect(find.byType(HotelDetail), findsOneWidget);
    expect(find.text('Booking available soon'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create an account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUp), findsOneWidget);
    expect(find.text('Sign up available soon'), findsOneWidget);
  });
}
