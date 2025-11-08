part of 'food_category_cubit.dart';

class FoodCategoryState {
  final List<String> categories;

  FoodCategoryState({required this.categories});

  factory FoodCategoryState.initial() =>
      FoodCategoryState(categories: AppData.foodCategories);

  FoodCategoryState _copyWith({List<String>? categories}) {
    return FoodCategoryState(
      categories: categories ?? this.categories,
    );
  }
}
