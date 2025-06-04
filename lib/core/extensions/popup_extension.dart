import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/router/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../themes/colors.dart';

extension DialogExtension on BuildContext {
  /// Show a dialog with the given [child] widget.
  /// [T] is the type of the result that will be returned when the dialog is closed.
  Future<T?> dialog<T>({required Widget child}) {
    return showDialog<T>(
      context: this,
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
  }) async {
    final result = await dialog<T>(child: child);
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
    VoidCallback? onCancel,
    String okText = 'Ok',
    String cancelText = 'Cancel',
  }) async {
    return showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title.tr(context)),
        content: content != null ? Text(content.tr(context)) : null,
        actions: [
          AppButton.secondary(
            text: cancelText.tr(context),
            onPressed: () {
              onCancel?.call();
              context.back();
            },
          ),
          AppButton.primary(
            text: okText.tr(context),
            onPressed: () {
              onConfirm();
              context.back();
            },
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: this,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,

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
        content: Text(message.tr(this), style: AppTextStyles.medium),
        actions: [
          AppButton.secondary(
            text: 'TryAgain'.tr(this),
            onPressed: () => back(),
          ),
        ],
      ),
    );
  }
}
