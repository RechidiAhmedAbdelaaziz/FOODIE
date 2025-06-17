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
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            icon: const Icon(
              Symbols.qr_code_scanner,
              color: AppColors.green,
            ),
            onPressed: () async {
              final qrService = locator<QrService>();
              final result = await qrService.scanQrCode(context);
              if (result != null) {
                // ignore: use_build_context_synchronously
                context.to(
                  AppRoutes.tableFoodMenu,
                  TableFoodMenuParams(
                    result['tableId'] as String? ?? '',
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        child: Column(
          spacing: 16.h,
          children: [
            HomeBanners(),
            heightSpace(16),

            Text(
              'Categories'.tr(context),
              style: AppTextStyles.medium.copyWith(
                color: AppColors.white,
              ),
            ),
            _buildCategoryList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: [
        _buildCategoryItem(Assets.images.cafes, 'cafe', context),
        _buildCategoryItem(
          Assets.images.restaurants,
          'restaurant',
          context,
        ),
        _buildCategoryItem(
          Assets.images.fastFood,
          'fastFood',
          context,
        ),
        _buildCategoryItem(
          Assets.images.breakfast,
          'breakfast',
          context,
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    AssetGenImage image,
    String type,
    BuildContext coontet,
  ) {
    return GestureDetector(
      onTap: () => coontet.to(
        AppRoutes.restaurants,
        RestaurantFilterParams(type: type),
      ),
      child: SizedBox(
        width: 170.w,
        height: 167.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: image.image(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          'Image not found',
                          style: AppTextStyles.small,
                        ),
                      ),
                    ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
                horizontal: 16.w,
              ),
              decoration: BoxDecoration(
                // color: AppColors.blue,
                borderRadius: BorderRadius.circular(12.r),
              ),
              // alignment: Alignment.center,
              child: Text(
                type.tr(coontet),
                style: AppTextStyles.normal.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
