import 'dart:io';

import '../../../user/data/models/user_model.dart';
import '../../data/models/video_model.dart';

abstract class VideoRepository {
  Future<void> uploadVideo(
      File videoFile,
      String videoId,
      String userId,
      String title,
      String desc,
      String visibility,
      bool isCommentsEnabled,
      bool isAgeRestricted,
      bool isAudienceRestricted,
      int duration,
      String videoType,
      {File? thumbnailFile});
  Future<void> updateVideo(
      String videoId,
      String title,
      String desc,
      String visibility,
      bool isCommentsEnabled,
      bool isAgeRestricted,
      bool isAudienceRestricted);
  Future<void> uploadThumbnail(File? imageFile, String userId, String videoId);
  Future<void> updateThumbnail(File imageFile, String userId, String videoId);
  Future<void> deleteVideo(String videoId, String userId);
  Future<UserModel?> getUserDetailsByVideoId(String videoId);
  Future<List<VideoModel>> getVideoSuggestionList(String userId);
  Future<void> incrementViewCount(VideoModel video);
}
