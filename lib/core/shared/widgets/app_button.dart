import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final IconData? suffixIcon;

  final void Function()? onPressed;

  final bool Function(BuildContext context)? isLoading;

  final Color? color;
  final Color? borderColor;
  final TextStyle textStyle;

  final EdgeInsetsGeometry? padding;

  const AppButton._({
    this.text,
    this.suffixIcon,
    this.onPressed,
    this.isLoading,
    this.color,
    this.borderColor,
    required this.textStyle,
    this.padding,
  });
  factory AppButton.primary({
    String? text,
    IconData? suffixIcon,
    void Function()? onPressed,
    bool Function(BuildContext context)? isLoading,
    Color? color,
    Color? textColor,
    EdgeInsetsGeometry? padding,
  }) => AppButton._(
    text: text,
    suffixIcon: suffixIcon,
    onPressed: onPressed,
    isLoading: isLoading,
    color: color ?? AppColors.greenLight,
    textStyle: AppTextStyles.primaryButton.copyWith(
      color: textColor ?? AppColors.blue,
    ),
    padding: padding,
  );

  factory AppButton.secondary({
    String? text,
    IconData? suffixIcon,
    void Function()? onPressed,
    bool Function(BuildContext context)? isLoading,
    Color? color,
    Color? textColor,
    EdgeInsetsGeometry? padding,
  }) => AppButton._(
    text: text,
    suffixIcon: suffixIcon,
    onPressed: onPressed,
    isLoading: isLoading,
    borderColor: color ?? AppColors.greenLight,
    textStyle: AppTextStyles.secondaryButton.copyWith(
      color: textColor ?? AppColors.greenLight,
    ),
    padding: padding,
  );

  factory AppButton.hyperLink({
    required String text,
    IconData? suffixIcon,
    void Function()? onPressed,
    bool Function(BuildContext context)? isLoading,
    EdgeInsetsGeometry? padding,
  }) => AppButton._(
    text: text,
    suffixIcon: suffixIcon,
    onPressed: onPressed,
    isLoading: isLoading,
    textStyle: AppTextStyles.link,
    padding: padding,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24).r,

      child: Container(
        padding:
            padding ??
            EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(24).r,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 12.w,
          children: [
            if (text != null)
              Text(text!.tr(context), style: textStyle),

            //show loading indicator if isLoading is true, else show suffixIcon if it is not null
            if (isLoading?.call(context) == true)
              SizedBox(
                // width: 16.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  constraints: BoxConstraints(
                    minHeight: 25.r,
                    minWidth: 25.r,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textStyle.color ?? AppColors.white,
                  ),
                ),
              )
            else if (suffixIcon != null)
              SizedBox(
                child: Icon(
                  suffixIcon,
                  color: textStyle.color ?? AppColors.white,
                  size: 25.r,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
