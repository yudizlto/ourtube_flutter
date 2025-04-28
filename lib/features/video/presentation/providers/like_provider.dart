import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../data/datasources/likes_remote_data_source.dart';
import '../../data/repositories/likes_repository_impl.dart';
import '../../domain/repositories/likes_repository.dart';
import '../../domain/usecases/like_usecases/add_like_video.dart';
import '../../domain/usecases/like_usecases/like_status.dart';
import '../../domain/usecases/like_usecases/un_like_video.dart';

final likeRemoteDataSourceProvider = Provider<LikesDataSource>((ref) {
  final repository = ref.watch(firestoreProvider);
  return LikesRemoteDataSource(repository);
});

final likeRepositoryProvider = Provider<LikesRepository>((ref) {
  final dataSource = ref.watch(likeRemoteDataSourceProvider);
  final firebaseDataSource = ref.watch(firebaseDataSourceProvider);
  return LikesRepositoryImpl(
    dataSource: dataSource,
    firebaseDataSource: firebaseDataSource,
  );
});

final addLikeVideoProvider = Provider((ref) {
  final repository = ref.read(likeRepositoryProvider);
  return AddLikeVideoUseCase(repository);
});

final unLikeVideoProvider = Provider((ref) {
  final repository = ref.read(likeRepositoryProvider);
  return UnLikeVideoUseCase(repository);
});

final likeStatusStreamProvider =
    StreamProvider.autoDispose.family<bool, String>((ref, videoId) {
  final repository = ref.watch(likeRepositoryProvider);
  final userIdRef = ref.read(currentUserProvider).value!.userId;
  return LikeStatusUseCase(repository).execute(videoId, userIdRef);
});
