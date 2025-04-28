import '../../../features/home/domain/entities/video_item_entity.dart';
import '../../../features/search/domain/entities/search_video_entity.dart';

abstract class ApiRepository {
  Future<List<SearchVideoEntity>> getSearchResult(String query);
  Future<List<VideoItemEntity>> getTrendingVideos();
  Future<List<VideoItemEntity>> getVideosByCategory(String categoryId);
}
