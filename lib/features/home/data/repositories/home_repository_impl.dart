import '../../../user/data/models/user_model.dart';
import '../../../video/data/models/video_model.dart';
import '../../domain/entities/video_item_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  /// Retrieves a list of trending videos by calling the `HomeDataSource`.
  ///
  /// - Returns: A `Future` that resolves to a list of `VideoItemEntity` objects.
  @override
  Future<List<VideoItemEntity>> getTrendingVideos() async {
    return await dataSource.fetchTrendingVideos();
  }

  /// Retrieves a list of videos filtered by a specific category.
  ///
  /// - [categoryId]: The ID of the video category.
  /// - Returns: A `Future` that resolves to a list of `VideoItemEntity` objects.
  @override
  Future<List<VideoItemEntity>> getVideosByCategory(String categoryId) async {
    return await dataSource.fetchVideosByCategory(categoryId);
  }

  /// Retrieves all video snapshots stored in Firestore.
  ///
  /// - Returns: A `Future` that resolves to a list of `VideoModel` objects retrieved from Firestore.
  @override
  Future<List<VideoModel>> getAllVideosSnapshot() async {
    return await dataSource.getVideoSnapshotSuggestions();
  }

  /// Retrieves user details by video ID.
  @override
  Future<UserModel> getUserDetailsByVideoId(String userId) async {
    return await dataSource.getUserDetailsByVideoId(userId);
  }

  /// Retrieves a list of long videos stored in Firestore.
  @override
  Future<List<VideoModel>> getShortsVideoSnapshot() async {
    return await dataSource.getShortsVideoSuggestions();
  }
}
