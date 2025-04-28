import '../../../../core/data/datasources/api_remote_data_source.dart';
import '../../../../core/data/datasources/firebase_remote_data_source.dart';
import '../../../user/data/models/user_model.dart';
import '../../../video/data/models/video_model.dart';
import '../../domain/entities/video_item_entity.dart';

abstract class HomeDataSource {
  Future<List<VideoItemEntity>> fetchTrendingVideos();
  Future<List<VideoItemEntity>> fetchVideosByCategory(String categoryId);
  Future<List<VideoModel>> getVideoSnapshotSuggestions();
  Future<List<VideoModel>> getShortsVideoSuggestions();
  Future<UserModel> getUserDetailsByVideoId(String userId);
}

class HomeRemoteDataSource implements HomeDataSource {
  final ApiDataSource _dataSource;
  final FirebaseDataSource _firebaseDataSource;

  HomeRemoteDataSource(this._dataSource, this._firebaseDataSource);

  /// Fetches a list of trending videos by delegating the request to `ApiDataSource`.
  ///
  /// - Returns: A `Future` that resolves to a list of `VideoItemEntity` objects.
  @override
  Future<List<VideoItemEntity>> fetchTrendingVideos() async {
    return await _dataSource.fetchTrendingVideos();
  }

  /// Fetches a list of videos based on a specific category by delegating the request to `ApiDataSource`.
  ///
  /// - [categoryId]: The ID of the video category.
  /// - Returns: A `Future` that resolves to a list of `VideoItemEntity` objects.
  @override
  Future<List<VideoItemEntity>> fetchVideosByCategory(String categoryId) async {
    return await _dataSource.fetchVideosByCategory(categoryId);
  }

  /// Retrieves a list of video snapshot suggestions from Firebase.
  ///
  /// This method fetches all video snapshots stored in Firebase and returns them as a list of `VideoModel`.
  ///
  /// - Returns: A `Future` that resolves to a list of `VideoModel` objects.
  @override
  Future<List<VideoModel>> getVideoSnapshotSuggestions() async {
    return await _firebaseDataSource.getLongVideosSnapshot();
  }

  /// Retrieves user details by video ID from Firebase.
  @override
  Future<UserModel> getUserDetailsByVideoId(String userId) async {
    return await _firebaseDataSource.getUserDetailsByVideoId(userId);
  }

  /// Retrieves a list of shorts video suggestions from Firebase.
  @override
  Future<List<VideoModel>> getShortsVideoSuggestions() async {
    return await _firebaseDataSource.getShortsSnapshot();
  }
}
