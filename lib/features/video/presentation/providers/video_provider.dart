import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/datasources/firebase_remote_data_source.dart';
import '../../../user/data/models/user_model.dart';
import '../../data/datasources/firebase_video_data_source.dart';
import '../../data/datasources/supabase_video_data_source.dart';
import '../../data/models/video_model.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/usecases/video_usecases/delete_video.dart';
import '../../domain/usecases/video_usecases/get_user_details_by_video_id.dart';
import '../../domain/usecases/video_usecases/update_video_changes.dart';
import '../../domain/usecases/video_usecases/update_video_thumbnail.dart';
import '../../domain/usecases/video_usecases/update_video_views_count.dart';
import '../../domain/usecases/video_usecases/upload_thumbnail.dart';
import '../../domain/usecases/video_usecases/upload_video.dart';

// Provider for FirebaseFirestore instance
final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for SupabaseClient instance
final supabaseClientProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

// Provider for Firebase video datasource (handles Firebase-related video operations)
final videoDatasourceProvider = Provider<FirebaseVideoDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FirebaseVideoRemoteDatasource(firestore);
});

// Provider for Supabase video datasource (handles Supabase-related video operations)
final supabaseVideoDatasourceProvider =
    Provider<SupabaseVideoDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseVideoRemoteDataSource(supabase);
});

// Provider for firebase datasource
final firebaseDatasourceProvider = Provider<FirebaseDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FirebaseRemoteDataSource(firestore);
});

// Provider for VideoRepository (centralized data repository for videos)
final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  final videoDatasource = ref.watch(videoDatasourceProvider);
  final supabaseDatasource = ref.watch(supabaseVideoDatasourceProvider);
  final firebaseDatasource = ref.watch(firebaseDatasourceProvider);

  return VideoRepositoryImpl(
    videoDatasource: videoDatasource,
    supabaseDatasource: supabaseDatasource,
    firebaseDatasource: firebaseDatasource,
  );
});

// Provider for upload video use case (handles the video upload logic)
final uploadVideoUseCaseProvider = Provider((ref) {
  final repository = ref.read(videoRepositoryProvider);
  return UploadVideoUseCase(repository);
});

// Provider for update video changes use case
final updateVideoChangesUseCaseProvider = Provider((ref) {
  final repository = ref.read(videoRepositoryProvider);
  return UpdateVideoChangesUseCase(repository);
});

// Provider for upload video thumbnail
final uploadThumbnailUseCaseProvider = Provider((ref) {
  final repository = ref.read(videoRepositoryProvider);
  return UploadThumbnailUseCase(repository);
});

// Provider for update video thumbnail
final updateThumbnailUseCaseProvider = Provider((ref) {
  final repository = ref.read(videoRepositoryProvider);
  return UpdateThumbnailUseCase(repository);
});

// Provider for delete video
final deleteVideoUseCaseProvider = Provider((ref) {
  final repository = ref.read(videoRepositoryProvider);
  return DeleteVideoUseCase(repository);
});

// Provider for update video views count
final updateViewsCountUseCaseProvider = Provider((ref) {
  final repository = ref.read(videoRepositoryProvider);
  return UpdateVideoViewsCountUseCase(repository);
});

// Error providers to store validation or error messages for video title and description
final titleErrorProvider = StateProvider<String?>((ref) => null);
final descriptionErrorProvider = StateProvider<String?>((ref) => null);

// StateProvider for expanded description
final isExpandedDescriptionProvider = StateProvider<bool>((ref) => false);

// FutureProvider for getting user details based on videoId (fetches user info related to the video)
final getUserDetailsProvider =
    FutureProvider.family<UserModel?, String>((ref, videoId) async {
  final repository = ref.read(videoRepositoryProvider);
  return await GetUserDetailsByVideoIdUseCase(repository).execute(videoId);
});

final videoSuggestionsProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) async {
  final repository = ref.read(videoRepositoryProvider);
  return await repository.getVideoSuggestionList(userId);
});

final durationWatchedProvider = StateProvider<int>((ref) => 0);
