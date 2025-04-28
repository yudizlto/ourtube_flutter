import '../../../video/data/models/video_model.dart';
import '../../data/models/subscription_model.dart';

abstract class SubscriptionRepository {
  Future<void> subscribeOtherChannel(String userId, String currentUserId);
  Future<void> unsubscribeChannel(String userId, String currentUserId);
  Stream<bool> isChannelSubscribedStatus(
      String channelId, String currentUserId);
  Future<List<SubscriptionModel>> getMySubscriptionsList(
      String currentUserId, bool sortByLatest);
  // Future<List<VideoModel>> getMySubsContentsSnapshot(String currentUserId);
  Future<List<VideoModel>> getMySubsContentsSnapshot(
      List<String> subscriptions);
}
