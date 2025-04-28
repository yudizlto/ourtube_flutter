import '../../domain/entities/search_video_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDataSource dataSource;

  SearchRepositoryImpl({required this.dataSource});

  /// Retrieves a list of videos based on the given search query.
  ///
  /// - [query]: The keyword used for searching videos.
  /// - Returns: A `Future` containing a list of `SearchVideoEntity`.
  /// - Calls `fetchSearchResult(query)` from the provided `SearchDataSource`.
  @override
  Future<List<SearchVideoEntity>> getVideosFromQuery(String query) async {
    return await dataSource.fetchSearchResult(query);
  }
}
