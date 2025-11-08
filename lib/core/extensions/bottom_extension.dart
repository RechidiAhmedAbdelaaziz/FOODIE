import 'package:flutter/material.dart';

extension BottomSheetExtension on BuildContext {
  /// Show a bottom sheet with the given [child] widget.
  /// [T] is the type of the result that will be returned when the bottom sheet is closed.
  Future<T?> bottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      elevation: elevation,
      shape: shape,
      builder: (_) => child,
    );
  }

  /// Show a bottom sheet with the given [child] widget.
  /// [T] is the type of the result that will be returned when the bottom sheet is closed.
  /// [onResult] is called when the bottom sheet is closed with a result.
  /// [onError] is called when the bottom sheet is closed without a result.
  void bottomSheetWith<T>({
    required Widget child,
    required void Function(T) onResult,
    VoidCallback? onError,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) async {
    final result = await bottomSheet<T>(
      child: child,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
    );
    result != null ? onResult(result) : onError?.call();
  }
}
