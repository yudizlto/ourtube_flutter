import 'package:flutter/material.dart';

import 'empty_subs_header.dart';
import 'subs_suggestions.dart';

class NoSubscription extends StatelessWidget {
  const NoSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmptySubsHeader(),
        SubSuggestions(),
      ],
    );
  }
}
