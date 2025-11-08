import 'package:app/core/di/locator.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/staff/data/repository/staff_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaffTotalMoney extends StatefulWidget {
  const StaffTotalMoney({super.key});

  @override
  State<StaffTotalMoney> createState() => _StaffTotalMoneyState();
}

class _StaffTotalMoneyState extends State<StaffTotalMoney> {
  int _total = 0;

  @override
  void initState() {
    locator<StaffRepo>().getStaffMoney().then((result) {
      result.when(
        success: (total) => setState(() => _total = total),
        error: (_) {},
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Staff money'.tr(context),
            style: AppTextStyles.medium.copyWith(
              color: AppColors.white,
            ),
          ),
          heightSpace(8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _total.toString(),
                  style: AppTextStyles.large.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenLight,
                  ),
                ),
              ),
              widthSpace(4),
              Text(
                'DA'.tr(context),
                style: AppTextStyles.normal.copyWith(
                  color: AppColors.greenLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
