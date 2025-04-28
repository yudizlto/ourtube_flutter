import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/helpers/path_helper.dart';

abstract class SupabaseVideoDataSource {
  Future<String> uploadVideo(File videoFile, String path);
  Future<String> uploadThumbnail(File imageFile, String path);
  Future<String> updateThumbnail(
      File imageFile, String videoId, String userId, String path);
  String getVideoUrl(String path);
  String getThumbnailUrl(String path);
  Future<void> deleteVideo(String videoId, String userId);
  Future<void> deleteThumbnail(String userId, String videoId);
}

class SupabaseVideoRemoteDataSource implements SupabaseVideoDataSource {
  final SupabaseClient _supabase;

  SupabaseVideoRemoteDataSource(this._supabase);

  /// Retrieves the public URL of a video stored in Supabase storage
  @override
  String getVideoUrl(String path) {
    return _supabase.storage.from("videos").getPublicUrl(path);
  }

  /// Retrieves the public URL of a thumbnail stored in Supabase storage
  @override
  String getThumbnailUrl(String path) {
    return _supabase.storage.from("images").getPublicUrl(path);
  }

  /// Uploads a video file to the specified path in Supabase storage
  @override
  Future<String> uploadVideo(File videoFile, String path) async {
    await _supabase.storage.from("videos").upload(path, videoFile);
    return getVideoUrl(path);
  }

  /// Uploads a thumbnail image file to the specified path in Supabase storage
  @override
  Future<String> uploadThumbnail(File imageFile, String path) async {
    await _supabase.storage.from("images").upload(path, imageFile);
    return getThumbnailUrl(path);
  }

  /// Updates the thumbnail for a video by deleting the existing thumbnail and uploading a new one
  @override
  Future<String> updateThumbnail(
      File imageFile, String videoId, String userId, String path) async {
    await deleteThumbnail(userId, videoId);
    final newThumbnailPath =
        PathHelper.generateVideoThumbnailPath(userId, videoId);
    return await uploadThumbnail(imageFile, newThumbnailPath);
  }

  /// Deletes a thumbnail from Supabase storage
  @override
  Future<void> deleteThumbnail(String userId, String videoId) async {
    final path = PathHelper.generateVideoThumbnailPath(userId, videoId);
    if (path.contains("-$videoId-$userId")) {
      await _supabase.storage.from("images").remove([path]);
    }
  }

  /// Deletes a video from Supabase storage
  @override
  Future<void> deleteVideo(String videoId, String userId) async {
    final path = PathHelper.generateUserLongVideoPath(videoId, userId);
    await _supabase.storage.from("videos").remove([path]);
  }
}
