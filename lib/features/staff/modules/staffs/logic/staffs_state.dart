part of 'staffs_cubit.dart';

enum _StaffsStatus { initial, loading, loaded, error }

class StaffsState with CubitErrorHandling {
  final List<StaffModel> staffs;
  final _StaffsStatus status;
  final String? _errorMessage;

  StaffsState({
    this.staffs = const [],
    this.status = _StaffsStatus.initial,
    String? errorMessage,
  }) : _errorMessage = errorMessage;

  factory StaffsState.initial() => StaffsState();

  @override
  String? get error => _errorMessage;

  bool get isLoading => status == _StaffsStatus.loading;

  StaffsState _copyWith({
    List<StaffModel>? staffs,
    _StaffsStatus? status,
    String? errorMessage,
  }) {
    return StaffsState(
      staffs: staffs ?? this.staffs,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  StaffsState _loading() {
    return _copyWith(status: _StaffsStatus.loading);
  }

  StaffsState _loaded(List<StaffModel> staffs) {
    return _copyWith(
      staffs: this.staffs.withAllUnique(staffs),
      status: _StaffsStatus.loaded,
    );
  }

  StaffsState _added(StaffModel staff) {
    return _copyWith(
      staffs: staffs.withUniqueFirst(staff),
      status: _StaffsStatus.loaded,
    );
  }

  StaffsState _updated(StaffModel staff) {
    return _copyWith(
      staffs: staffs.withReplace(staff),
      status: _StaffsStatus.loaded,
    );
  }

  StaffsState _removed(StaffModel staff) {
    return _copyWith(
      staffs: staffs.without(staff),
      status: _StaffsStatus.loaded,
    );
  }

  StaffsState _error(String errorMessage) {
    return _copyWith(
      status: _StaffsStatus.error,
      errorMessage: errorMessage,
    );
  }
}
