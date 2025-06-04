// ignore_for_file: library_private_types_in_public_api

part of 'history_cubit.dart';

enum _HistoryStatus { initial, loading, loaded, error }

class HistoryState with CubitErrorHandling {
  final _HistoryStatus _status;
  final List<HistoryModel> _items;
  final String? _errorMessage;

  HistoryState({
    _HistoryStatus status = _HistoryStatus.initial,
    List<HistoryModel> items = const [],
    String? errorMessage,
  }) : _status = status,
       _items = items,
       _errorMessage = errorMessage;

  factory HistoryState.initial() => HistoryState();

  @override
  String? get error => _errorMessage;

  HistoryState _copyWith({
    _HistoryStatus? status,
    List<HistoryModel>? items,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? _status,
      items: items ?? _items,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => _status == _HistoryStatus.loading;
  bool get isLoaded => _items.isNotEmpty;

  HistoryState _loading() {
    return _copyWith(status: _HistoryStatus.loading);
  }

  HistoryState _loaded(List<HistoryModel> items) {
    return _copyWith(
      status: _HistoryStatus.loaded,
      items: _items.withAllUnique(items),
    );
  }

  HistoryState _error(String errorMessage) {
    return _copyWith(
      status: _HistoryStatus.error,
      errorMessage: errorMessage,
    );
  }
}
