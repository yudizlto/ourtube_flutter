import 'package:uuid/uuid.dart';

import '../../../../core/data/datasources/firebase_remote_data_source.dart';
import '../../../user/data/models/user_model.dart';
import '../models/video_model.dart';
import '../../domain/repositories/likes_repository.dart';
import '../datasources/likes_remote_data_source.dart';
import '../models/likes_model.dart';

class LikesRepositoryImpl extends LikesRepository {
  final LikesDataSource dataSource;
  final FirebaseDataSource firebaseDataSource;

  LikesRepositoryImpl({
    required this.dataSource,
    required this.firebaseDataSource,
  });

  /// Adds a like to a video and updates the relevant user and video fields in Firestore
  @override
  Future<void> addLikes(VideoModel video, UserModel user) async {
    final likeId = const Uuid().v4();
    final model = LikesModel(
      likeId: likeId,
      userId: user.userId,
      videoId: video.videoId,
      createdAt: DateTime.now(),
    );

    /// Add the like to Firestore
    await dataSource.addLikesToFirestore(model);

    /// Increment the user's liked videos count
    final userLikedVideo = user.likedVideos + 1;
    await firebaseDataSource.updateUserField(
        user.userId, "likedVideos", userLikedVideo);

    /// Increment the video's likes count
    final videoLikes = video.likesCount + 1;
    await firebaseDataSource.updateVideoField(
        video.videoId, "likesCount", videoLikes);
  }

  /// Removes a like from a video and updates the relevant user and video fields in Firestore
  @override
  Future<void> unLikes(VideoModel video, UserModel user) async {
    /// Retrieve the [likeId] for the user and video combination
    final likeId = await dataSource.getLikeId(user.userId, video.videoId);
    if (likeId != null) {
      /// Delete the like from Firestore
      await dataSource.deleteLikesFromFirestore(likeId);

      /// Decrement the user's liked videos count
      final userLikedVideo = user.likedVideos - 1;
      await firebaseDataSource.updateUserField(
          user.userId, "likedVideos", userLikedVideo);

      /// Decrement the video's likes count
      final videoLikes = video.likesCount - 1;
      await firebaseDataSource.updateVideoField(
          video.videoId, "likesCount", videoLikes);
    }
  }

  /// Streams a boolean value indicating whether a video is liked by a specific user
  @override
  Stream<bool> isLikedByUser(String videoId, String userId) {
    return dataSource.isLikedByUser(videoId, userId);
  }
}
