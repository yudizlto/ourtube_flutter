import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../user/data/models/user_model.dart';
import '../../widgets/user_channel_body.dart';
import '../../widgets/user_channel_header.dart';

class UsersChannelScreen extends StatefulWidget {
  final UserModel user;

  const UsersChannelScreen({super.key, required this.user});

  @override
  State<UsersChannelScreen> createState() => _UsersChannelScreenState();
}

class _UsersChannelScreenState extends State<UsersChannelScreen> {
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

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomSliverAppBar(
        title: widget.user.displayName,
        showTitle: _showTitle,
        actions: const [SearchIconButton(), MenuButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserChannelHeader(user: widget.user, localization: localization),
              UserChannelBody(localization: localization, user: widget.user),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
