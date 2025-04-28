import '../../../video/data/models/video_model.dart';
import '../repositories/channel_repository.dart';

class GetAllMyChannelVideo {
  final ChannelRepository repository;

  GetAllMyChannelVideo(this.repository);

  Future<List<VideoModel>> call(
      {required String userId, required bool sortByLatest}) {
    return repository.getVideosByUserId(userId, sortByLatest);
  }
}
