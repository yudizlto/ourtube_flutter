import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firebase_remote_data_source.dart';
import '../../data/repositories/firebase_repository_impl.dart';
import '../../domain/repositories/firebase_repository.dart';

// Provider for FirebaseFirestore instance
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for Firebse datasource
final firebaseDataSourceProvider = Provider<FirebaseDataSource>((ref) {
  final repository = ref.read(firestoreProvider);
  return FirebaseRemoteDataSource(repository);
});

final firebaseRepositoryProvider = Provider<FirebaseRepository>((ref) {
  final dataSource = ref.watch(firebaseDataSourceProvider);
  return FirebaseRepositoryImpl(dataSource: dataSource);
});

final getVideoDetailsByIdProvider = FutureProvider.family((ref, String id) {
  final repository = ref.read(firebaseRepositoryProvider);
  return repository.fetchVideoData(id);
});

final getUserDetailsByIdProvider = FutureProvider.family((ref, String id) {
  final repository = ref.read(firebaseRepositoryProvider);
  return repository.fetchUserData(id);
});
