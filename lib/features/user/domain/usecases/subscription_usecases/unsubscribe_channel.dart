import '../../repositories/subscription_repository.dart';

class UnsubscribeChannelUseCase {
  final SubscriptionRepository repository;

  UnsubscribeChannelUseCase(this.repository);

  Future<void> execute(String userId, String currentUserId) async {
    return repository.unsubscribeChannel(userId, currentUserId);
  }
}
