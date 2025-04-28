import '../../repositories/subscription_repository.dart';

class SubscribeOtherChannelUseCase {
  final SubscriptionRepository repository;

  SubscribeOtherChannelUseCase(this.repository);

  Future<void> execute(String userId, String currentUserId) async {
    return repository.subscribeOtherChannel(userId, currentUserId);
  }
}
