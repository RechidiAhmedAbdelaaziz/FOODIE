import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/banners/data/model/banner_model.dart';
import 'package:app/features/banners/data/repository/banners_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  final _repo = locator<BannersRepo>();
  BannersCubit() : super(BannersState.initial());

  void fetchBanners() async {
    emit(state._loading());

    final result = await _repo.getBanners();

    result.when(
      success: (result) {
        final banners = result.data;
        emit(state._loaded(banners));
      },
      error: (error) => emit(state._failure(error.message)),
    );
  }
}
