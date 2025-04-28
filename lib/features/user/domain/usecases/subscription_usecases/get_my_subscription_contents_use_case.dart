import '../../../../video/data/models/video_model.dart';
import '../../repositories/subscription_repository.dart';

// class GetMySubscriptionContentsUseCase {
//   final SubscriptionRepository repository;

//   GetMySubscriptionContentsUseCase(this.repository);

//   Future<List<VideoModel>> execute(String currentUserId) {
//     return repository.getMySubsContentsSnapshot(currentUserId);
//   }
// }
class GetMySubscriptionContentsUseCase {
  final SubscriptionRepository repository;

  GetMySubscriptionContentsUseCase(this.repository);

  Future<List<VideoModel>> execute(List<String> subscriptions) {
    return repository.getMySubsContentsSnapshot(subscriptions);
  }
}
