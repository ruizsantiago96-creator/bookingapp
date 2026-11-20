import 'package:flutter/material.dart';

import '../pages/home.dart';
import '../pages/sign_in.dart';
import '../pages/sign_up.dart';
import 'auth_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, this.authService});

  final AuthService? authService;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final AuthService _auth;
  late final Stream<AuthUser?> _userChanges;
  bool _showSignUp = false;

  @override
  void initState() {
    super.initState();
    _auth = widget.authService ?? FirebaseAuthService();
    _userChanges = _auth.userChanges;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: _userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('No se pudo comprobar la sesión.')),
          );
        }
        if (snapshot.data != null) {
          _showSignUp = false;
          return Navigator(
            key: const ValueKey('authenticated-navigation'),
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => Home(authService: _auth),
            ),
          );
        }
        return _showSignUp
            ? SignUp(
                authService: _auth,
                onShowSignIn: () => setState(() => _showSignUp = false),
              )
            : SignIn(
                authService: _auth,
                onShowSignUp: () => setState(() => _showSignUp = true),
              );
      },
    );
  }
}
