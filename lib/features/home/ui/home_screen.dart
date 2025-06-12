import 'package:app/core/flavors/flavors_screen.dart';
import 'package:app/features/home/ui/pages/client_home_screen.dart';
import 'package:app/features/home/ui/pages/owner_home_screen.dart';
import 'package:app/features/order/modules/orders/logic/orders_cubit.dart';
import 'package:app/features/order/modules/orders/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends FlavorsScreen {
  const HomeScreen({super.key});

  @override
  Widget get ownerScreen => OwnerHomeScreen();

  @override
  Widget get clientScreen => ClientHomeScreen();

  @override
  Widget get serverScreen => BlocProvider(
    lazy: false,
    create: (context) => OrdersCubit()..fetchOrders(),
    child: const OrdersScreen(),
  );
}
