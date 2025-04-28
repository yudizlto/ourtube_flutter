import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 24.0,
        width: 24.0,
        child: CircularProgressIndicator(
          color: context.activeColor,
          strokeWidth: 1.8,
        ),
      ),
    );
  }
}
