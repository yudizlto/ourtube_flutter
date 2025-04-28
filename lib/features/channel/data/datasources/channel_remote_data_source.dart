import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/constants/app_strings.dart';
import '../../../video/data/models/video_model.dart';

abstract class ChannelDataSource {
  Future<List<VideoModel>> getVideosByUserId(String userId, bool sortByLatest,
      {String? videoType, bool? isPrivate});
  Future<void> updateUserField(String userId, String field, dynamic value);
}

class ChannelRemoteDataSource implements ChannelDataSource {
  final FirebaseFirestore _firestore;

  ChannelRemoteDataSource(this._firestore);

  /// Fetches the list of videos by user ID and sorts them by upload date if specified
  @override
  Future<List<VideoModel>> getVideosByUserId(
    String userId,
    bool sortByLatest, {
    String? videoType,
    bool? isPrivate,
  }) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection("videos").where("userId", isEqualTo: userId);

    if (videoType != null) {
      query = query.where("type", isEqualTo: videoType);
    }

    if (isPrivate != null) {
      final visibility = isPrivate ? AppStrings.private : AppStrings.public;
      query = query.where("visibilityType", isEqualTo: visibility);
    }

    final snapshot =
        await query.orderBy("uploadedAt", descending: sortByLatest).get();

    return snapshot.docs.map((doc) => VideoModel.fromMap(doc.data())).toList();
  }

  /// Updates a specific field of a user's data in the Firestore database
  @override
  Future<void> updateUserField(
      String userId, String field, dynamic value) async {
    await _firestore.collection("users").doc(userId).update({field: value});
  }
}
