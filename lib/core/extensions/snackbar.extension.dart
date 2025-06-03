import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

extension SnackbarExtension on BuildContext {
  void _showSnackbar(
    String message,
    Color color,
    Color textColor,
    IconData icon,
  ) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: Duration(seconds: 2),
        content: Row(
          children: [
            Icon(icon, color: textColor),
            widthSpace(10),
            Expanded(
              child: Text(
                message,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessSnackbar(String message) => _showSnackbar(
    message,
    AppColors.greenLight,
    Colors.white,
    Symbols.check_circle,
  );

  void showErrorSnackbar(String message) =>
      _showSnackbar(message, Colors.red, Colors.white, Symbols.error);

  void showInfoSnackbar(String message) =>
      _showSnackbar(message, Colors.blue, Colors.white, Symbols.info);

  void showWarningSnackbar(String message) => _showSnackbar(
    message,
    Colors.orange,
    Colors.white,
    Icons.warning,
  );
}
