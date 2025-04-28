import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_strings.dart';
import '../../../../../core/utils/helpers/validators.dart';
import 'playlist_state.dart';

final playlistNotifier =
    NotifierProvider<PlaylistNotifier, PlaylistState>(PlaylistNotifier.new);

class PlaylistNotifier extends Notifier<PlaylistState> {
  /// Initializes the `PlaylistState` with its default values
  @override
  PlaylistState build() {
    return PlaylistState();
  }

  /// Updates the playlist name while validating its character count
  void createPlaylistName(String newPlaylistName) {
    final errorMessage = ValidationUtils.validatePlaylistNameCharacterCount(
      newPlaylistName,
      AppStrings.chooseShorterTitle,
    );

    updateTitleError(errorMessage);
    state = state.copyWith(playlistName: newPlaylistName);
  }

  /// Updates the visibility of the playlist
  void setIsPublic(bool newIsPublic) {
    state = state.copyWith(isPublic: newIsPublic);
  }

  /// Updates the title error message in the state
  void updateTitleError(String? newTitleError) {
    state = state.copyWith(titleError: newTitleError);
  }

  void toggleSelected(String playlistId) {
    final updateSelections = state.selectedPlaylists.contains(playlistId)
        ? state.selectedPlaylists.difference({playlistId})
        : state.selectedPlaylists.union({playlistId});
    state = state.copyWith(selectedPlaylists: updateSelections);
  }

  void toggleUnselected(String playlistId) {
    final updateSelections = state.unSelectedPlaylists.contains(playlistId)
        ? state.unSelectedPlaylists.difference({playlistId})
        : state.unSelectedPlaylists.union({playlistId});
    state = state.copyWith(unSelectedPlaylists: updateSelections);
  }

  /// Resets the playlist state to its default values
  void reset() => state = PlaylistState();
}
