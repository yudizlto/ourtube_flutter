import '../repositories/auth_repository.dart';

class SignUpWithGoogle {
  final AuthRepository repository;

  SignUpWithGoogle(this.repository);

  Future<void> call() async {
    await repository.signUpWithGoogle();
  }
}
