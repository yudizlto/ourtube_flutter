import '../entities/video_item_entity.dart';
import '../repositories/home_repository.dart';

class GetVideosTrendingUseCase {
  final HomeRepository repository;

  GetVideosTrendingUseCase(this.repository);

  Future<List<VideoItemEntity>> execute() {
    return repository.getTrendingVideos();
  }
}
