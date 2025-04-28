import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/presentation/styles/app_text_style.dart';
import '../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../core/utils/constants/app_strings.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  final AppLocalizations localization;

  const HistoryScreen({super.key, required this.localization});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
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
    return Scaffold(
      appBar: CustomSliverAppBar(
        title: AppStrings.history,
        showTitle: _showTitle,
        elevation: 0.0,
        actions: const [
          SearchIconButton(),
          MenuButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 10.0),
                child: Text(
                  widget.localization.history,
                  style: AppTextStyles.headlineLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
