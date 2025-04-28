import '../../../video/data/models/video_model.dart';
import '../../data/models/history_model.dart';

abstract class HistoryRepository {
  Future<void> addToHistory(VideoModel video, String userId);
  Future<void> updateHistory(
      String videoId, String userId, int durationWatched);
  Future<List<HistoryModel>> getMyVideoHistory(
      String userId, bool sortByLatest);
  Future<void> removeFromWatchHistory(String historyId);
}
