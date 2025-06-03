import 'package:app/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

abstract class AppThemes {
  static ThemeData get theme => ThemeData(
    primaryColor: AppColors.green,

    fontFamily: FontFamily.poppins,
    scaffoldBackgroundColor: AppColors.black,

    //theme of status bar
    appBarTheme: AppBarTheme(
      // backgroundColor: AppColors.black,
      color: AppColors.black,
      elevation: 0,
    ),
  );
}
