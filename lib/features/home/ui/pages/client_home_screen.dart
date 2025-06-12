import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_logo.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/banners/modules/banners/ui/home_banners.dart';
import 'package:app/features/restaurant/modules/restaurants/ui/restaurants_screen.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppLogo()),
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
              'Categories',
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
        _buildCategoryItem(Assets.images.restaurants, 'restaurant', context),
        _buildCategoryItem(Assets.images.fastFood, 'fastFood', context),
        _buildCategoryItem(Assets.images.breakfast, 'breakfast', context),
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
      child: image.image(
        width: 170.w,
        height: 167.h,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'Image not found',
              style: AppTextStyles.small,
            ),
          ),
        ),
      ),
    );
  }
}
