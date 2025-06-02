// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/core/flavors/flavors_router.dart' as _i60;
import 'package:app/core/localization/localization_cubit.dart' as _i224;
import 'package:app/core/networking/dio/dio.service.dart' as _i634;
import 'package:app/core/routing/routers/router.dart' as _i53;
import 'package:app/core/services/cache/cache_service.dart' as _i962;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    final flavorsRouter = _$FlavorsRouter();
    gh.lazySingleton<_i224.LocalizationCubit>(() => _i224.LocalizationCubit());
    gh.lazySingleton<_i962.CacheService>(() => _i962.CacheService());
    gh.lazySingleton<_i361.Dio>(() => dioModule.provideDio());
    gh.lazySingleton<_i53.AppRouter>(() => flavorsRouter.provideAppRouter());
    return this;
  }
}

class _$DioModule extends _i634.DioModule {}

class _$FlavorsRouter extends _i60.FlavorConfigs {}
