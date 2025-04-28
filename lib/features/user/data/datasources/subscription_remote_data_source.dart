import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/datasources/firebase_remote_data_source.dart';
import '../../../video/data/models/video_model.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionDataSource {
  Future<void> addSubscriptionToFirestore(SubscriptionModel subs);
  Future<void> deleteSubscriptionToFirestore(
      String currentUserId, String userId);
  Stream<bool> isSubscribedByUser(String channelId, String currentUserId);
  Future<List<SubscriptionModel>> getMySubscriptionsList(
      String currentUserId, bool sortByLatest);
  Future<List<VideoModel>> getContentsSnapshot(List<String> subscriptions);
}

class SubscriptionRemoteDataSource implements SubscriptionDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseDataSource _firebaseDataSource;

  SubscriptionRemoteDataSource(this._firestore, this._firebaseDataSource);

  /// Retrieves a list of public videos uploaded by users the current user is subscribed to.
  ///
  /// - [subscriptions] : A list of user IDs representing the user's subscriptions.
  @override
  Future<List<VideoModel>> getContentsSnapshot(
      List<String> subscriptions) async {
    return await _firebaseDataSource.getAllVideosSnapshot(subscriptions);
  }

  /// Adds a new subscription to the Firestore database
  @override
  Future<void> addSubscriptionToFirestore(SubscriptionModel subs) async {
    await _firestore
        .collection("subscriptions")
        .doc(subs.subscriptionId)
        .set(subs.toMap());
  }

  /// Deletes a subscription from Firestore based on the subscription ID and user ID
  @override
  Future<void> deleteSubscriptionToFirestore(
      String currentUserId, String userId) async {
    final querySnapshot = await _firestore
        .collection("subscriptions")
        .where("userId", isEqualTo: currentUserId)
        .where("subscribedTo", isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  }

  /// Checks if the [currentUserId] is subscribed to a specific [channelId]
  ///
  /// Returns a stream of boolean values that updates in real time.
  @override
  Stream<bool> isSubscribedByUser(String channelId, String currentUserId) {
    return _firestore
        .collection("subscriptions")
        .where("userId", isEqualTo: currentUserId)
        .where("subscribedTo", isEqualTo: channelId)
        .snapshots()
        .map((e) => e.docs.isNotEmpty);
  }

  /// Retrieves a list of the current user's subscriptions.
  ///
  /// - [currentUserId] : The ID of the current user.
  /// - [sortByLatest] : If true, results are ordered by newest first.
  @override
  Future<List<SubscriptionModel>> getMySubscriptionsList(
      String currentUserId, bool sortByLatest) async {
    final snapshot = await _firestore
        .collection("subscriptions")
        .where("userId", isEqualTo: currentUserId)
        .orderBy("subscribedAt", descending: sortByLatest)
        .get();
    return snapshot.docs
        .map((doc) => SubscriptionModel.fromMap(doc.data()))
        .toList();
  }
}
