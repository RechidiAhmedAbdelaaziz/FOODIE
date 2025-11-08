import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/services/sounds/sound_service.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:app/features/order/modules/orders/logic/orders_cubit.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OrderScreenBase extends StatelessWidget {
  Widget builder(List<OrderModel> orders, BuildContext context);
  
  Widget floatingActionButton(BuildContext context) =>
      const SizedBox.shrink();

  const OrderScreenBase({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        state.onError(context.showErrorSnackbar);

        state.onAddOrder((order) {
          locator<SoundService>().playSound(
            Assets.sounds.bellNotification,
          );
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'.tr(context)),
          actions: [
            //refresh button
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  context.read<OrdersCubit>().fetchOrders(),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            final isLoading = context.select(
              (OrdersCubit cubit) => cubit.state.isLoading,
            );

            return isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenLight,
                    ),
                  )
                : Builder(
                    builder: (context) {
                      final orders = context
                          .watch<OrdersCubit>()
                          .orders;
                      return orders.isEmpty
                          ? Center(
                              child: Text(
                                'No Orders'.tr(context),
                                style: AppTextStyles.medium,
                              ),
                            )
                          : builder(orders, context);
                    },
                  );
          },
        ),
        floatingActionButton: floatingActionButton(context),
      ),
    );
  }
}
