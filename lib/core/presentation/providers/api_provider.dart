import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/api_remote_data_source.dart';
import '../../data/repositories/api_repository_impl.dart';
import '../../domain/repositories/api_repository.dart';

final apiDataSourceProvider =
    Provider<ApiDataSource>((ref) => ApiRemoteDataSource());

final apiRepositoryProvider = Provider<ApiRepository>((ref) {
  final dataSource = ref.read(apiDataSourceProvider);
  return ApiRepositoryImpl(dataSource: dataSource);
});
