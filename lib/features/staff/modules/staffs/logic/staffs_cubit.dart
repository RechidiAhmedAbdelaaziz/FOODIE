import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/shared/dto/pagination_dto.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:app/features/staff/data/repository/staff_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staffs_state.dart';

class StaffsCubit extends Cubit<StaffsState> {
  final _repo = locator<StaffRepo>();
  StaffsCubit() : super(StaffsState.initial());

  final _pagination = PaginationDto();

  void clearAndFetch() {
    _pagination.firstPage();
    emit(StaffsState.initial());
    fetchStaffs();
  }

  void fetchStaffs() {
    if (state.isLoading) return;

    emit(state._loading());

    _repo.getStaffs(_pagination).then((result) {
      result.when(
        success: (result) {
          final staffs = result.data;
          if (staffs.isNotEmpty) _pagination.nextPage();
          emit(state._loaded(staffs));
        },
        error: (error) => emit(state._error(error.message)),
      );
    });
  }

  void addStaff(StaffModel staff) => emit(state._added(staff));

  void updateStaff(StaffModel staff) => emit(state._updated(staff));

  void removeStaff(StaffModel staff) async {
    final result = await _repo.deleteStaff(staff.id!);

    result.when(
      success: (_) => emit(state._removed(staff)),
      error: (error) => emit(state._error(error.message)),
    );
  }
}
