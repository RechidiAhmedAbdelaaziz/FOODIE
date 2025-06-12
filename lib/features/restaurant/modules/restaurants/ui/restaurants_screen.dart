import 'package:app/core/routing/app_route.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/shared/widgets/app_search_bar.dart';
import 'package:app/core/shared/widgets/pagination_builder.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/restaurant/data/dto/restaurant_filter_dto.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:app/features/restaurant/modules/restaurants/logic/restaurants_cubit.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantFilterParams extends RouteParams {
  final String type;

  RestaurantFilterParams({required this.type})
    : super(queryParams: {'type': type});
}

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({super.key});

  static RouteBase get route => GoRoute(
    path: AppRoutes.restaurants.path,
    builder: (context, state) {
      final type = state.uri.queryParameters['type'] ?? '';

      return BlocProvider(
        create: (context) =>
            RestaurantsCubit(filter: RestaurantFilterDTO(type: type)),
        child: RestaurantsScreen(),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RestaurantsCubit>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          //TODO: add qr code scanner
        ],
      ),
      body: Column(
        spacing: 12.h,
        children: [
          AppSearchBar(
            controller: cubit.filter.keywordController,
            onChanged: (_) => cubit.refresh(),
          ),
          heightSpace(16),

          Expanded(
            child: PaginationBuilder(
              items: (ctx) =>
                  ctx.watch<RestaurantsCubit>().restaurants,
              itemBuilder: _buildRestaurantItem,
              isLoading: (ctx) =>
                  ctx.watch<RestaurantsCubit>().state.isLoading,
              onLoadMore: cubit.fetchRestaurants,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantItem(
    BuildContext context,
    RestaurantModel item,
  ) {
    return InkWell(
      // when click open the restaurant map link
      onTap: () {
        if (item.googleMapLink != null) {
          launchUrl(Uri.parse(item.googleMapLink!));
        }
      },

      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border(
            bottom: BorderSide(color: AppColors.white),
            top: BorderSide(color: AppColors.white),
          ),
        ),
        child: Column(
          children: [
            // The cover image
            SizedBox(
              height: 180.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      item.image ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.error),
                    ),
                  ),

                  if (item.isNightTimeOpen)
                    PositionedDirectional(
                      top: 8.h,
                      end: 12.w,
                      child: Icon(
                        Symbols.nightlight,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),

                  //Socia Media
                  PositionedDirectional(
                    bottom: 8.h,
                    start: 12.w,
                    child: Row(
                      spacing: 16.w,
                      children: [
                        if (item.facebookLink != null)
                          _buildSocialMediaIcon(
                            context,
                            item.facebookLink!,
                            Assets.svg.facebook,
                          ),

                        if (item.instagramLink != null)
                          _buildSocialMediaIcon(
                            context,
                            item.instagramLink!,
                            Assets.svg.instagram,
                          ),

                        if (item.tiktokLink != null)
                          _buildSocialMediaIcon(
                            context,
                            item.tiktokLink!,
                            Assets.svg.tiktok,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //title and description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name ?? '',
                          style: AppTextStyles.xLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),

                      if (item.isPrePaid ?? false)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            spacing: 8.w,
                            children: [
                              Icon(
                                Symbols.payment,
                                color: AppColors.white,
                                size: 16.sp,
                              ),
                              Text(
                                'Pre-Paid',
                                style: AppTextStyles.medium.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  heightSpace(4),
                  Text(
                    item.description ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.medium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcon(
    BuildContext context,
    String url,
    String iconPath,
  ) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: SvgPicture.asset(iconPath),
    );
  }
}
