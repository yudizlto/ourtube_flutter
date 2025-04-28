import '../../../data/models/video_model.dart';
import '../../repositories/video_repository.dart';

class GetVideoSuggestionListUseCase {
  final VideoRepository repository;

  GetVideoSuggestionListUseCase(this.repository);

  Future<List<VideoModel>> call(String userId) {
    return repository.getVideoSuggestionList(userId);
  }
}
