import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:app/features/table/data/repository/table_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tables_state.dart';

class TablesCubit extends Cubit<TablesState> {
  final _repo = locator<TableRepo>();
  TablesCubit() : super(TablesState.initial());

  void clearAndFetch() {
    emit(TablesState.initial());
    fetchTables();
  }

  void fetchTables() {
    if (state.isLoading) return;

    emit(state._loading());

    _repo.getTables().then((result) {
      result.when(
        success: (result) {
          final tables = result.data;

          emit(state._loaded(tables));
        },
        error: (error) => emit(state._error(error.message)),
      );
    });
  }

  void addTable(TableModel table) => emit(state._added(table));

  void updateTable(TableModel table) => emit(state._updated(table));

  void removeTable(TableModel table) async {
    final result = await _repo.deleteTable(table.id!);

    result.when(
      success: (_) => emit(state._removed(table)),
      error: (error) => emit(state._error(error.message)),
    );
  }
}
