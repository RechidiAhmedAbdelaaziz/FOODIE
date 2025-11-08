import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/table/data/dto/table_dto.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:app/features/table/data/repository/table_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'table_form_state.dart';

class TableFormCubit extends Cubit<TableFormState<TableDTO>> {
  final _repo = locator<TableRepo>();
  TableFormCubit() : super(TableFormState.initial());

  TableDTO get dto => state._dto!;

  void init([String? id]) async {
    if (id == null) {
      emit(state._loaded(TableDTO()));
      return;
    }

    emit(state._loading());

    final result = await _repo.getTableById(id);
    result.when(
      success: (table) => emit(state._loaded(TableDTO(table))),
      error: (error) => emit(state._error(error.message)),
    );
  }

  void save() async {
    if (state.isLoading || !dto.isValid) return;

    emit(state._loading());

    final result = dto.id.isEmpty
        ? await _repo.createTable(dto)
        : await _repo.updateTable(dto);

    result.when(
      success: (table) => emit(state._success(table)),
      error: (error) => emit(state._error(error.message)),
    );
  }
}
