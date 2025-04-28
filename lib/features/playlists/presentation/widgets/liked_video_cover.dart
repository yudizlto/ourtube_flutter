import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../user/presentation/providers/user_provider.dart';

class LikedVideoCover extends ConsumerWidget {
  final String videoId;

  const LikedVideoCover({super.key, required this.videoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final videoRef = ref.watch(getVideoDetailsByIdProvider(videoId));

    return Column(
      children: [
        Container(
          width: 140.0,
          height: 5.0,
          decoration: const BoxDecoration(
            color: AppColors.blackDark4,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
        ),
        const SizedBox(height: 2.0),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            videoRef.when(
              data: (data) => Container(
                width: 158.0,
                height: 95.0,
                decoration: BoxDecoration(
                  color: user.likedVideos == 0 ? AppColors.lightGrey2 : null,
                  borderRadius: BorderRadius.circular(10.0),
                  image: user.likedVideos == 0
                      ? null
                      : DecorationImage(
                          image: NetworkImage(data.thumbnailUrl),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              loading: () => const Loader(),
              error: (error, stackTrace) => const SizedBox(),
            ),
            Container(
              width: 158.0,
              height: 95.0,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Column(
              children: [
                const Icon(Icons.thumb_up, color: AppColors.white, size: 24.0),
                Text(
                  user.likedVideos.toString(),
                  style: const TextStyle(color: AppColors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
