import '../../../../core/data/datasources/api_remote_data_source.dart';
import '../../domain/entities/search_video_entity.dart';

abstract class SearchDataSource {
  Future<List<SearchVideoEntity>> fetchSearchResult(String query);
}

class SearchRemoteDataSource implements SearchDataSource {
  final ApiDataSource dataSource;

  SearchRemoteDataSource(this.dataSource);

  /// Fetches video search results by calling the API data source.
  ///
  /// - [query]: The search term used to query the API.
  /// - Returns: A `Future` containing a list of `SearchVideoEntity`.
  /// - Delegates the API request to `dataSource.fetchSearchVideos(query)`.
  @override
  Future<List<SearchVideoEntity>> fetchSearchResult(String query) async {
    return await dataSource.fetchSearchVideos(query);
  }
}
