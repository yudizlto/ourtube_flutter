class PlaylistState {
  final String playlistName;
  final bool isPublic;
  final String description;
  final String? titleError;
  final String? descriptionError;
  // final bool isDataChanged;
  final Set<String> selectedPlaylists;
  final Set<String> unSelectedPlaylists;

  PlaylistState({
    this.playlistName = "",
    this.isPublic = false,
    this.description = "",
    this.titleError,
    this.descriptionError,
    // this.isDataChanged = false,
    this.selectedPlaylists = const {},
    this.unSelectedPlaylists = const {},
  });

  PlaylistState copyWith(
      {String? playlistName,
      bool? isPublic,
      String? description,
      String? titleError,
      String? descriptionError,
      // bool? isDataChanged,
      Set<String>? selectedPlaylists,
      Set<String>? unSelectedPlaylists}) {
    return PlaylistState(
        playlistName: playlistName ?? this.playlistName,
        isPublic: isPublic ?? this.isPublic,
        description: description ?? this.description,
        titleError: titleError ?? this.titleError,
        descriptionError: descriptionError ?? this.descriptionError,
        // isDataChanged: isDataChanged ?? this.isDataChanged,
        selectedPlaylists: selectedPlaylists ?? this.selectedPlaylists,
        unSelectedPlaylists: unSelectedPlaylists ?? this.unSelectedPlaylists);
  }
}
