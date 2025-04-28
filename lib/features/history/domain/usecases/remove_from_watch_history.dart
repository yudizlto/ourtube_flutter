import '../repositories/history_repository.dart';

class RemoveFromWatchHistoryUseCase {
  final HistoryRepository repository;

  RemoveFromWatchHistoryUseCase(this.repository);

  Future<void> execute(String historyId) async {
    await repository.removeFromWatchHistory(historyId);
  }
}
