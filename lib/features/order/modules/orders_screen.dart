import 'package:app/core/flavors/flavors_screen.dart';
import 'package:app/features/order/modules/pages/restaurant_orders_screen.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends FlavorsScreen {
  const OrdersScreen({super.key});

  @override
  Widget get ownerScreen => RestaurantOrdersScreen();
}
