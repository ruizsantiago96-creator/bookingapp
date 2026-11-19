import 'dart:async';

import 'package:bookingapp/auth/auth_service.dart';
import 'package:bookingapp/pages/home.dart';
import 'package:bookingapp/pages/hotel_detail.dart';
import 'package:bookingapp/pages/sign_in.dart';
import 'package:bookingapp/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthService implements AuthService {
  final _changes = StreamController<AuthUser?>.broadcast();
  AuthUser? _user;
  String? resetEmail;
  String? signInError;

  @override
  AuthUser? get currentUser => _user;

  @override
  Stream<AuthUser?> get userChanges async* {
    yield _user;
    yield* _changes.stream;
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _user = AuthUser(email: email, displayName: name);
    _changes.add(_user);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (signInError != null) throw AuthFailure(signInError!);
    _user = AuthUser(email: email, displayName: 'Traveler');
    _changes.add(_user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    resetEmail = email;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _changes.add(null);
  }

  Future<void> dispose() => _changes.close();
}

void main() {
  testWidgets('Guest can open hotel details and register', (tester) async {
    final auth = FakeAuthService();
    await tester.pumpWidget(MaterialApp(home: Home(authService: auth)));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    await tester.scrollUntilVisible(find.text('View hotel details'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('View hotel details'));
    await tester.pumpAndSettle();
    expect(find.byType(HotelDetail), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Create an account'), -200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUp), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Alex');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');
    await tester.ensureVisible(find.text('Create account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.byType(Home), findsOneWidget);
    expect(find.text('Welcome, Alex'), findsOneWidget);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsOneWidget);
    await auth.dispose();
  });

  testWidgets('Guest can sign in with email and password', (tester) async {
    final auth = FakeAuthService();
    await tester.pumpWidget(MaterialApp(home: Home(authService: auth)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.byType(SignIn), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'traveler@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Traveler'), findsOneWidget);
    await auth.dispose();
  });

  testWidgets('Sign-in shows errors and can request a password reset', (
    tester,
  ) async {
    final auth = FakeAuthService()
      ..signInError = 'Incorrect email or password.';
    await tester.pumpWidget(MaterialApp(home: Home(authService: auth)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Incorrect email or password.'), findsOneWidget);

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(auth.resetEmail, 'alex@example.com');
    expect(
      find.text('If this email has an account, a reset link was sent.'),
      findsOneWidget,
    );
    await auth.dispose();
  });
}
