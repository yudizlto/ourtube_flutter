import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/user_remote_data_source.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/stream_user_profile.dart';

// Provider for FirebaseFirestore instance
final firebaseProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for user datasource
final userDatasourceProvider = Provider<UserDataSource>((ref) {
  final firestore = ref.watch(firebaseProvider);
  return UserRemoteDataSource(firestore);
});

// Provider untuk implementasi UserRepository
final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final dataSource = ref.watch(userDatasourceProvider);
  return UserRepositoryImpl(dataSource: dataSource);
});

// Provider untuk mendapatkan data user yang sedang aktif
final currentUserProvider = StreamProvider<UserModel>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return StreamUserProfile(userRepository).call();
});

final allUsersProvider = StreamProvider<List<UserModel>>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUsersListExceptCurrentUser();
});
