import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/order/modules/order/logic/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final dto = context.read<OrderCubit>().dto;
    final isLoading = context.select<OrderCubit, bool>(
      (cubit) => cubit.state.isLoading,
    );
    return isLoading
        ? Center(
            child: CircularProgressIndicator(color: AppColors.green),
          )
        : Scaffold(
            appBar: AppBar(title: Text('Order Details'.tr(context))),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: dto.menuController,
                      builder: (context, value, child) {
                        return Column(
                          children:
                              value.map<Widget>((order) {
                                final food =
                                    order.foodController.value;
                                final addOns =
                                    order.addOnsController.value;
                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: 12.h,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.blue,
                                    borderRadius:
                                        BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    spacing: 8.w,
                                    children: [
                                      Container(
                                        width: 100.w,
                                        height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(
                                                12.r,
                                              ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              food?.image ?? '',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      //food name and addOns
                                                      Text(
                                                        food?.name ??
                                                            '',
                                                        style: AppTextStyles
                                                            .large
                                                            .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                      ),

                                                      if (addOns
                                                          .isNotEmpty)
                                                        Text(
                                                          addOns
                                                              .map(
                                                                (
                                                                  e,
                                                                ) => e
                                                                    .name,
                                                              )
                                                              .join(
                                                                ', ',
                                                              ),
                                                          style: AppTextStyles
                                                              .small
                                                              .copyWith(
                                                                color:
                                                                    AppColors.white,
                                                              ),
                                                        ),
                                                    ],
                                                  ),
                                                ),

                                                //remove button
                                                IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<
                                                          OrderCubit
                                                        >()
                                                        .dto
                                                        .menuController
                                                        .removeValue(
                                                          order,
                                                        );
                                                  },
                                                  icon: const Icon(
                                                    Symbols
                                                        .remove_circle,
                                                    color:
                                                        AppColors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // price and quantity
                                      ValueListenableBuilder(
                                        valueListenable:
                                            order.quantityController,
                                        builder: (context, value, child) {
                                          return Row(
                                            children: [
                                              //price
                                              Expanded(
                                                child: Text(
                                                  '${order.price} DA',
                                                  style: AppTextStyles
                                                      .large
                                                      .copyWith(
                                                        color:
                                                            AppColors
                                                                .green,
                                                      ),
                                                ),
                                              ),

                                              //quantity with buttons
                                              IconButton(
                                                onPressed: () {
                                                  if (value > 1) {
                                                    order
                                                        .quantityController
                                                        .subtract(-1);
                                                  }
                                                },
                                                icon: const Icon(
                                                  Symbols
                                                      .remove_circle,
                                                  color:
                                                      AppColors.white,
                                                ),
                                              ),
                                              widthSpace(4),
                                              Text(
                                                value.toString(),
                                                style: AppTextStyles
                                                    .large
                                                    .copyWith(
                                                      color: AppColors
                                                          .white,
                                                    ),
                                              ),
                                              widthSpace(4),
                                              IconButton(
                                                onPressed: () {
                                                  order
                                                      .quantityController
                                                      .add(1);
                                                },
                                                icon: const Icon(
                                                  Symbols.add_circle,
                                                  color:
                                                      AppColors.white,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList() +
                              [
                                heightSpace(12),
                                AppButton.primary(
                                  text:
                                      '${'Checkout'.tr(context)} (${dto.totalPrice})',
                                  onPressed: () {
                                    context
                                        .read<OrderCubit>()
                                        .saveOrder();
                                  },
                                ),
                                heightSpace(12),
                              ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
