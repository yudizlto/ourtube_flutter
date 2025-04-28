import '../../data/models/history_model.dart';
import '../repositories/history_repository.dart';

class GetMyVideoHistoryUseCase {
  final HistoryRepository repository;

  GetMyVideoHistoryUseCase(this.repository);

  Future<List<HistoryModel>> execute(String userId, bool sortByLatest) async {
    return await repository.getMyVideoHistory(userId, sortByLatest);
  }
}
