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

  @JsonKey(defaultValue: 0)
  final int totalPrice;

  const OrderModel({
    this.id,
    this.table,
    this.isDelivered,
    this.isPaid,
    this.foods,
    required this.totalPrice,
  });

  List<OrderData> get mergedFoods => foods?.merged ?? [];

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  @override
  List<Object?> get props => [id];
}

@JsonSerializable(createToJson: false)
class OrderData {
  final FoodModel? food;
  final List<String>? addOns;
  final int? quantity;
  // final int? price;

  const OrderData({
    this.food,
    this.addOns,
    this.quantity,
    // this.price,
  });

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
