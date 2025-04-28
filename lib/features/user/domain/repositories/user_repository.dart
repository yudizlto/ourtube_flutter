import '../../data/models/user_model.dart';

abstract class UserRepository {
  Stream<UserModel> getCurrentUserData();
  Stream<List<UserModel>> getUsersListExceptCurrentUser();
}
