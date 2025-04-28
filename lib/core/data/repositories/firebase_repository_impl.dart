import '../../../features/user/data/models/user_model.dart';
import '../../../features/video/data/models/video_model.dart';
import '../../domain/repositories/firebase_repository.dart';
import '../datasources/firebase_remote_data_source.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  final FirebaseDataSource dataSource;

  FirebaseRepositoryImpl({required this.dataSource});

  @override
  Future<VideoModel> fetchVideoData(String videoId) async {
    return await dataSource.getVideoDetailsByVideoId(videoId);
  }

  @override
  Future<UserModel> fetchUserData(String userId) async {
    return await dataSource.getUserDetailsByVideoId(userId);
  }
}
