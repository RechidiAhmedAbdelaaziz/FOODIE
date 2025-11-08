// ignore_for_file: library_private_types_in_public_api

part of 'tables_cubit.dart';

enum _TablesStatus { initial, loading, loaded, error }

class TablesState with CubitErrorHandling {
  final List<TableModel> tables;
  final _TablesStatus status;
  final String? _errorMessage;

  TablesState({
    this.tables = const [],
    this.status = _TablesStatus.initial,
    String? errorMessage,
  }) : _errorMessage = errorMessage;

  factory TablesState.initial() => TablesState();

  @override
  String? get error => _errorMessage;

  bool get isLoading => status == _TablesStatus.loading;

  TablesState _copyWith({
    List<TableModel>? tables,
    _TablesStatus? status,
    String? errorMessage,
  }) {
    return TablesState(
      tables: tables ?? this.tables,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  TablesState _loading() {
    return _copyWith(status: _TablesStatus.loading);
  }

  TablesState _loaded(List<TableModel> tables) {
    return _copyWith(
      tables: this.tables.withAllUnique(tables),
      status: _TablesStatus.loaded,
    );
  }

  TablesState _added(TableModel table) {
    return _copyWith(
      tables: tables.withUniqueFirst(table),
      status: _TablesStatus.loaded,
    );
  }

  TablesState _updated(TableModel table) {
    return _copyWith(
      tables: tables.withReplace(table),
      status: _TablesStatus.loaded,
    );
  }

  TablesState _removed(TableModel table) {
    return _copyWith(
      tables: tables.without(table),
      status: _TablesStatus.loaded,
    );
  }

  TablesState _error(String errorMessage) {
    return _copyWith(
      status: _TablesStatus.error,
      errorMessage: errorMessage,
    );
  }
}
