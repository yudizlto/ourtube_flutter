import '../../../../user/data/models/user_model.dart';
import '../../repositories/video_repository.dart';

class GetUserDetailsByVideoIdUseCase {
  final VideoRepository repository;

  GetUserDetailsByVideoIdUseCase(this.repository);

  Future<UserModel?> execute(String videoId) async {
    final userData = await repository.getUserDetailsByVideoId(videoId);
    return userData;
  }
}
