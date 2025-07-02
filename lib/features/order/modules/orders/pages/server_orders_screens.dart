import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/services/qr/qr_service.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/modules/foodlist/ui/client_food_menu_screen.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:app/features/order/modules/orders/logic/orders_cubit.dart';
import 'package:app/features/order/modules/orders/pages/orders_screen_base.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerOrderScreen extends OrderScreenBase {
  ServerOrderScreen({super.key});

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
            RestaurantMenuParams(result['tableId'] as String? ?? ''),
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

  final tableController = EditingController<String>("All");

  @override
  Widget builder(List<OrderModel> orders, BuildContext context) {
    final tables = orders
        .map((order) => order.table)
        .whereType<TableModel>()
        .map((table) => table.name ?? '')
        .toSet()
        .toList();

    return ValueListenableBuilder(
      valueListenable: tableController,
      builder: (context, value, child) {
        final filteredOrders = value == "All"
            ? orders
            : orders.where((order) {
                if (value?.isEmpty ?? false) return true;
                return order.table?.name == tableController.value;
              }).toList();

        return Column(
          children: [
            //tables list
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", ...tables]
                    .map(
                      (table) => _buildTableSelector(table, context),
                    )
                    .toList(),
              ),
            ),
            heightSpace(12),

            Expanded(
              child: ListView.separated(
                itemBuilder: (context, i) =>
                    _buildOrderCard(context, filteredOrders[i]),
                separatorBuilder: (_, __) => heightSpace(12),
                itemCount: filteredOrders.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableSelector(String tableName, BuildContext context) {
    final isSelected = tableController.value == tableName;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: InkWell(
        onTap: () => tableController.setValue(tableName),
        child: Text(
          tableName.tr(context),
          style: isSelected
              ? AppTextStyles.h4.copyWith(color: AppColors.greenLight)
              : AppTextStyles.medium.copyWith(color: AppColors.white),
        ),
      ),
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
              if (order.address != null)
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse(
                      'https://www.google.com/maps/?q=${order.address?.latitude},${order.address?.longitude}',
                    ),
                  ),
                  icon: Icon(
                    Symbols.location_on,
                    color: AppColors.greenLight,
                  ),
                ),

              if (order.address?.contact != null)
                IconButton(
                  onPressed: () {
                    final isEmail = order.address!.contact!.contains(
                      '@',
                    );
                    launchUrl(
                      isEmail
                          ? Uri.parse(
                              'mailto:${order.address!.contact}',
                            )
                          : Uri.parse(
                              'tel:${order.address!.contact}',
                            ),
                    );
                  },
                  icon: Icon(
                    Symbols.call,
                    color: AppColors.greenLight,
                  ),
                ),

              if (order.table != null)
                Expanded(
                  child: Text(
                    order.table?.name ?? 'Delivery',
                    style: AppTextStyles.h4.copyWith(
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
