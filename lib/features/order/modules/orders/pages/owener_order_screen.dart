import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'orders_screen_base.dart';

class OwnerOrderScreen extends OrderScreenBase {
  const OwnerOrderScreen({super.key});

  @override
  Widget builder(List<OrderModel> orders, BuildContext context) {
    final mergedOrders = orders
        .map((order) => order.foods ?? [])
        .expand((e) => e)
        .toList()
        .merged;

    return ListView.separated(
      itemBuilder: (context, i) =>
          _buildOrderCard(context, mergedOrders[i]),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: mergedOrders.length,
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderData order) {
    final food = order.food!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        spacing: 8.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              spacing: 8.w,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: NetworkImage(order.food?.image ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4.h,
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
                        order.selectedAddOns?.join(',') ?? '',
                        style: AppTextStyles.normal.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder:
                (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
            child: Text(
              '${order.quantity}',
              key: ValueKey<int>(order.quantity ?? 0),
              style: AppTextStyles.h4.copyWith(
                color: AppColors.greenLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

