import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../styles/app_text_style.dart';

class CustomErrorLabel extends StatelessWidget {
  final String? errorMessage;
  final String charactersRef;
  final int maxCharacter;
  final int warningCount;

  const CustomErrorLabel({
    super.key,
    this.errorMessage,
    required this.charactersRef,
    required this.maxCharacter,
    required this.warningCount,
  });

  @override
  Widget build(BuildContext context) {
    // Warning message and character count
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Warning message (only show if there is an error)
          if (errorMessage != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outlined,
                      color: context.errorColor,
                      size: 18.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: context.errorColor),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const Spacer(),

          /// Character count (only show when length >= [warningCount])
          if (charactersRef.length >= warningCount)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "${charactersRef.length} / $maxCharacter",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: errorMessage != null
                      ? context.errorColor
                      : context.ternaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
