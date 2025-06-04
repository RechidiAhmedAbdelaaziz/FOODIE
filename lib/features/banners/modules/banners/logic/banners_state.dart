// ignore_for_file: library_private_types_in_public_api

part of 'banners_cubit.dart';

enum _BannersStatus { initial, loading, loaded, error }

class BannersState with CubitErrorHandling {
  final List<BannerModel> banners;
  final _BannersStatus status;
  final String? _error;

  BannersState({
    this.banners = const [],
    this.status = _BannersStatus.initial,
    String? errorMessage,
  }) : _error = errorMessage;

  factory BannersState.initial() => BannersState();

  @override
  String? get error => _error;

  BannersState _copyWith({
    List<BannerModel>? banners,
    _BannersStatus? status,
    String? errorMessage,
  }) {
    return BannersState(
      banners: banners ?? this.banners,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == _BannersStatus.loading;
  bool get isLoaded => banners.isNotEmpty;

  BannersState _loading() =>
      _copyWith(status: _BannersStatus.loading);

  BannersState _loaded(List<BannerModel> banners) {
    return _copyWith(banners: banners, status: _BannersStatus.loaded);
  }

  BannersState _failure(String? errorMessage) {
    return _copyWith(
      status: _BannersStatus.error,
      errorMessage: errorMessage,
    );
  }
}
