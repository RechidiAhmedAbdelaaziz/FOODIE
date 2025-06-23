import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/food/data/dto/food_dto.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/food/data/repository/food_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_form_state.dart';

class FoodFormCubit extends Cubit<FoodFormState<FoodDTO>> {
  final _repo = locator<FoodRepo>();
  FoodFormCubit() : super(FoodFormState.initial());

  FoodDTO get dto => state._dto!;

  void init([String? id]) async {
    if (id == null) return emit(state._loaded(FoodDTO()));

    emit(state._loading());

    final result = await _repo.getFood(id);
    result.when(
      success: (food) => emit(state._loaded(FoodDTO(food))),
      error: (error) => emit(state._error(error.message)),
    );
  }

  void save() async {
    if (state.isLoading || !dto.isValid) return;

    emit(state._loading());

    final result = dto.id.isEmpty
        ? await _repo.createFood(dto)
        : await _repo.updateFood(dto);

    result.when(
      success: (food) => emit(state._success(food)),
      error: (error) => emit(state._error(error.message)),
    );
  }
}
