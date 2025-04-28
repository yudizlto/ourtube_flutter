import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/providers/api_provider.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/get_videos_from_query_api_use_case.dart';

/// Provides an instance of `SearchRemoteDataSource`
final searchRemoteDataSourceProvider = Provider<SearchDataSource>((ref) {
  final dataSource = ref.read(apiDataSourceProvider);
  return SearchRemoteDataSource(dataSource);
});

/// Provides an instance of `SearchRepositoryImpl`
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dataSource = ref.read(searchRemoteDataSourceProvider);
  return SearchRepositoryImpl(dataSource: dataSource);
});

/// Provides an instance of `GetVideosFromQueryApiUseCase`
final getVideosFromQueryApiUseCaseProvider = Provider((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return GetVideosFromQueryApiUseCase(repository);
});
