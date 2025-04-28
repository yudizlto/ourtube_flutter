import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/loader.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../history/presentation/screens/history_screen.dart';
import '../providers/user_provider.dart';
import 'my_history_tile.dart';
import 'section_with_list.dart';

class HistorySection extends ConsumerWidget {
  final AppLocalizations localization;

  const HistorySection({super.key, required this.localization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserIdRef = ref.read(currentUserProvider).value!.userId;
    final historyRef =
        ref.watch(myLatestVideoHistoryProvider(currentUserIdRef));

    return SectionWithList(
      localization: localization,
      titleSection: localization.history,
      margin: const EdgeInsets.only(top: 15.0),
      onViewAll: () {
        NavigationHelpers.navigateToScreen(
            context, HistoryScreen(localization: localization));
      },
      // Horizontal list of videos history
      widgetList: historyRef.when(
        data: (data) => SizedBox(
          height: 180.0,
          child: ListView.builder(
            itemCount: data.length > 16 ? 16 : data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final history = data[index];
              return MyHistoryTile(index: index, history: history);
            },
          ),
        ),
        loading: () => const Loader(),
        error: (error, stackTrace) => const SizedBox(),
      ),
    );
  }
}
