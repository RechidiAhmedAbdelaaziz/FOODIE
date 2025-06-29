import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/localization/localization_button.dart';
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

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  TodayHistory? _todayHistory;
  StaffTotalMoney? _staffTodayEarn;

  @override
  void initState() {
    _todayHistory = const TodayHistory();
    _staffTodayEarn = const StaffTotalMoney();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LocalizationButton(),
        title: AppLogo(),
        actions: [
          //refrech button
          IconButton(
            onPressed: () async {
              setState(() {
                _todayHistory = null;
                _staffTodayEarn = null;
              });
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {
                _todayHistory = TodayHistory();
                _staffTodayEarn = StaffTotalMoney();
              });
            },
            icon: const Icon(Symbols.refresh),
          ),
        ],
      ),
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
                      onPressed: () =>
                          context.to(AppRoutes.history, null),
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
                  children: [_todayHistory, _staffTodayEarn]
                      .map(
                        (widget) =>
                            Expanded(child: widget ?? SizedBox()),
                      )
                      .toList(),
                ),
              ],
            ),
            heightSpace(12),

            // Restaurant Management
            _buildButton(
              context,
              Symbols.restaurant,
              'Restaurant Management',
              () => context.to(AppRoutes.updateRestaurant, null),
            ),

            //Staff  Management
            _buildButton(
              context,
              Symbols.people,
              'Staff Management',
              () => context.to(AppRoutes.staffs, null),
            ),

            //Menu Management
            _buildButton(
              context,
              Symbols.menu_book,
              'Menu Management',
              () => context.to(AppRoutes.foodMenu, null),
            ),

            //Table Management
            _buildButton(
              context,
              Symbols.table_bar,
              'Table Management',
              () => context.to(AppRoutes.tables, null),
            ),

            //Order Management
            _buildButton(
              context,
              Symbols.receipt_long,
              'Order Management',
              () => context.to(AppRoutes.orders, null),
            ),

            //Order by Table
            _buildButton(
              context,
              Symbols.table_bar,
              'Order by Table',
              () => context.to(AppRoutes.tableOrders, null),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        onPressed: () =>
            context.to(AppRoutes.foodPriceCalculator, null),
        child: const Icon(
          Symbols.receipt_long,
          color: AppColors.blue,
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
