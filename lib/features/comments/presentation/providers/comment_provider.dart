import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user/data/models/user_model.dart';
import '../../../video/presentation/providers/video_provider.dart';
import '../../data/datasources/comment_remote_data_source.dart';
import '../../data/models/comment_model.dart';
import '../../data/repositories/comment_repository_impl.dart';
import '../../domain/repositories/comment_repository.dart';
import '../../domain/usecases/create_comment_use_case.dart';
import '../../domain/usecases/delete_comment_use_case.dart';
import '../../domain/usecases/get_user_details_by_comment_id.dart';

// Provider for FirebaseFirestore instance
final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for Comment datasource
final commentRemoteDataSourcePRovider = Provider<CommentDataSource>((ref) {
  final repository = ref.watch(firebaseFirestoreProvider);
  return CommentRemoteDataSource(repository);
});

// Provider for CommentRepository
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final dataSource = ref.watch(commentRemoteDataSourcePRovider);
  final firebaseVideoDataSource = ref.watch(videoDatasourceProvider);
  return CommentRepositoryImpl(
      dataSource: dataSource, firebaseVideoDatasource: firebaseVideoDataSource);
});

// Provider for create comment use case
final createCommentUseCaseProvider = Provider((ref) {
  final repository = ref.read(commentRepositoryProvider);
  return CreateCommentUseCase(repository);
});

// Provider for delete comment use case
final deleteCommentUseCaseProvider = Provider((ref) {
  final repository = ref.read(commentRepositoryProvider);
  return DeleteCommentUseCase(repository);
});

final commentListStreamProvider = StreamProvider.autoDispose
    .family<List<CommentModel>, String>((ref, videoId) {
  final repository = ref.watch(commentRepositoryProvider);
  return repository.getCommentList(videoId);
});

final getUserDetailsProvider =
    FutureProvider.family<UserModel?, String>((ref, commentId) async {
  final repository = ref.read(commentRepositoryProvider);
  return await GetUserDetailsByCommentIdUseCase(repository).execute(commentId);
});

// StateProvider for expanded comment
final isExpandedCommentProvider = StateProvider<bool>((ref) => false);
