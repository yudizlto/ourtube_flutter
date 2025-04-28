import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SizedBox(
          height: 30.0,
          width: 30.0,
          child: CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 1.8,
          ),
        ),
      ),
    );
  }
}
