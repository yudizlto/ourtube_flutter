import '../../../user/data/models/user_model.dart';
import '../../data/models/video_model.dart';

abstract class LikesRepository {
  Future<void> addLikes(VideoModel video, UserModel user);
  Future<void> unLikes(VideoModel video, UserModel user);
  Stream<bool> isLikedByUser(String videoId, String userId);
}
