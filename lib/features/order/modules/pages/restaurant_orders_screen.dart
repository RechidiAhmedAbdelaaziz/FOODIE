import 'package:app/features/order/data/model/order_model.dart';
import 'package:flutter/material.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({super.key});

  @override
  State<RestaurantOrdersScreen> createState() =>
      _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState
    extends State<RestaurantOrdersScreen> {
  List<OrderModel> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
