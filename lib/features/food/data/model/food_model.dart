import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_model.g.dart';

enum FoodModelFields {
  client('name addOns category image price description'),
  owner('name addOns category image price isAvailable description');

  final String value;
  const FoodModelFields(this.value);
}

@JsonSerializable(createToJson: false)
class FoodModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? image;
  final String? name;
  final String? description;
  final int? price;
  final String? category;
  final bool? isAvailable;
  final List<AddOnsModel>? addOns;

  const FoodModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    this.addOns,
    this.isAvailable,
    this.image,
  });

  int totalPrice(List<AddOnsModel> addOns , int quantity) {
    int total = price ?? 0;

    for (final addOn in addOns) {
      total += addOn.price ?? 0;
    }

    return total * quantity;
  }

  factory FoodModel.fromJson(Map<String, dynamic> json) =>
      _$FoodModelFromJson(json);

  @override
  List<Object?> get props => [id];
}

@JsonSerializable()
class AddOnsModel extends Equatable {
  final String? name;
  final int? price;

  const AddOnsModel({this.name, this.price});

  factory AddOnsModel.fromJson(Map<String, dynamic> json) =>
      _$AddOnsModelFromJson(json);

  @override
  List<Object?> get props => [name, price];

  Map<String, dynamic> toJson() => _$AddOnsModelToJson(this);
}
