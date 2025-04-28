import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/datasources/firebase_remote_data_source.dart';
import '../../../../core/utils/helpers/path_helper.dart';
import '../../../user/data/models/user_model.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/firebase_video_data_source.dart';
import '../datasources/supabase_video_data_source.dart';
import '../models/video_model.dart';

class VideoRepositoryImpl implements VideoRepository {
  final FirebaseVideoDataSource videoDatasource;
  final SupabaseVideoDataSource supabaseDatasource;
  final FirebaseDataSource firebaseDatasource;

  VideoRepositoryImpl({
    required this.videoDatasource,
    required this.supabaseDatasource,
    required this.firebaseDatasource,
  });

  /// Uploads a video along with its metadata to Firestore and Supabase
  @override
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
      {File? thumbnailFile}) async {
    /// Generate video and thumbnail file paths
    final videoPath = videoType == "Long"
        ? PathHelper.generateUserLongVideoPath(videoId, userId)
        : PathHelper.generateUserShortVideoPath(videoId, userId);

    /// Variable to store the URL of the uploaded thumbnail.
    /// Initially set to null, meaning no thumbnail is uploaded by default.
    String? thumbnailUrl;

    /// If a thumbnail file is provided, generate its storage path and upload it.
    /// The generated path is based on the user ID and video ID.
    if (videoType == "Long" && thumbnailFile != null) {
      final thumbnailPath =
          PathHelper.generateVideoThumbnailPath(userId, videoId);

      /// Upload the thumbnail to Supabase storage and retrieve its URL.
      thumbnailUrl = await supabaseDatasource.uploadThumbnail(
          thumbnailFile, thumbnailPath);
    }

    final videoUrl = await supabaseDatasource.uploadVideo(videoFile, videoPath);

    /// Create video metadata model
    final videoModel = VideoModel(
      videoId: videoId,
      userId: userId,
      title: title,
      description: desc,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl ?? "",
      visibilityType: visibility,
      type: videoType,
      tags: [],
      likesCount: 0,
      dislikesCount: 0,
      viewsCount: 0,
      duration: duration,
      commentsEnabled: isCommentsEnabled,
      commentsCount: 0,
      audienceRestricted: isAudienceRestricted,
      ageRestricted: isAgeRestricted,
      uploadedAt: DateTime.now(),
    );

    /// Save metadata to Firestore
    await videoDatasource.addVideoToFirestore(videoModel);

    /// Update the user's "videos" field in Firestore
    await firebaseDatasource.updateUserField(
        userId, "videos", FieldValue.arrayUnion([videoId]));
  }

  /// Retrieves user details associated with a specific [videoId]
  @override
  Future<UserModel?> getUserDetailsByVideoId(String videoId) async {
    return await videoDatasource.getUserDetailsByVideoId(videoId);
  }

  /// Uploads a video thumbnail image
  @override
  Future<void> uploadThumbnail(
      File? imageFile, String userId, String videoId) async {
    final path = PathHelper.generateVideoThumbnailPath(userId, videoId);
    if (imageFile == null) return;
    await supabaseDatasource.updateThumbnail(imageFile, videoId, userId, path);
  }

  /// Retrieves a list of video suggestions for a specific user
  @override
  Future<List<VideoModel>> getVideoSuggestionList(String userId) {
    return videoDatasource.getVideoSuggestions(userId);
  }

  /// Deletes a video from Firestore and updates the user's "videos" field
  @override
  Future<void> deleteVideo(String videoId, String userId) async {
    /// Delete the video file and thumbnail from Supabase
    await supabaseDatasource.deleteThumbnail(userId, videoId);
    await supabaseDatasource.deleteVideo(videoId, userId);

    /// Delete the video document from the "videos" collection
    await videoDatasource.deleteVideoFromFirestore(videoId);

    /// Remove the videoId from the user's "videos" field
    await firebaseDatasource.updateUserField(
        userId, "videos", FieldValue.arrayRemove([videoId]));
  }

  /// Updates the metadata of an existing video in Firestore
  @override
  Future<void> updateVideo(
    String videoId,
    String title,
    String desc,
    String visibility,
    bool isCommentsEnabled,
    bool isAgeRestricted,
    bool isAudienceRestricted,
  ) async {
    final videoUpdateData = {
      "title": title,
      "description": desc,
      "visibilityType": visibility,
      "commentsEnabled": isCommentsEnabled,
      "ageRestricted": isAgeRestricted,
      "audienceRestricted": isAudienceRestricted,
    };

    /// Updates specific fields in an existing video document in Firestore
    await videoDatasource.updateVideoChangesToFirestore(
        videoId, videoUpdateData);
  }

  /// Updates the thumbnail of an existing video in Supabase
  @override
  Future<void> updateThumbnail(
      File imageFile, String userId, String videoId) async {
    final path = PathHelper.generateVideoThumbnailPath(userId, videoId);
    await supabaseDatasource.updateThumbnail(imageFile, videoId, userId, path);
  }

  /// Increments the view count for a specific video
  @override
  Future<void> incrementViewCount(VideoModel video) async {
    /// Update the views count of the video
    final updateViewsCount = video.viewsCount + 1;
    await videoDatasource.updateVideoViewCount(video, updateViewsCount);
  }
}
