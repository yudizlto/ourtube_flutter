import '../../../data/models/video_model.dart';
import '../../repositories/video_repository.dart';

class UpdateVideoViewsCountUseCase {
  final VideoRepository repository;

  UpdateVideoViewsCountUseCase(this.repository);

  Future<void> execute(VideoModel video) async {
    return repository.incrementViewCount(video);
  }
}
