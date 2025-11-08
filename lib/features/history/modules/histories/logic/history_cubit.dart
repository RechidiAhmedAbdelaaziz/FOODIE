import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/shared/dto/pagination_dto.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/history/data/model/history_model.dart';
import 'package:app/features/history/data/repository/history_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final _repo = locator<HistoryRepo>();
  HistoryCubit() : super(HistoryState.initial());

  final _pagination = PaginationDto();

  List<HistoryModel> get histories => state._items;

  void clearAndFetchHistory() {
    _pagination.firstPage();
    state._items.clear();
    fetchHistory();
  }

  void fetchHistory() async {
    if (state.isLoading) return;

    emit(state._loading());

    final result = await _repo.getHistory(pagination: _pagination);

    result.when(
      success: (result) {
        final items = result.data;
        if (items.isNotEmpty) _pagination.nextPage();
        emit(state._loaded(items));
      },
      error: (errorHandler) =>
          emit(state._error(errorHandler.message)),
    );
  }
}
