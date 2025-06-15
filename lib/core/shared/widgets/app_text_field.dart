import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/shared/widgets/form_field_props.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isRequired;

  final String? label;
  final String? hintText;

  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final Widget? suffixWidget;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter> inputFormatters;

  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    this.inputFormatters = const [],
    this.label,
    this.hintText,
    this.prefixIcon,
    this.isRequired = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.suffixWidget,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (_) => validator?.call(controller.text),
      builder: (state) {
        return Column(
          spacing: 8.h,
          children: [
            if (label != null)
              FormFieldLabel(
                label!.tr(context),
                isRequired: isRequired,
              ),

            TextField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,

              maxLines: keyboardType == TextInputType.multiline
                  ? null
                  : 1,

              style: AppTextStyles.normal.copyWith(
                color: AppColors.white,
              ),

              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 16.h,
                ),

                isCollapsed: true,
                isDense: true,

                fillColor: AppColors.blue,
                filled: true,

                hintText: hintText?.tr(context),
                hintStyle: AppTextStyles.normal.copyWith(
                  color: AppColors.grey,
                ),

                prefixIconConstraints: BoxConstraints(minWidth: 48.w),
                prefixIcon: prefixIcon != null
                    ? Icon(
                        prefixIcon,
                        color: AppColors.white,
                        size: 30.r,
                      )
                    : null,
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, color: AppColors.white)
                    : suffixWidget,

                error: state.hasError
                    ? FormFieldError(state.errorText!.tr(context))
                    : null,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: state.hasError
                      ? BorderSide(color: AppColors.red, width: 1.w)
                      : BorderSide.none,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
