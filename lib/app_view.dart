import 'package:flutter/material.dart';

import 'core/presentation/widgets/loader.dart';
import 'core/utils/helpers/shared_preferences_helper.dart';
import 'features/home/presentation/screens/home_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

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
          body: isAuthenticated ? const HomeScreen() : const HomeScreen(),
        );
      },
    );
  }
}
