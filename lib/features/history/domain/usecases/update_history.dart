import '../repositories/history_repository.dart';

class UpdateHistoryUseCase {
  final HistoryRepository repository;

  UpdateHistoryUseCase(this.repository);

  Future<void> excute(
      String videoId, String userId, int durationWatched) async {
    await repository.updateHistory(videoId, userId, durationWatched);
  }
}
