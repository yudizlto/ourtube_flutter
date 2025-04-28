import 'package:uuid/uuid.dart';

import '../../../video/data/models/video_model.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';
import '../models/history_model.dart';

class HistoryRepositoryImpl extends HistoryRepository {
  final HistoryDataSource dataSource;

  HistoryRepositoryImpl({required this.dataSource});

  /// Adds a video to the user's history.
  /// If the video does not already exist in the history, it creates a new record
  @override
  Future<void> addToHistory(VideoModel video, String userId) async {
    /// Check if the video already exists in the user's history
    final existingHistory =
        await dataSource.findExistingHistoryDoc(userId, video.videoId);

    if (existingHistory == null) {
      final historyId = const Uuid().v4();
      final historyModel = HistoryModel(
        historyId: historyId,
        userId: userId,
        videoId: video.videoId,
        watchedAt: DateTime.now(),
        durationWatched: 0,
        isCompleted: false,
      );

      /// Add the new history record to Firestore
      await dataSource.addHistoryToFirestore(historyModel);
    }
  }

  /// Updates an existing history record with new watch details.
  /// Updates the "watchedAt" timestamp, "durationWatched", and sets "isCompleted"
  @override
  Future<void> updateHistory(
      String videoId, String userId, int durationWatched) async {
    final existingHistory =
        await dataSource.findExistingHistoryDoc(userId, videoId);
    await dataSource.updateHistoryData(existingHistory!.historyId, {
      "watchedAt": DateTime.now(),
      "durationWatched": durationWatched,
      "isCompleted": false,
    });
  }

  /// Retrieves the user's video history, optionally sorted by the latest watched timestamp
  @override
  Future<List<HistoryModel>> getMyVideoHistory(
      String userId, bool sortByLatest) async {
    return await dataSource.getMyVideoHistory(userId, sortByLatest);
  }

  /// Removes a history record from Firestore
  @override
  Future<void> removeFromWatchHistory(String historyId) async {
    await dataSource.deleteHistoryFromFirestore(historyId);
  }
}
