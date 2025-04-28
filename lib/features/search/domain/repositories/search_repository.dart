import '../entities/search_video_entity.dart';

abstract class SearchRepository {
  Future<List<SearchVideoEntity>> getVideosFromQuery(String query);
}
