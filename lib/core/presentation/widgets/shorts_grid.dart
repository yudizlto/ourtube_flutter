import 'package:flutter/material.dart';

import 'shorts_card.dart';

class ShortsGrid extends StatelessWidget {
  final List shortsList;
  final VoidCallback onTap;

  const ShortsGrid({
    super.key,
    required this.shortsList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 9.0 / 16.0,
        ),
        // itemCount: shortsList.length,
        itemCount: 4,
        itemBuilder: (context, index) {
          final data = shortsList[index];
          return GestureDetector(
            onTap: onTap,
            child: ShortsCard(
              title: data.title,
              videoUrl: data.videoUrl,
            ),
          );
        },
      ),
    );
  }
}
