import '../../data/models/user_model.dart';
import '../repositories/user_repository.dart';

class StreamUserProfile {
  final UserRepository repository;

  StreamUserProfile(this.repository);

  Stream<UserModel> call() {
    return repository.getCurrentUserData();
  }
}
