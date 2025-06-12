import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableHeader extends StatelessWidget {
  final TableModel table;
  const TableHeader(this.table, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        // Welcome to [Restaurant Name]
        RichText(
          text: TextSpan(
            style: AppTextStyles.normal.copyWith(
              color: AppColors.white,
            ),
            children: [
              TextSpan(
                text: '${'Welcome to'.tr(context)} ',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(
                text: table.restaurant?.name,
                style: AppTextStyles.xLarge.copyWith(
                  color: AppColors.green,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.green),
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Table Name
                    Text(
                      'You are at'.tr(context),
                      style: AppTextStyles.normal.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    // Table Number
                    Text(
                      '${table.name}',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // Rescan QR Code Button //TODO: Implement this button
            ],
          ),
        ),
      ],
    );
  }
}
