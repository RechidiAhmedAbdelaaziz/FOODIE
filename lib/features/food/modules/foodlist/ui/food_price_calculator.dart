import 'package:app/core/extensions/bottom_extension.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/app_logo.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/data/dto/food_filter_dto.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/food/modules/foodlist/logic/food_list_cubit.dart';
import 'package:app/features/order/data/dto/create_order_dto.dart';
import 'package:app/features/order/modules/order/ui/confirm_order_view.dart';
import 'package:app/features/order/modules/order/ui/food_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FoodPriceCalculator extends StatefulWidget {
  const FoodPriceCalculator({super.key});

  static RouteBase get route => GoRoute(
    path: AppRoutes.foodPriceCalculator.path,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => FoodListCubit(
          FoodFilterDTO(
            fields: FoodModelFields.owner.value,
            limit: 60,
          ),
        )..fetchFoods(),
        child: const FoodPriceCalculator(),
      );
    },
  );

  @override
  State<FoodPriceCalculator> createState() =>
      _FoodPriceCalculatorState();
}

class _FoodPriceCalculatorState extends State<FoodPriceCalculator> {
  late final CreateOrderDTO _orderDTO;
  late final EditingController<String> _categoryController;

  @override
  void initState() {
    _orderDTO = CreateOrderDTO();
    _categoryController = EditingController<String>();
    super.initState();
  }

  @override
  dispose() {
    _orderDTO.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<FoodListCubit>().state.isLoading;
    return MultiBlocListener(
      listeners: [
        BlocListener<FoodListCubit, FoodListState>(
          listener: (context, state) {
            state.onError(context.showErrorSnackbar);

            if (_categoryController.value == null &&
                context.read<FoodListCubit>().categories.isNotEmpty) {
              _categoryController.initValue(
                context.read<FoodListCubit>().categories.first,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: AppLogo()),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.green,
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Builder(
                  builder: (context) {
                    final cubit = context.read<FoodListCubit>();
                    return ValueListenableBuilder(
                      valueListenable: _categoryController,
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
                                        focusColor:
                                            Colors.transparent,
                                        highlightColor:
                                            Colors.transparent,
                                        hoverColor:
                                            Colors.transparent,
                                        splashColor:
                                            Colors.transparent,
                                        overlayColor:
                                            WidgetStateProperty.all(
                                              Colors.transparent,
                                            ),
                                        onTap: () =>
                                            _categoryController
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

                            SingleChildScrollView(
                              child: Column(
                                spacing: 8.h,
                                children: cubit.foods
                                    .where(
                                      (food) =>
                                          food.category == selected ||
                                          selected == null,
                                    )
                                    .map(
                                      (food) => FoodOrderCard(
                                        food,
                                        _orderDTO,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _orderDTO.menuController,
          builder: (context, selectedFoods, child) {
            if (selectedFoods.isEmpty) {
              return const SizedBox.shrink();
            }

            return InkWell(
              onTap: () {
                context.bottomSheetWith<bool>(
                  child: ConfirmOrderView(_orderDTO.menuController),
                  onResult: (_) => _orderDTO.menuController.setList(
                    _orderDTO.menuController.value,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_orderDTO.totalPrice} ',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      'DA'.tr(context),
                      style: AppTextStyles.medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
