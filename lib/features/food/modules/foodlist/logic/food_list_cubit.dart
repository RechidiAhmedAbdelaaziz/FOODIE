import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/food/data/dto/food_dto.dart';
import 'package:app/features/food/data/dto/food_filter_dto.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/food/data/repository/food_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_list_state.dart';

class FoodListCubit extends Cubit<FoodListState> {
  final _repo = locator<FoodRepo>();

  FoodListCubit(this._filter) : super(FoodListState.initial());

  final FoodFilterDTO _filter;

  FoodFilterDTO get filter => _filter;

  List<FoodModel> get foods {
    return state._foods;
  }

  List<String> get categories =>
      foods.map((food) => food.category ?? '').toSet().toList();

  void fetchFoods() async {
    if (state.isLoading) return;

    emit(state._loading());

    final result = await _repo.getFoods(_filter);

    result.when(
      success: (result) {
        final foods = result.data;
        emit(state._loaded(foods));
      },
      error: (error) => emit(state._error(error.message)),
    );
  }

  void addFood(FoodModel food) => emit(state._added(food));
  void replaceFood(FoodModel food) => emit(state._updated(food));

  void removeFood(FoodModel food) async {
    if (state.isLoading) return;

    emit(state._loading());

    final result = await _repo.deleteFood(food.id!);

    result.when(
      success: (_) => emit(state._deleted(food)),
      error: (error) => emit(state._error(error.message)),
    );
  }

  void updateAvailability(FoodModel food) async {
    if (state.isUpdating(food)) return;

    emit(state._updating(food));

    final result = await _repo.updateFoodAvailability(
      FoodAvailabilityDTO(food),
    );

    result.when(
      success: replaceFood,
      error: (error) => emit(state._error(error.message)),
    );
  }

  @override
  Future<void> close() {
    _filter.dispose();
    return super.close();
  }
}
