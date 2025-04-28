import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/constants/enums/content_category.dart';
import '../../../video/data/models/video_model.dart';
import '../../data/datasources/subscription_remote_data_source.dart';
import '../../data/models/subscription_model.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/usecases/subscription_usecases/get_my_subscription_contents_use_case.dart';
import '../../domain/usecases/subscription_usecases/get_my_subscriptions_list_use_case.dart';
import '../../domain/usecases/subscription_usecases/is_subscribed_status_use_case.dart';
import '../../domain/usecases/subscription_usecases/subscribe_other_channel.dart';
import '../../domain/usecases/subscription_usecases/unsubscribe_channel.dart';
import 'user_provider.dart';

// Provider for FirebaseFirestore instance
final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Provider for subscription datasource
final subscriptionDatasourceProvider = Provider<SubscriptionDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final firebaseDataSource = ref.watch(firebaseDataSourceProvider);
  return SubscriptionRemoteDataSource(firestore, firebaseDataSource);
});

// Provider for subscription repository
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final dataSource = ref.watch(subscriptionDatasourceProvider);
  final firebaseDataSource = ref.watch(firebaseDataSourceProvider);
  return SubscriptionRepositoryImpl(
    dataSource: dataSource,
    firebaseDataSource: firebaseDataSource,
  );
});

// Provider for the use case of subscribing to another channel
final subcribeOtherChannelUseCaseProvider = Provider((ref) {
  final repository = ref.read(subscriptionRepositoryProvider);
  return SubscribeOtherChannelUseCase(repository);
});

final unsubscribeChannelProvider = Provider((ref) {
  final repository = ref.read(subscriptionRepositoryProvider);
  return UnsubscribeChannelUseCase(repository);
});

final isSubscribedProvider =
    StreamProvider.autoDispose.family<bool, String>((ref, channelId) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  final userIdRef = ref.read(currentUserProvider).value!.userId;
  return IsSubscribedStatusUseCase(repository).execute(channelId, userIdRef);
});

final mySubscriptionsListProvider =
    FutureProvider.family<List<SubscriptionModel>, String>(
        (ref, currentUserId) {
  final repository = ref.read(subscriptionRepositoryProvider);
  return GetMySubscriptionsListUseCase(repository).execute(currentUserId, true);
});

final getMySubsContentsProvider = FutureProvider<List<VideoModel>>((ref) async {
  final currentUser = ref.watch(currentUserProvider).value!;
  final subscriptions = currentUser.subscriptions;

  if (subscriptions.isEmpty) return [];

  final repository = ref.read(subscriptionRepositoryProvider);
  final useCase = GetMySubscriptionContentsUseCase(repository);

  return await useCase.execute(subscriptions);
});

final selectedCategoryProvider =
    StateProvider<ContentCategory>((ref) => ContentCategory.all);

final subsSortByProvider =
    StateProvider<String>((ref) => AppStrings.mostRelevantOrder);
