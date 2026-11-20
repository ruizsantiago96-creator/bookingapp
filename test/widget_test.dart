import 'dart:async';

import 'package:bookingapp/auth/auth_gate.dart';
import 'package:bookingapp/auth/auth_service.dart';
import 'package:bookingapp/pages/home.dart';
import 'package:bookingapp/pages/hotel_detail.dart';
import 'package:bookingapp/pages/sign_in.dart';
import 'package:bookingapp/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthService implements AuthService {
  FakeAuthService({AuthUser? initialUser}) : _user = initialUser;

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
    _user = AuthUser(email: email, displayName: 'Viajero');
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
  testWidgets('Registration unlocks home and hotel details', (tester) async {
    final auth = FakeAuthService();
    await tester.pumpWidget(MaterialApp(home: AuthGate(authService: auth)));
    await tester.pumpAndSettle();

    expect(find.byType(SignIn), findsOneWidget);
    expect(find.byType(Home), findsNothing);
    expect(find.byType(HotelDetail), findsNothing);

    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUp), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Alex');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');
    await tester.ensureVisible(find.text('Crear cuenta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(SignUp), findsNothing);
    expect(find.text('Te damos la bienvenida, Alex'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Un lugar para sentirte en casa'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Un lugar para sentirte en casa'));
    await tester.pumpAndSettle();
    expect(find.byType(HotelDetail), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Cerrar sesión'), -200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.byType(SignIn), findsOneWidget);
    expect(find.byType(Home), findsNothing);
    await auth.dispose();
  });

  testWidgets('Login unlocks home and logout locks it again', (tester) async {
    final auth = FakeAuthService();
    await tester.pumpWidget(MaterialApp(home: AuthGate(authService: auth)));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Iniciar sesión'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.byType(Home), findsOneWidget);
    expect(find.text('Te damos la bienvenida, Viajero'), findsOneWidget);
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.byType(SignIn), findsOneWidget);
    expect(find.byType(Home), findsNothing);
    await auth.dispose();
  });

  testWidgets('Existing session opens home directly', (tester) async {
    final auth = FakeAuthService(
      initialUser: const AuthUser(
        email: 'alex@example.com',
        displayName: 'Alex',
      ),
    );
    await tester.pumpWidget(MaterialApp(home: AuthGate(authService: auth)));
    await tester.pumpAndSettle();

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(SignIn), findsNothing);
    await auth.dispose();
  });

  testWidgets('Sign-in error keeps home locked and reset remains available', (
    tester,
  ) async {
    final auth = FakeAuthService()
      ..signInError = 'Correo electrónico o contraseña incorrectos.';
    await tester.pumpWidget(MaterialApp(home: AuthGate(authService: auth)));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Iniciar sesión'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();
    expect(
      find.text('Correo electrónico o contraseña incorrectos.'),
      findsOneWidget,
    );
    expect(find.byType(Home), findsNothing);

    await tester.tap(find.text('¿Olvidaste tu contraseña?'));
    await tester.pumpAndSettle();
    expect(auth.resetEmail, 'alex@example.com');
    expect(
      find.text(
        'Si existe una cuenta con este correo, se envió un enlace para restablecer la contraseña.',
      ),
      findsOneWidget,
    );
    await auth.dispose();
  });

  testWidgets('An expired session closes an open hotel detail', (tester) async {
    final auth = FakeAuthService(
      initialUser: const AuthUser(
        email: 'alex@example.com',
        displayName: 'Alex',
      ),
    );
    await tester.pumpWidget(MaterialApp(home: AuthGate(authService: auth)));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Ver detalles del hotel'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver detalles del hotel'));
    await tester.pumpAndSettle();
    expect(find.byType(HotelDetail), findsOneWidget);

    await auth.signOut();
    await tester.pumpAndSettle();
    expect(find.byType(SignIn), findsOneWidget);
    expect(find.byType(HotelDetail), findsNothing);
    await auth.dispose();
  });
}
