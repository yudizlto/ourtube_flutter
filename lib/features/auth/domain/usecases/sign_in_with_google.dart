import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<void> execute() async {
    await repository.signInWithGoogle();
  }
}
