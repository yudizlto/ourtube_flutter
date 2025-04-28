import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../user/data/models/user_model.dart';
import '../../../../user/presentation/providers/user_provider.dart';
import '../../providers/my_channel_provider.dart';
import '../../widgets/my_channel_body.dart';
import '../../widgets/my_channel_header.dart';

class MyChannelScreen extends ConsumerStatefulWidget {
  final UserModel user;
  final AppLocalizations localization;

  const MyChannelScreen({
    super.key,
    required this.user,
    required this.localization,
  });

  @override
  ConsumerState<MyChannelScreen> createState() => _MyChannelScreenState();
}

class _MyChannelScreenState extends ConsumerState<MyChannelScreen> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      /// Update visibility based on scroll position
      if (_scrollController.offset > 100.0 && !_showTitle) {
        setState(() {
          _showTitle = true;
        });
      } else if (_scrollController.offset <= 100.0 && _showTitle) {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Function to handle refresh
  /// Refreshes the latest video
  Future<void> _onRefresh() async {
    final userRef = ref.watch(currentUserProvider);
    await Future.delayed(const Duration(seconds: 2)).then((_) {
      ref.invalidate(currentUserProvider);
      ref.invalidate(latestVideosProvider(userRef.value!.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSliverAppBar(
        title: widget.user.displayName,
        showTitle: _showTitle,
        actions: const [SearchIconButton(), MenuButton()],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: context.secondaryColor,
          onRefresh: () => _onRefresh(),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyChannelHeader(
                  user: widget.user,
                  localization: widget.localization,
                ),
                MyChannelBody(localization: widget.localization),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
