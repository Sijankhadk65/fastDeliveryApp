import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider {
  final _provider = FirebaseAuth.instance;

  Stream<FirebaseUser> get onAuthStateChanged => _provider.onAuthStateChanged;

  Future<AuthResult> login(String email, String password) {
    return _provider.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logOut() => _provider.signOut();
}
