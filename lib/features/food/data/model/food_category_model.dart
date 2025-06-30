import 'package:json_annotation/json_annotation.dart';

part 'food_category_model.g.dart';

@JsonSerializable(createToJson: false)
class FoodCategoryModel {
  final List<String> categories;

  FoodCategoryModel({required this.categories});

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$FoodCategoryModelFromJson(json);
}
