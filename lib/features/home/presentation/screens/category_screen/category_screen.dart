import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../../core/presentation/styles/app_text_style.dart';
import '../../../../../core/presentation/widgets/bottom_navbar.dart';
import '../../../../../core/presentation/widgets/custom_sliver_app_bar.dart';
import '../../../../../core/presentation/widgets/pop_up_menu_button.dart';
import '../../../../../core/presentation/widgets/search_icon_button.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class CategoryScreen extends StatefulWidget {
  final String icon;
  final String titleCategory;
  final Widget content;

  const CategoryScreen({
    super.key,
    required this.icon,
    required this.titleCategory,
    required this.content,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
        title: widget.titleCategory,
        showTitle: _showTitle,
        actions: const [
          SearchIconButton(),
          MenuButton(),
        ],
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 24.0),
              child: Row(
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: const ShapeDecoration(
                      color: AppColors.red,
                      shape: CircleBorder(),
                    ),
                    child: Image.asset(
                      widget.icon,
                      width: 24.0,
                      fit: BoxFit.cover,
                      color: context.secondaryColor,
                    ),
                  ),
                  Text(
                    widget.titleCategory,
                    style: AppTextStyles.headlineLarge,
                  ),
                ],
              ),
            ),

            // Content Section
            widget.content,
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
