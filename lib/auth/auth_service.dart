import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  const AuthUser({required this.email, this.displayName});

  final String? email;
  final String? displayName;
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class AuthService {
  AuthUser? get currentUser;
  Stream<AuthUser?> get userChanges;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signIn({required String email, required String password});
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  AuthUser? _toAuthUser(User? user) => user == null
      ? null
      : AuthUser(email: user.email, displayName: user.displayName);

  @override
  AuthUser? get currentUser => _toAuthUser(_auth.currentUser);

  @override
  Stream<AuthUser?> get userChanges => _auth.userChanges().map(_toAuthUser);

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final UserCredential result;
    try {
      result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
    try {
      await result.user?.updateDisplayName(name);
    } on FirebaseException {
      // The account already exists; the home screen can show the email instead.
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo electrónico.';
      case 'weak-password':
        return 'Elige una contraseña más segura.';
      case 'invalid-email':
        return 'Escribe un correo electrónico válido.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Correo electrónico o contraseña incorrectos.';
      case 'too-many-requests':
        return 'Demasiados intentos. Inténtalo de nuevo más tarde.';
      case 'operation-not-allowed':
        return 'El acceso con correo electrónico no está habilitado en Firebase.';
      case 'network-request-failed':
        return 'Comprueba tu conexión a internet e inténtalo de nuevo.';
      default:
        return 'No se pudo completar la autenticación. Inténtalo de nuevo.';
    }
  }
}
