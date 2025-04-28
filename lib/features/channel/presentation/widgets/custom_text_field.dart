import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/presentation/styles/app_text_style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final String? errorMessage;
  final ValueChanged<String> onChanged;
  final String? type;

  const CustomTextField({
    super.key,
    required this.textEditingController,
    required this.validator,
    required this.errorMessage,
    required this.onChanged,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text form field
        TextField(
          controller: textEditingController,
          cursorColor: context.secondaryColor,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 12.0, 12.0, 12.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: errorMessage == null
                      ? context.secondaryColor
                      : context.errorColor,
                  width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            prefixText: type == AppStrings.username ? '@' : null,
            prefixStyle: AppTextStyles.bodyLarge.copyWith(fontSize: 18.0),
          ),
          onChanged: onChanged,
        ),

        // Error message with icon
        if (errorMessage != null) ...[
          const SizedBox(height: 5.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
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
        ],
        const SizedBox(height: 20.0),
      ],
    );
  }
}
