import 'package:flutter/material.dart';

import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../../core/utils/helpers/shared_preferences_helper.dart';
import '../../widgets/setting_options.dart';
import 'unauthenticated_setting_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
          body: isAuthenticated
              ? const SettingOptions()
              : const UnAuthenticatedSettingScreen(),
        );
      },
    );
  }
}
