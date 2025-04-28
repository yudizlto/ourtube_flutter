import 'dart:io';

import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/video_type.dart';
import '../../../../core/utils/helpers/path_helper.dart';
import '../../../../core/utils/helpers/shared_preferences_helper.dart';
import '../../../video/data/models/video_model.dart';
import '../../domain/repositories/channel_repository.dart';
import '../datasources/channel_remote_data_source.dart';
import '../datasources/supabase_channel_remote_data_source.dart';

class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelDataSource dataSource;
  final SupabaseChannelDataSource supabaseDataSource;

  ChannelRepositoryImpl({
    required this.dataSource,
    required this.supabaseDataSource,
  });

  /// Helper method to retrieve the user ID from shared preferences
  Future<String?> _getUserId() async {
    return await SharedPreferencesHelper.getUserId();
  }

  /// Retrieves a list of videos uploaded by a specific user from the data source
  @override
  Future<List<VideoModel>> getVideosByUserId(
      String userId, bool sortByLatest) async {
    return await dataSource.getVideosByUserId(userId, sortByLatest);
  }

  /// Retrieves a list of shorts uploaded by a specific user from the data source
  @override
  Future<List<VideoModel>> getShortsByUserId(String userId, bool sortByLatest,
      {VideoType? videoType}) async {
    return await dataSource.getVideosByUserId(userId, sortByLatest,
        videoType: AppStrings.shorts);
  }

  @override
  Future<List<VideoModel>> getOtherChannelShorts(
      String userId, bool sortByLatest,
      {VideoType? videoType}) async {
    return await dataSource.getVideosByUserId(
      userId,
      sortByLatest,
      videoType: AppStrings.shorts,
      isPrivate: false,
    );
  }

  @override
  Future<List<VideoModel>> getOtherChannelLongVideos(
      String userId, bool sortByLatest,
      {VideoType? videoType}) async {
    return await dataSource.getVideosByUserId(
      userId,
      sortByLatest,
      videoType: AppStrings.long,
      isPrivate: false,
    );
  }

  /// Retrieves a list of long videos uploaded by a specific user from the data source
  @override
  Future<List<VideoModel>> getLongByUserId(String userId, bool sortByLatest,
      {VideoType? videoType}) async {
    return await dataSource.getVideosByUserId(userId, sortByLatest,
        videoType: AppStrings.long);
  }

  /// Saves the user's banner URL by updating the bannerUrl field in the user data
  @override
  Future<void> saveUserBanner(String bannerUrl) async {
    await updateUserDataField("bannerUrl", bannerUrl);
  }

  /// Saves the user's photo URL by updating the photoUrl field in the user data
  @override
  Future<void> saveUserPhoto(String photoUrl) async {
    await updateUserDataField("photoUrl", photoUrl);
  }

  // Updates a specific field in the user's data in Firestore
  /// Parameters:
  /// - field: The field name to be updated.
  /// - value: The new value to be set for the field.
  @override
  Future<void> updateUserDataField(String field, value) async {
    String? userId = await _getUserId();
    await dataSource.updateUserField(userId!, field, value);
  }

  /// Uploads a new photo profile for the user to Supabase storage
  @override
  Future<void> uploadPhotoProfile(File imageFile) async {
    String? userId = await SharedPreferencesHelper.getUserId();
    final imagePath = PathHelper.generateUserImagePath(userId!);

    /// Delete the existing photo if any and upload the new photo
    await supabaseDataSource.deleteFileIfExist(userId, imagePath);
    await supabaseDataSource.uploadPhoto(imageFile, imagePath);

    final imageUrl = supabaseDataSource.getPhotoUrl(imagePath);

    /// Get the public URL of the uploaded photo and save it to the user's profile
    await saveUserPhoto(imageUrl);
  }

  /// Uploads a new banner image for the user to Supabase storage
  @override
  Future<void> uploadBanner(File imageFile) async {
    String? userId = await SharedPreferencesHelper.getUserId();
    final imagePath = PathHelper.generateUserBannerPath(userId!);

    /// Delete the existing banner if any and upload the new banner
    await supabaseDataSource.deleteFileIfExist(userId, imagePath);
    await supabaseDataSource.uploadBanner(imageFile, imagePath);

    final bannerUrl = supabaseDataSource.getBannerUrl(imagePath);

    /// Get the public URL of the uploaded banner and save it to the user's profile
    await saveUserBanner(bannerUrl);
  }
}
