import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../video/data/models/video_model.dart';
import '../../domain/usecases/get_other_channel_videos.dart';
import 'my_channel_provider.dart';

final selectedIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

final videoSortByProvider = StateProvider<bool>((ref) => true);

final getOtherChannelVideosProvider =
    Provider<GetOtherChannelVideosOrShorts>((ref) {
  final repository = ref.watch(channelRepositoryProvider);
  return GetOtherChannelVideosOrShorts(repository);
});

final latestVideosProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getOtherChannelVideosProvider);
  return getVideos.call(
    userId: userId,
    sortByLatest: true,
    isShorts: false,
  );
});

final oldestVideosProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getOtherChannelVideosProvider);
  return getVideos.call(
    userId: userId,
    sortByLatest: false,
    isShorts: false,
  );
});

final latestShortsProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getOtherChannelVideosProvider);
  return getVideos.call(
    userId: userId,
    sortByLatest: true,
    isShorts: true,
  );
});

final oldestShortsProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getOtherChannelVideosProvider);
  return getVideos.call(
    userId: userId,
    sortByLatest: false,
    isShorts: true,
  );
});
