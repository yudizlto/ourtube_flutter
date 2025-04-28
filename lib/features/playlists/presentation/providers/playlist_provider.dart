import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../video/data/models/likes_model.dart';
import '../../data/datasources/playlist_remote_data_source.dart';
import '../../data/models/playlist_model.dart';
import '../../data/repositories/playlist_repository_impl.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../../domain/usecases/add_video_to_playlist.dart';
import '../../domain/usecases/create_playlist.dart';
import '../../domain/usecases/delete_playlist.dart';
import '../../domain/usecases/fetch_all_my_playlist.dart';
import '../../domain/usecases/fetch_my_likes.dart';
import '../../domain/usecases/remove_video_from_playlist.dart';

// Provider for FirebaseFirestore instance
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for Playlist datasource
final playlistRemoteDataSourceProvider = Provider<PlaylistDataSource>((ref) {
  final repository = ref.read(firestoreProvider);
  return PlaylistRemoteDataSource(repository);
});

// Provider for Playlist repository
final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  final dataSource = ref.watch(playlistRemoteDataSourceProvider);
  final firebaseDataSource = ref.watch(firebaseDataSourceProvider);
  return PlaylistRepositoryImpl(
      dataSource: dataSource, firebaseDataSource: firebaseDataSource);
});

// Provider for create playlist use case
final createPlaylistUseCaseProvider = Provider((ref) {
  final repository = ref.read(playlistRepositoryProvider);
  return CreatePlaylistUseCase(repository);
});

// Provider for fetch all my playlist use case
final fetchAllMyPlaylistProvider =
    FutureProvider.family<List<PlaylistModel>, String>((ref, userId) {
  final repository = ref.read(playlistRepositoryProvider);
  return FetchAllMyPlaylistUseCase(repository).execute(userId);
});

final fetchMyLikesProvider =
    FutureProvider.family<List<LikesModel>, String>((ref, userId) {
  final repository = ref.read(playlistRepositoryProvider);
  return FetchMyLikesUseCase(repository).execute(userId);
});

final deletePlaylistProvider = Provider((ref) {
  final repository = ref.read(playlistRepositoryProvider);
  return DeletePlaylistUseCase(repository);
});

final addVideoToPlaylistProvider = Provider((ref) {
  final repository = ref.read(playlistRepositoryProvider);
  return AddVideoToPlaylistUseCase(repository);
});

final removeVideoFromPlaylistProvider = Provider((ref) {
  final repository = ref.read(playlistRepositoryProvider);
  return RemoveVideoFromPlaylistUseCase(repository);
});
