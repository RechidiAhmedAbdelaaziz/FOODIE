import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/food/modules/foodform/ui/food_form_screen.dart';
import 'package:app/features/food/modules/foodlist/logic/food_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class FoodMenuScreen extends StatelessWidget {
  final categoryController = EditingController<String>();

  FoodMenuScreen({super.key});

  static RouteBase get route => GoRoute(
    path: AppRoutes.foodMenu.path,
    builder: (context, state) => BlocProvider(
      lazy: false,
      create: (_) =>
          FoodListCubit(fields: FoodModelFields.owner)..fetchFoods(),
      child: FoodMenuScreen(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (FoodListCubit cubit) => cubit.state.isLoading,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Food Menu'.tr(context))),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
              ),
            )
          : Builder(
              builder: (context) {
                final cubit = context.read<FoodListCubit>();
                categoryController.initValue(
                  cubit.categories.firstOrNull ?? '',
                );
                return ValueListenableBuilder(
                  valueListenable: categoryController,
                  builder: (context, selected, child) {
                    return SingleChildScrollView(
                      child: Column(
                        spacing: 4.h,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 4.w,
                              mainAxisAlignment:
                                  MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: cubit.categories
                                  .map(
                                    (category) => InkWell(
                                      onTap: () => categoryController
                                          .setValue(category),
                                      child: _buildCatogoryButton(
                                        context,
                                        category,
                                        selected == category,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                          ...cubit.foods
                              .where(
                                (food) =>
                                    food.category == selected ||
                                    selected == null,
                              )
                              .map((food) => _FoodItem(food)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  // category button is white when not selected, and AppColors.green when selected with point
  Widget _buildCatogoryButton(
    BuildContext context,
    String category,
    bool isSelected,
  ) {
    return Padding(
      padding: EdgeInsets.all(4.r),
      child: Column(
        spacing: 4.h,
        children: [
          Text(
            category.tr(context),
            style: AppTextStyles.medium.copyWith(
              color: isSelected ? AppColors.green : AppColors.white,
            ),
          ),
          if (isSelected)
            Container(
              width: 4.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
        ],
      ),
    );
  }
}

class _FoodItem extends StatelessWidget {
  final FoodModel food;

  const _FoodItem(this.food);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border(
          bottom: BorderSide(color: AppColors.green, width: 1.w),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              image: DecorationImage(
                image: NetworkImage(food.image ?? ''),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Row(
                  spacing: 2.w,
                  children: [
                    // food name and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.large.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            food.description ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () => context.to(
                        AppRoutes.updateFood,
                        UpdateFoodFormParams(food),
                      ),

                      icon: const Icon(
                        Symbols.edit,
                        color: AppColors.white,
                      ),
                    ),

                    IconButton(
                      onPressed: () => context.alertDialog(
                        title: 'Delete Food'.tr(context),
                        content:
                            'Are you sure you want to delete this food?'
                                .tr(context),
                        onConfirm: () => context
                            .read<FoodListCubit>()
                            .removeFood(food),
                      ),
                      icon: const Icon(
                        Symbols.delete,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),

                // price and availability
                Row(
                  spacing: 2.w,
                  children: [
                    Expanded(
                      child: Text(
                        '${food.price ?? 0} DZD',
                        style: AppTextStyles.medium.copyWith(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    food.isAvailable == true
                        ? AppButton.secondary(
                            text: 'Mark as unavailable'.tr(context),
                            color: AppColors.red,
                            textColor: AppColors.red,
                            onPressed: () => context
                                .read<FoodListCubit>()
                                .updateAvailability(food),
                          )
                        : AppButton.primary(
                            text: 'Mark as available'.tr(context),
                            onPressed: () => context
                                .read<FoodListCubit>()
                                .updateAvailability(food),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
