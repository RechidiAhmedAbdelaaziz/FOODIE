import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:app/features/order/modules/orders/logic/orders_cubit.dart';
import 'package:app/features/order/modules/orders/pages/orders_screen_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class ServerOrderScreen extends OrderScreenBase {
  const ServerOrderScreen({super.key});

  @override
  Widget builder(List<OrderModel> orders) {
    return ListView.separated(
      itemBuilder: (context, i) =>
          _buildOrderCard(context, orders[i]),
      separatorBuilder: (_, __) => heightSpace(12),
      itemCount: orders.length,
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.white),
      ),
      child: Column(
        children: [
          //table name and price
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: Text(
                  order.table?.name ?? 'Unknown Table',
                  style: AppTextStyles.large.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: order.totalPrice.toStringAsFixed(0),
                      style: AppTextStyles.h4.copyWith(
                        color: order.isPaid ?? false
                            ? AppColors.greenLight
                            : AppColors.red,
                      ),
                    ),
                    TextSpan(
                      text: ' DZD',
                      style: AppTextStyles.small.copyWith(
                        color: order.isPaid ?? false
                            ? AppColors.greenLight
                            : AppColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          //foods list
          if (order.foods?.isNotEmpty == true)
            ...order.foods!.map(
              (order) => Row(
                spacing: 8.w,
                children: [
                  // food name with add-ons like this : Food Name (Add-on1, Add-on2)
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: order.food?.name ?? '',
                            style: AppTextStyles.large.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          TextSpan(
                            text: order.addOns?.isNotEmpty == true
                                ? ' (${order.addOns?.map((e) => e.name).join(', ')})'
                                : '',
                            style: AppTextStyles.normal.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // quantity
                  Text(
                    '${order.quantity}',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),

          //action buttons
          Row(
            spacing: 26.w,
            children: [
              // mark as paid if not paid
              if (!(order.isPaid ?? false))
                AppButton.secondary(
                  onPressed: () => context
                      .read<OrdersCubit>()
                      .markOrderAsPaid(order),
                  text: 'Mark as Paid',
                ),

              // mark as delivered if not delivered
              if (!(order.isDelivered ?? false))
                AppButton.primary(
                  onPressed: () => context
                      .read<OrdersCubit>()
                      .markOrderAsDelivered(order),
                  text: 'Mark as Delivered',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
