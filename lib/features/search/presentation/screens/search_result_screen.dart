import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../core/presentation/widgets/content_card.dart';
import '../../../../core/presentation/widgets/loader.dart';
import '../providers/state/search_notifier.dart';
import '../widgets/custom_search_bar.dart';

class SearchResultScreen extends ConsumerWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final videoList = ref.watch(getDataList(query));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            CustomSearchBar(localization: localization, query: query),

            videoList.when(
              data: (videos) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final thumbnail = video.thumbnailUrl;
                      final title = video.title;
                      final channelName = video.channelTitle;

                      return ContentCard(
                        thumbnail: thumbnail,
                        title: title!,
                        channelName: channelName,
                      );
                    },
                  ),
                );
              },
              loading: () => const Loader(),
              error: (err, _) => Center(child: Text("Error: $err")),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
