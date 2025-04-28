import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/constants/enums/video_type.dart';
import '../../../user/domain/usecases/stream_user_profile.dart';
import '../../../user/presentation/providers/user_provider.dart';
import '../../../video/data/models/video_model.dart';
import '../../data/datasources/channel_remote_data_source.dart';
import '../../data/datasources/supabase_channel_remote_data_source.dart';
import '../../data/repositories/channel_repository_impl.dart';
import '../../domain/repositories/channel_repository.dart';
import '../../domain/usecases/get_all_my_channel_video.dart';
import '../../domain/usecases/get_my_channel_videos_or_shorts_use_case.dart';
import '../../domain/usecases/update_banner_url.dart';
import '../../domain/usecases/update_user_photo_url.dart';
import '../../domain/usecases/update_user_profile.dart';

final streamUserProfileProvider =
    Provider((ref) => StreamUserProfile(ref.watch(userRepositoryProvider)));

final selectedIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

final isSwitchedProvider = StateProvider<bool>((ref) => false);

final isDescriptionChangedProvider = StateProvider<bool>((ref) => false);

final videoSortByProvider = StateProvider<bool>((ref) => true);

final myChannelDescriptionProvider = StateProvider<String>((ref) => "");

final myChannelDescriptionErrorProvider = StateProvider<String?>((ref) => null);

// Provider for FirebaseFirestore instance
final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for SupabaseClient instance
final supabaseClientProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final channelRemoteDataSourceProvider = Provider<ChannelDataSource>((ref) {
  final repository = ref.watch(firebaseFirestoreProvider);
  return ChannelRemoteDataSource(repository);
});

final supabaseChannelDataSourceProvider =
    Provider<SupabaseChannelDataSource>((ref) {
  final repository = ref.watch(supabaseClientProvider);
  return SupabaseChannelRemoteDataSource(repository);
});

// Provider for ChannelRepository
final channelRepositoryProvider = Provider<ChannelRepository>((ref) {
  final dataSource = ref.watch(channelRemoteDataSourceProvider);
  final supabaseDataSource = ref.watch(supabaseChannelDataSourceProvider);
  return ChannelRepositoryImpl(
    dataSource: dataSource,
    supabaseDataSource: supabaseDataSource,
  );
});

final updateBannerProvider = Provider<UpdateBannerUrl>((ref) {
  final repository = ref.watch(channelRepositoryProvider);
  return UpdateBannerUrl(repository);
});

final updatePhotoProvider = Provider<UpdateUserPhotoUrl>((ref) {
  final repository = ref.watch(channelRepositoryProvider);
  return UpdateUserPhotoUrl(repository);
});

// Provider for update user profile
final updateUserProvider = Provider<UpdateUserProfile>((ref) {
  final repository = ref.watch(channelRepositoryProvider);
  return UpdateUserProfile(repository);
});

final getAllVideosProvider = Provider<GetAllMyChannelVideo>((ref) {
  final repository = ref.watch(channelRepositoryProvider);
  return GetAllMyChannelVideo(repository);
});

final getMyChannelVideosProvider = Provider<GetMyChannelVideosOrShorts>((ref) {
  final repository = ref.watch(channelRepositoryProvider);
  return GetMyChannelVideosOrShorts(repository);
});

final latestVideosProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getAllVideosProvider);
  return getVideos.call(userId: userId, sortByLatest: true);
});

final oldestVideosProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getAllVideosProvider);
  return getVideos.call(userId: userId, sortByLatest: false);
});

final latestLongVidsProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getMyChannelVideosProvider);
  return getVideos.call(
    userId: userId,
    sortByLatest: true,
    isShorts: false,
  );
});

final oldestLongVidsProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getMyChannelVideosProvider);
  return getVideos.call(
    userId: userId,
    sortByLatest: false,
    isShorts: false,
  );
});

final latestShortsProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getMyChannelVideosProvider);
  return getVideos.call(
    userId: userId,
    sortByLatest: true,
    isShorts: true,
  );
});

final oldestShortsProvider =
    FutureProvider.family<List<VideoModel>, String>((ref, userId) {
  final getVideos = ref.watch(getMyChannelVideosProvider);
  return getVideos.call(
    userId: userId,
    sortByLatest: false,
    isShorts: true,
  );
});

final selectedFilterProvider = StateProvider<VideoType?>((ref) => null);
