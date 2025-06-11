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

  final bool? isDelivered;
  final bool? isPaid;

  const OrderModel({
    this.id,
    this.table,
    this.isDelivered,
    this.isPaid,
    this.foods,
  });

  int get totalPrice {
    int total = 0;
    if (foods != null) {
      for (var orderData in foods!) {
        total += orderData.price;
      }
    }
    return total;
  }

  List<OrderData> get mergedFoods => foods?.merged ?? [];

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  @override
  List<Object?> get props => [id];
}

@JsonSerializable(createToJson: false)
class OrderData {
  final FoodModel? food;
  final List<AddOnsModel>? addOns;
  final int? quantity;

  const OrderData({this.food, this.addOns, this.quantity});

  int get price {
    int total = food?.price ?? 0;
    if (addOns != null) {
      for (var addOn in addOns!) {
        total += addOn.price ?? 0;
      }
    }
    return total * (quantity ?? 1);
  }

  bool isEquale(OrderData other) {
    return food == other.food && listEquals(addOns, other.addOns);
  }

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);
}

extension OrderDataListExtension on List<OrderData> {
  List<OrderData> get merged {
    List<OrderData> result = [];

    for (var currentOrderData in this) {
      final existingIndex = result.indexWhere(
        (element) => element.isEquale(currentOrderData),
      );

      if (existingIndex != -1) {
        OrderData existingOrder = result[existingIndex];
        result[existingIndex] = OrderData(
          food: existingOrder.food,
          addOns: existingOrder.addOns,
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
