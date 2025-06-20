import 'package:app/core/flavors/flavors_screen.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/features/order/modules/orders/logic/orders_cubit.dart';
import 'package:app/features/order/modules/orders/pages/server_orders_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'pages/owener_order_screen.dart';

class OrdersScreen extends FlavorsScreen {
  const OrdersScreen({super.key});

  static RouteBase get route => GoRoute(
    path: AppRoutes.orders.path,
    builder: (context, state) => BlocProvider(
      lazy: false,
      create: (context) => OrdersCubit()..fetchOrders(),
      child: const OrdersScreen(),
    ),
  );

  @override
  Widget get ownerScreen => const OwnerOrderScreen();

  @override
  Widget get serverScreen =>  ServerOrderScreen();
}
