import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourtube/features/video/data/models/video_model.dart';

import '../../../../core/data/datasources/firebase_remote_data_source.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_data_source.dart';
import '../models/subscription_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDataSource dataSource;
  final FirebaseDataSource firebaseDataSource;

  SubscriptionRepositoryImpl({
    required this.dataSource,
    required this.firebaseDataSource,
  });

  /// Fetches a list of content from the subscriptions list.
  ///
  /// [subscriptions] is a list of user IDs that the current user is subscribed to.
  @override
  Future<List<VideoModel>> getMySubsContentsSnapshot(
      List<String> subscriptions) async {
    return await dataSource.getContentsSnapshot(subscriptions);
  }

  /// Handles the subscription action when a user subscribes to another channel
  @override
  Future<void> subscribeOtherChannel(
      String userId, String currentUserId) async {
    var uuid = const Uuid();
    final subscriptionId = uuid.v4();
    final subsModel = SubscriptionModel(
      subscriptionId: subscriptionId,
      userId: currentUserId,
      subscribedTo: userId,
      subscribedAt: DateTime.now(),
    );

    /// Add the subscription data to Firestore
    await dataSource.addSubscriptionToFirestore(subsModel);

    /// Update the subscribers field on the user being subscribed to
    await firebaseDataSource.updateUserField(
        userId, "subscribers", FieldValue.arrayUnion([currentUserId]));

    /// Update the subscriptions field on the current user
    await firebaseDataSource.updateUserField(
        currentUserId, "subscriptions", FieldValue.arrayUnion([userId]));
  }

  /// Checks whether the [currentUserId] is subscribed to the channel with [channelId].
  ///
  /// Returns a [Stream<bool>] that emits `true` if subscribed, `false` otherwise.
  @override
  Stream<bool> isChannelSubscribedStatus(
      String channelId, String currentUserId) {
    return dataSource.isSubscribedByUser(channelId, currentUserId);
  }

  /// Unsubscribes the [currentUserId] from the channel with [userId].
  ///
  /// Steps performed:
  /// 1. Removes the corresponding subscription entry from Firestore.
  /// 2. Removes the currentUserId from the target user’s "subscribers" list.
  /// 3. Removes the userId from the current user’s "subscriptions" list.
  @override
  Future<void> unsubscribeChannel(String userId, String currentUserId) async {
    /// Delete the subscription from Firestore
    await dataSource.deleteSubscriptionToFirestore(currentUserId, userId);

    /// Remove currentUserId from the "subscribers" list of the target user
    await firebaseDataSource.updateUserField(
        userId, "subscribers", FieldValue.arrayRemove([currentUserId]));

    /// Remove userId from the "subscriptions" list of the current user
    await firebaseDataSource.updateUserField(
        currentUserId, "subscriptions", FieldValue.arrayRemove([userId]));
  }

  /// Retrieves the list of subscriptions for the current user.
  ///
  /// [currentUserId] is the ID of the current user.
  /// [sortByLatest] indicates whether to sort the list by latest subscriptions.
  @override
  Future<List<SubscriptionModel>> getMySubscriptionsList(
      String currentUserId, bool sortByLatest) async {
    return await dataSource.getMySubscriptionsList(currentUserId, sortByLatest);
  }
}
