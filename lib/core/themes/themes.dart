import 'package:app/core/themes/font_styles.dart';
import 'package:app/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

abstract class AppThemes {
  static ThemeData get theme => ThemeData(
    primaryColor: AppColors.green,

    fontFamily: FontFamily.poppins,
    scaffoldBackgroundColor: AppColors.black,

    appBarTheme: AppBarTheme(
      // backgroundColor: AppColors.black,
      backgroundColor: AppColors.black,
      scrolledUnderElevation: 0,

      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.green,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.green,
      ),

      titleTextStyle: AppTextStyles.xLarge.copyWith(
        color: AppColors.white,
        letterSpacing: 1,
      ),
      centerTitle: true,

      iconTheme: IconThemeData(color: AppColors.white, size: 24.r),
    ),
  );
}
