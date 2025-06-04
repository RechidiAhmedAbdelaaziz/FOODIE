import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/staff/data/dto/create_staff_dto.dart';
import 'package:app/features/staff/data/dto/update_staff_dto.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:app/features/staff/data/repository/staff_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staff_form_state.dart';

class CreateStaffFormCubit
    extends Cubit<StaffFormState<CreateStaffDTO>> {
  final _repo = locator<StaffRepo>();
  CreateStaffFormCubit() : super(StaffFormState.initial());

  void init() => emit(state._loaded(CreateStaffDTO()));

  CreateStaffDTO get dto => state._dto!;

  void save() {
    if (state.isLoading || !dto.isValid) return;

    emit(state._loading());

    _repo.createStaff(state._dto!).then((result) {
      result.when(
        success: (staff) => emit(state._success(staff)),
        error: (error) => emit(state._error(error.message)),
      );
    });
  }
}

class UpdateStaffFormCubit
    extends Cubit<StaffFormState<UpdateStaffDTO>> {
  final _repo = locator<StaffRepo>();

  UpdateStaffFormCubit() : super(StaffFormState.initial());

  UpdateStaffDTO get dto => state._dto!;

  void init(StaffModel staff) =>
      emit(state._loaded(UpdateStaffDTO(staff)));

  void initById(String id) {
    emit(state._loading());

    _repo.getStaffById(id).then((result) {
      result.when(
        success: (staff) =>
            emit(state._loaded(UpdateStaffDTO(staff))),
        error: (error) => emit(state._error(error.message)),
      );
    });
  }

  void save() {
    if (state.isLoading || !dto.isValid) return;

    emit(state._loading());

    _repo.updateStaff(state._dto!).then((result) {
      result.when(
        success: (staff) => emit(state._success(staff)),
        error: (error) => emit(state._error(error.message)),
      );
    });
  }
}
