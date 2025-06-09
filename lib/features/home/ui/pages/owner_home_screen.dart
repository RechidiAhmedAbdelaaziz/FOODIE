import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_logo.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/history/modules/todayhistory/ui/today_history.dart';
import 'package:app/features/staff/modules/todayearn/ui/today_earn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppLogo()),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 8.h,
        ),
        child: Column(
          spacing: 8.h,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateTime.now().toLocal().toFormattedDate(),
                        style: AppTextStyles.normal.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.to(AppRoutes.history),
                      child: Text(
                        'See History'.tr(context),
                        style: AppTextStyles.normal.copyWith(
                          color: AppColors.greenLight,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  spacing: 12.w,
                  children: [
                    TodayHistory(),
                    TodayEarn(),
                  ].map((widget) => Expanded(child: widget)).toList(),
                ),
              ],
            ),
            heightSpace(12),

            // Restaurant Management
            _buildButton(
              context,
              Symbols.restaurant,
              'Restaurant Management',
              () {},
            ),

            //Staff  Management
            _buildButton(
              context,
              Symbols.people,
              'Staff Management',
              () => context.to(AppRoutes.staffs),
            ),

            //Menu Management
            _buildButton(
              context,
              Symbols.menu_book,
              'Menu Management',
              () => context.to(AppRoutes.foodMenu),
            ),

            //Table Management
            _buildButton(
              context,
              Symbols.table_bar,
              'Table Management',
              () => context.to(AppRoutes.tables),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          spacing: 8.w,
          children: [
            Icon(icon, color: AppColors.white, size: 40.r),

            Expanded(
              child: Text(
                title.tr(context),
                style: AppTextStyles.medium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),

            Icon(
              Symbols.arrow_forward_ios,
              color: AppColors.white,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}
