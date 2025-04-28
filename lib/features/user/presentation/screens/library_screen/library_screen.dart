import 'package:flutter/material.dart';

import '../../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../../core/utils/helpers/shared_preferences_helper.dart';
import 'authenticated_library_screen.dart';
import 'unauthenticated_library_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedPreferencesHelper.getAuthenticationStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        final bool isAuthenticated = snapshot.data ?? false;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: isAuthenticated
              ? const AuthenticatedLibraryScreen()
              : const UnAuthenticatedLibraryScreen(),
          bottomNavigationBar: const BottomNavbar(),
        );
      },
    );
  }
}
