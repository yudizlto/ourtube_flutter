import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/history/presentation/providers/history_provider.dart';
import '../../../features/home/presentation/screens/home_screen.dart';
import '../../../features/user/presentation/screens/library_screen/library_screen.dart';
import '../../../features/user/presentation/screens/subscription_screen/subscription_screen.dart';
import '../../../features/video/data/models/video_model.dart';
import '../../../features/video/presentation/screens/long_video/video_player_screen.dart';
import '../../../features/video/presentation/screens/short_video/shorts_screen.dart';

class NavigationHelpers {
  /// Handles navigation when a bottom navigation bar item is tapped
  static void handleNavbarTap(BuildContext context, int index) {
    final screen = [
      const HomeScreen(),
      const ShortsVideoScreen(),
      const SubscriptionScreen(),
      const LibraryScreen(),
    ][index];

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
      (route) => false,
    );
  }

  /// Navigates to a specified screen with a custom transition
  static Future<dynamic> navigateToScreen(BuildContext context, Widget screen) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
    );
  }

  /// Navigates to a specified screen and removes all previous routes from the stack
  static void navigateWithRemoveUntil(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
      (route) => false,
    );
  }

  /// Navigates to a specified screen with a slide transition animation
  static void navigateWithSlideTransition(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  /// Opens a bottom sheet to display the video player screen
  /// And updates history upon dismissal
  static void openBottomSheetForVideoPlayerScreen(
    BuildContext context,
    VideoModel video,
    WidgetRef ref,
    String userId,
    int durationWatched,
  ) async {
    final updateHistoryRef = ref.read(updateHistoryUseCaseProvider);
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0.0,
      builder: (context) {
        return SafeArea(child: VideoPlayerScreen(video: video));
      },
    );

    /// Update watch history if the user dismissed the bottom sheet without interaction
    if (result == null) {
      return updateHistoryRef.excute(video.videoId, userId, durationWatched);
    }
  }

  /// Navigates to a specified screen by replacing the current screen
  /// This prevents the user from navigating back to the previous screen
  static void navigateWithPushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
    );
  }
}
