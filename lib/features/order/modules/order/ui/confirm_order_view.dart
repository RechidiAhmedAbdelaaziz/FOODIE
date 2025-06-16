import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/order/modules/order/logic/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ConfirmOrderView extends StatelessWidget {
  const ConfirmOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final dto = context.read<OrderCubit>().dto;
    final ordersController = dto.menuController;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: ordersController,
        builder: (context, orders, child) {
          return Column(
            children: [
              Text(
                'Your Order',
                style: AppTextStyles.large.copyWith(
                  color: AppColors.white,
                ),
              ),
              heightSpace(12),

              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, i) {
                    final order = orders[i];

                    final food = order.foodController.value;
                    final addOns = order.addOnsController.value;
                    final quantityController =
                        order.quantityController;
                    return Container(
                      height: 120.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 12.w,
                      ),
                      // margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        spacing: 8.w,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.h,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
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
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 8.w,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        food?.name ?? 'Unknown Food',
                                        style: AppTextStyles.large
                                            .copyWith(
                                              color: AppColors.white,
                                            ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        context.alertDialog(
                                          title: 'Delete Order',
                                          content:
                                              'Are you sure you want to delete this order?',
                                          onConfirm: () =>
                                              ordersController
                                                  .removeValue(order),
                                        );
                                      },
                                      child: Icon(
                                        Symbols.delete,
                                        color: AppColors.red,
                                        // size: 20.r,
                                      ),
                                    ),
                                  ],
                                ),

                                Expanded(
                                  child: Text(
                                    addOns.isNotEmpty
                                        ? "(${addOns.map((e) => e.name).join(', ')})"
                                        : '',
                                    style: AppTextStyles.small
                                        .copyWith(
                                          color: AppColors.white,
                                        ),
                                  ),
                                ),

                                ValueListenableBuilder(
                                  valueListenable: quantityController,
                                  builder: (context, quantity, child) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${order.price} DA',
                                            style: AppTextStyles
                                                .medium
                                                .copyWith(
                                                  color:
                                                      AppColors.white,
                                                ),
                                          ),
                                        ),
                                        Row(
                                          spacing: 8.w,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (quantityController
                                                        .value >
                                                    1) {
                                                  quantityController
                                                      .value--;
                                                }
                                              },
                                              child: Icon(
                                                Symbols.remove_circle,
                                                color:
                                                    AppColors.white,
                                                size: 24.r,
                                              ),
                                            ),

                                            Text(
                                              quantity.toString(),
                                              style: AppTextStyles
                                                  .normal
                                                  .copyWith(
                                                    color: AppColors
                                                        .white,
                                                  ),
                                            ),

                                            GestureDetector(
                                              onTap: () {
                                                quantityController
                                                    .value++;
                                              },
                                              child: Icon(
                                                Symbols.add_circle,
                                                color:
                                                    AppColors.white,
                                                size: 24.r,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      Divider(color: AppColors.green),
                  itemCount: orders.length,
                ),
              ),

              //confirm button
              AppButton.primary(
                text: "Confirm".tr(context),
                onPressed: () => context.back(true),
              ),
            ],
          );
        },
      ),
    );
  }
}
