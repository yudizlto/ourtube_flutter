import '../../../features/user/data/models/user_model.dart';
import '../../../features/video/data/models/video_model.dart';

abstract class FirebaseRepository {
  Future<VideoModel> fetchVideoData(String videoId);
  Future<UserModel> fetchUserData(String userId);
}
