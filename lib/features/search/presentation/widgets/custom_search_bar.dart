import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/utils/helpers/navigation_helpers.dart';
import '../providers/state/search_notifier.dart';
import '../screens/search_result_screen.dart';

class CustomSearchBar extends ConsumerStatefulWidget {
  final AppLocalizations localization;
  final String? query;

  const CustomSearchBar({super.key, required this.localization, this.query});

  @override
  ConsumerState<CustomSearchBar> createState() => _CustomSearchBarrState();
}

class _CustomSearchBarrState extends ConsumerState<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query ?? "");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(searchNotifier.notifier);

    return Container(
      height: 60.0,
      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 8.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_sharp,
              color: context.secondaryColor,
              size: 24.0,
            ),
            onPressed: () {
              notifier.reset();
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 5.0),
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: context.secondaryColor,
              decoration: InputDecoration(
                hintText: widget.localization.search_bar_placeholder,
                hintStyle: AppTextStyles.bodyLarge
                    .copyWith(color: context.ternaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: context.buttonColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  notifier.updateQuery(value);
                  NavigationHelpers.navigateWithPushReplacement(
                      context, SearchResultScreen(query: value));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
