import '../../../data/models/subscription_model.dart';
import '../../repositories/subscription_repository.dart';

class GetMySubscriptionsListUseCase {
  final SubscriptionRepository repository;

  GetMySubscriptionsListUseCase(this.repository);

  Future<List<SubscriptionModel>> execute(
      String currentUserId, bool sortByLatest) async {
    return await repository.getMySubscriptionsList(currentUserId, sortByLatest);
  }
}
