import '../../../video/data/models/video_model.dart';
import '../repositories/home_repository.dart';

class GetShortsFromFirestoreUseCase {
  final HomeRepository repository;

  GetShortsFromFirestoreUseCase(this.repository);

  Future<List<VideoModel>> execute() {
    return repository.getShortsVideoSnapshot();
  }
}
