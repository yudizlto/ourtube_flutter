import '../../../video/data/models/video_model.dart';
import '../repositories/channel_repository.dart';

class GetOtherChannelVideosOrShorts {
  final ChannelRepository repository;

  GetOtherChannelVideosOrShorts(this.repository);

  Future<List<VideoModel>> call({
    required String userId,
    required bool sortByLatest,
    required bool isShorts,
  }) {
    return isShorts
        ? repository.getOtherChannelShorts(userId, sortByLatest)
        : repository.getOtherChannelLongVideos(userId, sortByLatest);
  }
}
