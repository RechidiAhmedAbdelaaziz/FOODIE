import 'package:app/core/localization/app_localization.dart';
import 'package:flutter/material.dart';

extension LocalizationExtension on String {
  String tr(BuildContext context) =>
      AppLocalizations.of(context)?.translate(this) ?? this;

  void changeLanguage(BuildContext context, String langCode) {
    AppLocalizations.of(context)?.load();
  }
}
