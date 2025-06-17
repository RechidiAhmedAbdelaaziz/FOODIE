import 'package:app/core/di/locator.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/services/qr/qr_service.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/modules/foodlist/ui/client_food_menu_screen.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

class TableHeader extends StatelessWidget {
  final TableModel table;
  const TableHeader(this.table, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
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
                style: AppTextStyles.normal.copyWith(
                  color: AppColors.white,
                ),
              ),
              TextSpan(
                text: table.restaurant?.name,
                style: AppTextStyles.large.copyWith(
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
            crossAxisAlignment: CrossAxisAlignment.center,

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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  final qrService = locator<QrService>();
                  final result = await qrService.scanQrCode(context);
                  if (result != null) {
                    // ignore: use_build_context_synchronously
                    context.off(
                      AppRoutes.tableFoodMenu,
                      TableFoodMenuParams(
                        result['tableId'] as String? ?? '',
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(
                    Symbols.qr_code_scanner,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
