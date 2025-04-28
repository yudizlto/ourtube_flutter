import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseChannelDataSource {
  Future<void> deleteFileIfExist(String userId, String path);
  Future<String> uploadBanner(File imageFile, String path);
  Future<String> uploadPhoto(File imageFile, String path);
  String getPhotoUrl(String path);
  String getBannerUrl(String path);
}

class SupabaseChannelRemoteDataSource implements SupabaseChannelDataSource {
  final SupabaseClient supabase;

  SupabaseChannelRemoteDataSource(this.supabase);

  /// Retrieves the public URL of the banner stored in Supabase storage
  @override
  String getBannerUrl(String path) {
    return supabase.storage.from("images").getPublicUrl(path);
  }

  /// Retrieves the public URL of the photo stored in Supabase storage
  @override
  String getPhotoUrl(String path) {
    return supabase.storage.from("images").getPublicUrl(path);
  }

  /// Uploads a banner image to Supabase storage
  @override
  Future<String> uploadBanner(File imageFile, String path) async {
    await supabase.storage.from("images").upload(path, imageFile);
    return getBannerUrl(path);
  }

  /// Uploads a photo to Supabase storage
  @override
  Future<String> uploadPhoto(File imageFile, String path) async {
    await supabase.storage.from("images").upload(path, imageFile);
    return getPhotoUrl(path);
  }

  /// Deletes a file from Supabase storage if it exists and the path contains the user ID
  @override
  Future<void> deleteFileIfExist(String userId, String path) async {
    if (path.contains("-$userId")) {
      await Supabase.instance.client.storage.from("images").remove([path]);
    }
  }
}
