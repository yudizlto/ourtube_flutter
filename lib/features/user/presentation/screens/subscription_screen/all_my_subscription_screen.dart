import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/providers/firebase_provider.dart';
import '../../../../../core/presentation/styles/app_text_style.dart';
import '../../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../../core/presentation/widgets/loader.dart';
import '../../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/constants/app_strings.dart';
import '../../../../../core/utils/helpers/modal_helpers.dart';
import '../../../data/models/user_model.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/subscription_tile.dart';

class AllMySubscriptionScreen extends ConsumerWidget {
  final UserModel user;

  const AllMySubscriptionScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomSliverAppBar(
        title: localization.all_subscriptions,
        showTitle: true,
        actions: const [SearchIconButton(), MenuButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buttons for sorting my subscriptions list
              GestureDetector(
                onTap: () =>
                    ModalHelpers.showBottomSheetForSortingSubs(context),
                child: IntrinsicWidth(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: context.buttonColor,
                    ),
                    child: Row(
                      children: [
                        Consumer(
                          builder: (context, ref, _) {
                            final sortByRef = ref.watch(subsSortByProvider);
                            return Text(
                              sortByRef == AppStrings.mostRelevantOrder
                                  ? localization.most_relevant_order
                                  : localization.ascending_order,
                              style: AppTextStyles.titleMedium,
                            );
                          },
                        ),
                        const SizedBox(width: 8.0),
                        Image.asset(
                          AppAssets.downArrowIcon,
                          width: 20.0,
                          color: context.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 150.0,
                child: ListView.builder(
                  itemCount: user.subscriptions.length,
                  itemBuilder: (context, index) {
                    final userId = user.subscriptions[index];
                    final userRef =
                        ref.watch(getUserDetailsByIdProvider(userId));

                    return userRef.when(
                      data: (data) => SubscriptionTile(user: data),
                      loading: () => const Loader(),
                      error: (error, stackTrace) => const SizedBox(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
