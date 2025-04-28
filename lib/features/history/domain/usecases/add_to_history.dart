import '../../../video/data/models/video_model.dart';
import '../repositories/history_repository.dart';

class AddToHistoryUseCase {
  final HistoryRepository repository;

  AddToHistoryUseCase(this.repository);

  Future<void> excute(VideoModel video, String userId) async {
    await repository.addToHistory(video, userId);
  }
}
