import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../themes/colors.dart';

extension DialogExtension on BuildContext {
  /// Show a dialog with the given [child] widget.
  /// [T] is the type of the result that will be returned when the dialog is closed.
  Future<T?> dialog<T>({required Widget child, 
    bool canPop = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: canPop,
      builder: (_) => Stack(
      alignment: Alignment.center,
      children: [Material(color: Colors.transparent, child: child)],
      ),
    );
  }

  /// Show a dialog with the given [child] widget.
  /// [T] is the type of the result that will be returned when the dialog is closed.
  /// [onResult] is called when the dialog is closed with a result.
  /// [onError] is called when the dialog is closed without a result.
  void dialogWith<T>({
    required Widget child,
    required void Function(T) onResult,
    VoidCallback? onError,
    bool canPop = true,
  }) async {
    final result = await dialog<T>(child: child, canPop: canPop);
    result != null ? onResult(result) : onError?.call();
  }

  /// Show a alert dialog with the given [title] and [content].
  /// [onConfirm] is called when the user press the ok button.
  /// [onCancel] is called when the user press the cancel button.
  /// [okText] is the text of the ok button.
  /// [cancelText] is the text of the cancel button.
  Future<void> alertDialog({
    required String title,
    required String? content,
    required VoidCallback onConfirm,
    bool canPop = false,
    VoidCallback? onCancel,
    String okText = 'Ok',
    String cancelText = 'Cancel',
  }) async {
    return showDialog(
      context: this,
      barrierDismissible: canPop,
      builder: (context) => Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 40.h,
            ),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.tr(context),
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.greenLight,
                  ),
                ),
                if (content != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    content.tr(context),
                    style: AppTextStyles.normal.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton.secondary(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      text: cancelText.tr(context),
                      onPressed: () {
                        onCancel?.call();
                        context.back();
                      },
                    ),
                    SizedBox(width: 8.w),
                    AppButton.primary(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      text: okText.tr(context),
                      onPressed: () {
                        onConfirm();
                        context.back();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorDialog(String message, {
    bool canPop = true,
  }) {
    showDialog(
      context: this,
      barrierDismissible: canPop,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.black,

        title: Row(
          spacing: 8.w,
          children: [
            Icon(Symbols.error, color: AppColors.red, size: 32.r),
            Text(
              'Error'.tr(this),
              style: AppTextStyles.h3.copyWith(color: AppColors.red),
            ),
          ],
        ),
        content: Text(
          message.tr(this),
          style: AppTextStyles.medium.copyWith(
            color: AppColors.white,
          ),
        ),
        actions: [
          AppButton.secondary(
            text: 'TryAgain'.tr(this),
            onPressed: () => back(),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(String message, {
    bool canPop = true,
  }) {
    showDialog(
      context: this,
      barrierDismissible: canPop,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.black,
        title: Row(
          spacing: 8.w,
          children: [
            Icon(Symbols.check_circle, color: AppColors.greenLight, size: 32.r),
            Text(
              'Success'.tr(this),
              style: AppTextStyles.h3.copyWith(color: AppColors.greenLight),
            ),
          ],
        ),
        content: Text(
          message.tr(this),
          style: AppTextStyles.medium.copyWith(
            color: AppColors.white,
          ),
        ),
        actions: [
          AppButton.primary(
            text: 'Ok'.tr(this),
            onPressed: () => back(),
          ),
        ],
      ),
    );
  }


  
}
