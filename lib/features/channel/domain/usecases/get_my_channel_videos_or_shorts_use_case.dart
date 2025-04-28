import '../../../video/data/models/video_model.dart';
import '../repositories/channel_repository.dart';

class GetMyChannelVideosOrShorts {
  final ChannelRepository repository;

  GetMyChannelVideosOrShorts(this.repository);

  Future<List<VideoModel>> call({
    required String userId,
    required bool sortByLatest,
    required bool isShorts,
  }) {
    return isShorts
        ? repository.getShortsByUserId(userId, sortByLatest)
        : repository.getLongByUserId(userId, sortByLatest);
  }
}
