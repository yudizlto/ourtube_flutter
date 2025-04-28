import '../../../../core/utils/helpers/shared_preferences_helper.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  /// Helper method to fetch the current user's ID from SharedPreferences
  Future<String?> _getUserId() async {
    return await SharedPreferencesHelper.getUserId();
  }

  /// Retrieves the current user's data as a stream
  @override
  Stream<UserModel> getCurrentUserData() async* {
    String? userId = await _getUserId();
    if (userId != null) {
      yield* dataSource.getUserDataStream(userId);
    }
    return;
  }

  /// Retrieves a list of all users except the current user
  @override
  Stream<List<UserModel>> getUsersListExceptCurrentUser() async* {
    String? userId = await _getUserId();
    yield* dataSource.getAllUsersExceptCurrentUser(userId!);
  }
}
