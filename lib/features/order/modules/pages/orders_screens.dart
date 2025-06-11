import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:app/features/order/modules/pages/orders_screen_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerOrderScreen extends OrderScreenBase {
  const OwnerOrderScreen({super.key});

  @override
  Widget builder(List<OrderModel> orders) {
    final mergedOrders = orders
        .map((order) => order.mergedFoods)
        .expand((x) => x)
        .toList();

    return ListView.separated(
      itemBuilder: (context, i) =>
          _buildOrderCard(context, mergedOrders[i]),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: orders.length,
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderData order) {
    final food = order.food!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        spacing: 8.w,
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
                  order.addOns?.map((e) => e.name).join(',') ?? '',
                  style: AppTextStyles.normal.copyWith(
                    color: AppColors.white,
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
