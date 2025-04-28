import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> getGoogleCredential();
  Future<void> signUpWithGoogle();
  Future<void> signInWithGoogle();
  Future<void> signOut();
}
