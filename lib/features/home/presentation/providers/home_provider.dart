import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/constants/enums/category.dart';
import '../../../../core/presentation/providers/api_provider.dart';
import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../video/data/models/video_model.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/video_item_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_all_videos_from_firestore_use_case.dart';
import '../../domain/usecases/get_shorts_from_firestore_use_case.dart';
import '../../domain/usecases/get_videos_by_category_id_use_case.dart';
import '../../domain/usecases/get_videos_trending_use_case.dart';

/// Provides an instance of `HomeRemoteDataSource`
final homeRemoteDataSourceProvider = Provider<HomeDataSource>((ref) {
  final dataSource = ref.read(apiDataSourceProvider);
  final firebaseDataSource = ref.read(firebaseDataSourceProvider);
  return HomeRemoteDataSource(dataSource, firebaseDataSource);
});

/// Provides an instance of `HomeRepositoryImpl
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dataSource = ref.watch(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(dataSource: dataSource);
});

/// Provides an instance of `GetVideosTrendingUseCase`
final getVideosTrendingUseCaseProvider =
    Provider<GetVideosTrendingUseCase>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return GetVideosTrendingUseCase(repository);
});

/// Fetches a list of trending videos
final trendingVideosProvider =
    FutureProvider<List<VideoItemEntity>>((ref) async {
  final useCase = ref.read(getVideosTrendingUseCaseProvider);
  return await useCase.execute();
});

/// Fetches a list of videos by category
final categoryVideosProvider =
    FutureProvider.family<List<VideoItemEntity>, String>(
        (ref, categoryId) async {
  final repository = ref.read(homeRepositoryProvider);
  return await GetVideosByCategoryIdUseCase(repository).execute(categoryId);
});

/// Fetches all videos stored in Firestore
final getAllVideosFromFirestore = FutureProvider<List<VideoModel>>((ref) async {
  final repository = ref.read(homeRepositoryProvider);
  final useCase = GetAllVideosFromFirestoreUseCase(repository);
  return await useCase.execute();
});

/// Fetches all shorts stored in Firestore
final getShortsVideos = FutureProvider<List<VideoModel>>((ref) async {
  final repository = ref.read(homeRepositoryProvider);
  final useCase = GetShortsFromFirestoreUseCase(repository);
  return await useCase.execute();
});

final selectedCategoryProvider = StateProvider<Category>((ref) => Category.all);
