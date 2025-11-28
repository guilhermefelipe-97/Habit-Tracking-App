import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> register(
      String email,
      String password,
      String displayName,
      ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(displayName);
    return cred.user;
  }

  Future<User?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-logged-in',
        message: 'Nenhum usuário logado.',
      );
    }

    // Se você quiser reforçar com senha:
    // final cred = EmailAuthProvider.credential(
    //   email: user.email!,
    //   password: password,
    // );
    // await user.reauthenticateWithCredential(cred);

    await user.delete();
  }
}