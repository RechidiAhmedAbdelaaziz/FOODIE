import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/data/dto/food_filter_dto.dart';
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
      create: (_) => FoodListCubit(
        FoodFilterDTO(fields: FoodModelFields.owner.value, limit: 60),
      )..fetchFoods(),
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
                    return Column(
                      spacing: 12.h,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 12.w,
                            mainAxisAlignment:
                                MainAxisAlignment.start,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: cubit.categories
                                .map(
                                  (category) => InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor:
                                        Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    overlayColor:
                                        WidgetStateProperty.all(
                                          Colors.transparent,
                                        ),

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

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 8.h,
                              children: cubit.foods
                                  .where(
                                    (food) =>
                                        food.category == selected ||
                                        selected == null,
                                  )
                                  .map(
                                    (food) => _FoodItem(
                                      food,
                                      context.select(
                                        (FoodListCubit cubit) => cubit
                                            .state
                                            .isUpdating(food),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.toWith(
          AppRoutes.createFood,
          null,
          onResult: context.read<FoodListCubit>().addFood,
        ),
        backgroundColor: AppColors.green,
        child: const Icon(Symbols.add, color: AppColors.black),
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
        spacing: 2.h,
        children: [
          Text(
            category.tr(context),
            style: AppTextStyles.large.copyWith(
              color: isSelected ? AppColors.green : AppColors.white,
            ),
          ),
          if (isSelected)
            Container(
              width: 4.r,
              height: 4.r,
              decoration: BoxDecoration(
                color: AppColors.green,
                // borderRadius: BorderRadius.circular(4.r),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _FoodItem extends StatelessWidget {
  final FoodModel food;
  final bool isLoading;

  const _FoodItem(this.food, this.isLoading);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          bottom: BorderSide(color: AppColors.green, width: 1.w),
          top: BorderSide(color: AppColors.green, width: 1.w),
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: NetworkImage(food.image ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 4.h,
              children: [
                Row(
                  spacing: 8.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // food name and description
                    Expanded(
                      child: SizedBox(
                        height: 100.h,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.large.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                food.description ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.small.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () => context.toWith(
                        AppRoutes.updateFood,
                        UpdateFoodFormParams(food),
                        onResult: context
                            .read<FoodListCubit>()
                            .replaceFood,
                      ),

                      child: const Icon(
                        Symbols.edit,
                        color: AppColors.white,
                      ),
                    ),

                    InkWell(
                      onTap: () => context.alertDialog(
                        title: 'Delete Food'.tr(context),
                        content:
                            'Are you sure you want to delete this food?'
                                .tr(context),
                        onConfirm: () => context
                            .read<FoodListCubit>()
                            .removeFood(food),
                      ),
                      child: const Icon(
                        Symbols.delete,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${food.price ?? 0} ',
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.greenLight,
                              ),
                            ),
                            TextSpan(
                              text: 'DA',
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => context
                          .read<FoodListCubit>()
                          .updateAvailability(food),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: food.isAvailable ?? false
                              ? AppColors.green
                              : AppColors.red,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          food.isAvailable ?? false
                              ? 'Available'.tr(context)
                              : 'Unavailable'.tr(context),
                          style: AppTextStyles.normal.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (isLoading)
                  LinearProgressIndicator(color: AppColors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
