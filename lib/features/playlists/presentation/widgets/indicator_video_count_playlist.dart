import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../data/models/playlist_model.dart';

class IndicatorVideoCountPlaylist extends StatelessWidget {
  final PlaylistModel playlist;

  const IndicatorVideoCountPlaylist({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5.0,
      right: 8.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: AppColors.blackDark1,
        ),
        child: Row(
          children: [
            Image.asset(AppAssets.playlistPlayIcon, width: 20.0),
            const SizedBox(width: 2.0),
            Text(
              playlist.videos.length.toString(),
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
