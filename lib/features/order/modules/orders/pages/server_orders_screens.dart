import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/services/qr/qr_service.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/modules/foodlist/ui/client_food_menu_screen.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:app/features/order/modules/orders/logic/orders_cubit.dart';
import 'package:app/features/order/modules/orders/pages/orders_screen_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

class OwnerOrderScreen extends OrderScreenBase {
  const OwnerOrderScreen({super.key});

  @override
  Widget builder(List<OrderModel> orders) {
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

class ServerOrderScreen extends OrderScreenBase {
  const ServerOrderScreen({super.key});

  @override
  Widget floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.greenLight,
      onPressed: () async {
        final qrService = locator<QrService>();
        final result = await qrService.scanQrCode(context);
        if (result != null) {
          // ignore: use_build_context_synchronously
          context.to(
            AppRoutes.tableFoodMenu,
            TableFoodMenuParams(result['tableId'] as String? ?? ''),
          );
        }
      },
      child: Icon(
        Symbols.qr_code_scanner,
        size: 42.r,
        color: AppColors.blue,
      ),
    );
  }

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
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.white),
      ),
      child: Column(
        spacing: 12.h,
        children: [
          //table name and price
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: Text(
                  order.table?.name ?? 'Unknown Table',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: order.totalPrice.toString(),
                      style: AppTextStyles.h4.copyWith(
                        color: order.isPaid ?? false
                            ? AppColors.greenLight
                            : AppColors.red,
                      ),
                    ),
                    TextSpan(
                      text: ' DA',
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
          const Divider(),

          //foods list
          if (order.foods?.isNotEmpty == true)
            ...order.mergedFoods.map(
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
                            text:
                                order.selectedAddOns?.isNotEmpty ==
                                    true
                                ? ' (${order.selectedAddOns?.join(', ')})'
                                : '',
                            style: AppTextStyles.small.copyWith(
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
          const Divider(color: AppColors.greyDark),

          //action buttons
          Row(
            spacing: 20.w,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // mark as paid if not paid
              if (!(order.isPaid ?? false))
                AppButton.secondary(
                  onPressed: () => context.alertDialog(
                    title: 'Mark Order as Paid',
                    content:
                        'Are you sure you want to mark this order as paid?',
                    onConfirm: () => context
                        .read<OrdersCubit>()
                        .markOrderAsPaid(order),
                  ),
                  text: 'Mark as Paid',
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                ),

              // mark as delivered if not delivered
              if (!(order.isDelivered ?? false))
                AppButton.primary(
                  onPressed: () => context.alertDialog(
                    title: 'Mark Order as Delivered',
                    content:
                        'Are you sure you want to mark this order as delivered?',
                    onConfirm: () => context
                        .read<OrdersCubit>()
                        .markOrderAsDelivered(order),
                  ),
                  text: 'Mark as Delivered',
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
