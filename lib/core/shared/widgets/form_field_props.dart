import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class FormFieldError extends StatelessWidget {
  final String errorText;
  const FormFieldError(this.errorText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widthSpace(8),
        Icon(Symbols.error_outline, color: AppColors.red, size: 20.r),
        widthSpace(8),
        Expanded(child: Text(errorText, style: AppTextStyles.error)),
        widthSpace(8),
      ],
    );
  }
}

class FormFieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextStyle style;

  final VoidCallback? onAdd;

  FormFieldLabel(
    this.label, {
    super.key,
    this.isRequired = false,
    TextStyle? style,
    this.onAdd,
  }) : style = style ?? AppTextStyles.medium;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              text: label,
              style: style.copyWith(color: AppColors.white),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: style.copyWith(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
        if (onAdd != null)
          InkWell(
            // Add button
            onTap: onAdd,
            child: Icon(
              Symbols.add_circle_outline,
              color: AppColors.black,
            ),
          ),
      ],
    );
  }
}
