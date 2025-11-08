import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'localization_cubit.dart';

class LocalizationButton extends StatelessWidget {
  const LocalizationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, Locale?>(
      builder: (context, state) {
        final currentLang = state?.languageCode ?? 'en';
        final langList = ['en', 'ar', 'fr'];

        return PopupMenuButton<String>(
          icon: Icon(Icons.language, color: AppColors.greenLight),
          onSelected: (value) {
            if (value != currentLang) {
              context.read<LocalizationCubit>().changeLanguage(value);
            }
          },
          color: AppColors.black,
          itemBuilder: (context) {
            return langList.map((lang) {
              return PopupMenuItem<String>(
                value: lang,
                child: Text(
                  lang.tr(context),
                  style: AppTextStyles.normal.copyWith(
                    color: AppColors.greenLight,
                  ),
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}
