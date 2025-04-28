import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/history_remote_data_source.dart';
import '../../data/models/history_model.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/add_to_history.dart';
import '../../domain/usecases/get_my_video_history.dart';
import '../../domain/usecases/remove_from_watch_history.dart';
import '../../domain/usecases/update_history.dart';

// Provider for FirebaseFirestore instance
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for History datasource
final historyRemoteDataSourceProvider = Provider<HistoryDataSource>((ref) {
  final repository = ref.watch(firestoreProvider);
  return HistoryRemoteDataSource(repository);
});

// Provider for History Repository
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final dataSource = ref.watch(historyRemoteDataSourceProvider);
  return HistoryRepositoryImpl(dataSource: dataSource);
});

// Provider for add video to history use case
final addToHistoryUseCaseProvider = Provider((ref) {
  final repository = ref.read(historyRepositoryProvider);
  return AddToHistoryUseCase(repository);
});

// Provider for update history use case
final updateHistoryUseCaseProvider = Provider((ref) {
  final repository = ref.read(historyRepositoryProvider);
  return UpdateHistoryUseCase(repository);
});

// Provider for remove video from watch history
final removeFromWatchHistoryProvider = Provider((ref) {
  final repository = ref.read(historyRepositoryProvider);
  return RemoveFromWatchHistoryUseCase(repository);
});

final myLatestVideoHistoryProvider =
    FutureProvider.family<List<HistoryModel>, String>((ref, userId) {
  final repository = ref.read(historyRepositoryProvider);
  return GetMyVideoHistoryUseCase(repository).execute(userId, true);
});
