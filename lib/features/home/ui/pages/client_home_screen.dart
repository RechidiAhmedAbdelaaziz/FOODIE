import 'package:app/core/constants/data.dart';
import 'package:app/core/di/locator.dart';
import 'package:app/core/localization/localization_button.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/services/qr/qr_service.dart';
import 'package:app/core/shared/widgets/app_logo.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/banners/modules/banners/ui/home_banners.dart';
import 'package:app/features/food/modules/foodlist/ui/client_food_menu_screen.dart';
import 'package:app/features/restaurant/modules/restaurants/ui/restaurants_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_symbols_icons/symbols.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LocalizationButton(),
        title: AppLogo(),
        actions: [
          IconButton(
            icon: const Icon(Symbols.qr_code_scanner, color: AppColors.green),
            onPressed: () async {
              final qrService = locator<QrService>();
              final result = await qrService.scanQrCode(context);
              if (result != null) {
                // ignore: use_build_context_synchronously
                context.to(
                  AppRoutes.tableFoodMenu,
                  RestaurantMenuParams(result['tableId'] as String? ?? ''),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomeBanners(),
            heightSpace(16),

            Text(
              'Categories'.tr(context),
              style: AppTextStyles.medium.copyWith(color: AppColors.white),
            ),

            Expanded(child: _buildCategoryList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return SingleChildScrollView(
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 8.w,
        children: AppData.serviceTypes.map((type) {
          final image =
              'assets/images/${type.toLowerCase().replaceAll('24/7', '').trim().replaceAll(' ', '_')}.png';

          return _buildCategoryItem(image, type, context);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryItem(String path, String type, BuildContext coontet) {
    return GestureDetector(
      onTap: () =>
          coontet.to(AppRoutes.restaurants, RestaurantFilterParams(type: type)),
      child: Container(
        width: 150.w,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.greenLight.withAlpha(200),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 140.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            heightSpace(8),
            Text(
              type.tr(coontet),
              style: AppTextStyles.medium.copyWith(color: AppColors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
