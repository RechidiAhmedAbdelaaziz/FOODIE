import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

abstract class AppTextStyles {
  static TextStyle h1 = TextStyle(
    fontSize: 48.spMin,
    fontWeight: FontWeight.bold,
  );

  static TextStyle h2 = TextStyle(
    fontSize: 36.spMin,
    fontWeight: FontWeight.bold,
  );

  static TextStyle h3 = TextStyle(
    fontSize: 28.spMin,
    fontWeight: FontWeight.bold,
  );

  static TextStyle h4 = TextStyle(
    fontSize: 24.spMin,
    fontWeight: FontWeight.w600,
  );

  static TextStyle xLarge = TextStyle(
    fontSize: 22.spMin,
    fontWeight: FontWeight.w500,
  );

  static TextStyle large = TextStyle(
    fontSize: 20.spMin,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium = TextStyle(
    fontSize: 18.spMin,
    fontWeight: FontWeight.w400,
  );

  static TextStyle normal = TextStyle(
    fontSize: 16.spMin,
    fontWeight: FontWeight.w400,
  );

  static TextStyle small = TextStyle(
    fontSize: 14.spMin,
    fontWeight: FontWeight.w400,
  );

  static TextStyle hint = TextStyle(
    fontSize: 12.spMin,
    fontWeight: FontWeight.w300,
  );

  static TextStyle primaryButton = TextStyle(
    fontSize: 18.spMin,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static TextStyle secondaryButton = TextStyle(
    fontSize: 16.spMin,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static TextStyle link = TextStyle(
    fontSize: 16.spMin,
    fontWeight: FontWeight.w400,
    color: AppColors.greenLight,
    decoration: TextDecoration.underline,
  );

  static TextStyle error = TextStyle(
    fontSize: 14.spMin,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
  );
}
