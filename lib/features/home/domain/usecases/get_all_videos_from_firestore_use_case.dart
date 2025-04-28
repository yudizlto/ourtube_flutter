import '../../../video/data/models/video_model.dart';
import '../repositories/home_repository.dart';

class GetAllVideosFromFirestoreUseCase {
  final HomeRepository repository;

  GetAllVideosFromFirestoreUseCase(this.repository);

  Future<List<VideoModel>> execute() {
    return repository.getAllVideosSnapshot();
  }
}
