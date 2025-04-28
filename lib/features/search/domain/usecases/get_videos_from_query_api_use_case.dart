import '../entities/search_video_entity.dart';
import '../repositories/search_repository.dart';

class GetVideosFromQueryApiUseCase {
  final SearchRepository repository;

  GetVideosFromQueryApiUseCase(this.repository);

  Future<List<SearchVideoEntity>> execute(String query) {
    return repository.getVideosFromQuery(query);
  }
}
