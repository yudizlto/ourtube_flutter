import '../../../user/data/models/user_model.dart';
import '../../../video/data/models/video_model.dart';
import '../entities/video_item_entity.dart';

abstract class HomeRepository {
  Future<List<VideoItemEntity>> getTrendingVideos();
  Future<List<VideoItemEntity>> getVideosByCategory(String categoryId);
  Future<List<VideoModel>> getAllVideosSnapshot();
  Future<List<VideoModel>> getShortsVideoSnapshot();
  Future<UserModel> getUserDetailsByVideoId(String userId);
}
