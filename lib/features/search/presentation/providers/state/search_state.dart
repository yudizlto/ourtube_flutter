class SearchState {
  final String searchQuery;

  SearchState({this.searchQuery = ""});

  // Add the copyWith method
  SearchState copyWith({String? searchQuery}) {
    return SearchState(searchQuery: searchQuery ?? this.searchQuery);
  }
}
