import 'package:app/core/constants/data.dart';
import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/features/food/data/repository/food_category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_category_state.dart';

class FoodCategoryCubit extends Cubit<FoodCategoryState> {
  final _repo = locator<FoodCategoryRepository>();

  FoodCategoryCubit() : super(FoodCategoryState.initial());

  void fetchFoodCategories() async {
    final result = await _repo.getFoodCategories();
    result.when(
      success: (data) =>
          emit(state._copyWith(categories: data.categories)),
      error: (_) {},
    );
  }

  void createFoodCategory(String name) async {
    final result = await _repo.createFoodCategory(name);
    result.when(
      success: (_) => emit(
        state._copyWith(
          categories: state.categories.withUnique(name),
        ),
      ),
      error: (_) {},
    );
  }

  void updateFoodCategory(String name, String newName) async {
    final result = await _repo.updateFoodCategory(name, newName);
    result.when(
      success: (_) => emit(
        state._copyWith(
          categories: state.categories
              .map(
                (category) => category == name ? newName : category,
              )
              .toList(),
        ),
      ),
      error: (_) {},
    );
  }

  void deleteFoodCategory(String name) async {
    final result = await _repo.deleteFoodCategory(name);
    result.when(
      success: (_) => emit(
        state._copyWith(categories: state.categories.without(name)),
      ),
      error: (_) {},
    );
  }
}
