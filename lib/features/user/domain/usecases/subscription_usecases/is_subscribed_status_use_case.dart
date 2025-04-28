import '../../repositories/subscription_repository.dart';

class IsSubscribedStatusUseCase {
  final SubscriptionRepository _repository;

  IsSubscribedStatusUseCase(this._repository);

  Stream<bool> execute(String channelId, String currentUserId) {
    return _repository.isChannelSubscribedStatus(channelId, currentUserId);
  }
}
