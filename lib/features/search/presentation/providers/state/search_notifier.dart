import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/search_video_entity.dart';
import '../search_provider.dart';
import 'search_state.dart';

/// A provider for managing search state using Riverpod NotifierProvider
final searchNotifier =
    NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);

/// A FutureProvider.family that fetches a list of items based on the given query
/// This allows fetching data dynamically for different queries
final getDataList =
    FutureProvider.family<List<SearchVideoEntity>, String>((ref, query) {
  return ref.read(getVideosFromQueryApiUseCaseProvider).execute(query);
});

class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() {
    return SearchState();
  }

  /// Updates the search query state with a new value
  void updateQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Resets the search query to an empty string
  void reset() => state = SearchState(searchQuery: "");
}
