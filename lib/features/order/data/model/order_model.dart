// ignore_for_file: library_private_types_in_public_api

import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable(createToJson: false)
class OrderModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final TableModel? table;
  final List<OrderData>? foods;
  final _AddressModel? address;

  final bool? isDelivered;
  final bool? isPaid;

  @JsonKey(defaultValue: 0)
  final int totalPrice;

  const OrderModel({
    this.id,
    this.table,
    this.address,
    this.isDelivered,
    this.isPaid,
    this.foods,
    required this.totalPrice,
  });

  List<OrderData> get mergedFoods {
    return foods?.merged ?? [];
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  @override
  List<Object?> get props => [id];
}

@JsonSerializable(createToJson: false)
class OrderData {
  final FoodModel? food;
  final List<String>? selectedAddOns;
  final int? quantity;
  // final int? price;

  const OrderData({
    this.food,
    this.selectedAddOns,
    this.quantity,
    // this.price,
  });

  bool isEquale(OrderData other) {
    final equal =
        food == other.food &&
        listEquals(selectedAddOns, other.selectedAddOns);

    return equal;
  }

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);
}

extension OrderDataListExtension on List<OrderData> {
  List<OrderData> get merged {
    List<OrderData> result = [];

    for (var currentOrderData in this) {
      final existingIndex = result.indexWhere((element) {
        return element.isEquale(currentOrderData);
      });

      if (existingIndex != -1) {
        OrderData existingOrder = result[existingIndex];
        result[existingIndex] = OrderData(
          food: existingOrder.food,
          selectedAddOns: existingOrder.selectedAddOns,
          quantity:
              (existingOrder.quantity ?? 0) +
              (currentOrderData.quantity ?? 0),
        );
      } else {
        result.add(currentOrderData);
      }
    }
    return result;
  }
}

@JsonSerializable(createToJson: false)
class _AddressModel {
  final List<double> coordinates;
  final String? contact;

  double get latitude => coordinates.isNotEmpty ? coordinates[0] : 0;
  double get longitude =>
      coordinates.length == 2 ? coordinates[1] : 0;

  _AddressModel({this.contact, this.coordinates = const []});

  factory _AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}
