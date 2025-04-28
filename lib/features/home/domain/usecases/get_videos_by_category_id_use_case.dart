import '../entities/video_item_entity.dart';
import '../repositories/home_repository.dart';

class GetVideosByCategoryIdUseCase {
  final HomeRepository repository;

  GetVideosByCategoryIdUseCase(this.repository);

  Future<List<VideoItemEntity>> execute(String categoryId) {
    return repository.getVideosByCategory(categoryId);
  }
}
