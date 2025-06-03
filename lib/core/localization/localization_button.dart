import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'localization_cubit.dart';

class LocalizationButton extends StatelessWidget {
  const LocalizationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, Locale?>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),

          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.grey),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.w,
            children: [
              _buildLanguageButton(
                context: context,
                languageCode: 'en',
                text: 'English',
                isSelected: state?.languageCode == 'en',
              ),
              Container(
                height: 20.h,
                width: 1.w,
                color: AppColors.grey,
              ),
              _buildLanguageButton(
                context: context,
                languageCode: 'ar',
                text: 'العربية',
                isSelected: state?.languageCode == 'ar',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton({
    required BuildContext context,
    required String languageCode,
    required String text,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        context.read<LocalizationCubit>().changeLanguage(
          languageCode,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          style: AppTextStyles.xLarge.copyWith(
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
