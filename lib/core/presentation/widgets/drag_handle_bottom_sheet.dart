import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

class DragHandleBottomSheet extends StatelessWidget {
  const DragHandleBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40.0,
        height: 4.0,
        margin: const EdgeInsets.only(bottom: 15.0),
        decoration: BoxDecoration(
          color: context.ternaryColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}
