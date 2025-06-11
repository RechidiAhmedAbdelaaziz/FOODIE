import 'package:app/core/flavors/flavors_screen.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/features/order/modules/logic/orders_cubit.dart';
import 'package:app/features/order/modules/pages/orders_screen_base.dart';
import 'package:app/features/order/modules/pages/orders_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends FlavorsScreen {
  const OrdersScreen({super.key});

  static RouteBase get route => GoRoute(
    path: AppRoutes.orders.path,
    builder: (context, state) => BlocProvider(
      create: (context) => OrdersCubit()..fetchOrders(),
      child: const OrdersScreen(),
    ),
  );

  @override
  Widget get ownerScreen => OwnerOrderScreen();
}
