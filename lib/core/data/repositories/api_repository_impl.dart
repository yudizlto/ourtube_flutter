import '../../../features/home/domain/entities/video_item_entity.dart';
import '../../../features/search/domain/entities/search_video_entity.dart';
import '../../domain/repositories/api_repository.dart';
import '../datasources/api_remote_data_source.dart';

class ApiRepositoryImpl implements ApiRepository {
  final ApiDataSource dataSource;

  ApiRepositoryImpl({required this.dataSource});

  /// Fetches search results based on the given [query]
  /// Returns a list of [SearchVideoEntity]
  @override
  Future<List<SearchVideoEntity>> getSearchResult(String query) async {
    return await dataSource.fetchSearchVideos(query);
  }

  /// Fetches a list of trending videos
  /// Returns a list of [VideoItemEntity]
  @override
  Future<List<VideoItemEntity>> getTrendingVideos() async {
    return await dataSource.fetchTrendingVideos();
  }

  /// Fetches videos by a specific category identified by [categoryId]
  /// Returns a list of [VideoItemEntity]
  @override
  Future<List<VideoItemEntity>> getVideosByCategory(String categoryId) async {
    return await dataSource.fetchVideosByCategory(categoryId);
  }
}
