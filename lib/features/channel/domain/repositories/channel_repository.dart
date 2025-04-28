import 'dart:io';

import '../../../../core/utils/constants/enums/video_type.dart';
import '../../../video/data/models/video_model.dart';

abstract class ChannelRepository {
  Future<List<VideoModel>> getVideosByUserId(String userId, bool sortByLatest);
  Future<List<VideoModel>> getLongByUserId(String userId, bool sortByLatest,
      {VideoType? videoType});
  Future<List<VideoModel>> getOtherChannelLongVideos(
      String userId, bool sortByLatest,
      {VideoType? videoType});
  Future<List<VideoModel>> getShortsByUserId(String userId, bool sortByLatest,
      {VideoType? videoType});
  Future<List<VideoModel>> getOtherChannelShorts(
      String userId, bool sortByLatest,
      {VideoType? videoType});
  Future<void> uploadPhotoProfile(File imageFile);
  Future<void> uploadBanner(File imageFile);
  Future<void> updateUserDataField(String field, dynamic value);
  Future<void> saveUserPhoto(String photoUrl);
  Future<void> saveUserBanner(String bannerUrl);
}
