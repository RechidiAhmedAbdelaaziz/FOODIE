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
import 'package:app/core/services/cloudstorage/cloud_storage.service.dart'
    as _i489;
import 'package:app/core/services/cloudstorage/cloudinary.service.dart' as _i87;
import 'package:app/core/services/filepicker/file_picker_service.dart' as _i133;
import 'package:app/features/auth/data/repository/auth_repository.dart'
    as _i719;
import 'package:app/features/auth/data/source/auth_api.dart' as _i530;
import 'package:app/features/auth/data/source/auth_cache.dart' as _i1035;
import 'package:app/features/auth/logic/auth_cubit.dart' as _i571;
import 'package:app/features/auth/modules/login/ui/login_route.dart' as _i1000;
import 'package:dio/dio.dart' as _i361;
import 'package:file_picker/file_picker.dart' as _i388;
import 'package:flutter_flavor/flutter_flavor.dart' as _i935;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final filePickersModule = _$FilePickersModule();
    final dioModule = _$DioModule();
    final flavorConfigs = _$FlavorConfigs();
    gh.lazySingleton<_i224.LocalizationCubit>(() => _i224.LocalizationCubit());
    gh.lazySingleton<_i962.CacheService>(() => _i962.CacheService());
    gh.lazySingleton<_i183.ImagePicker>(() => filePickersModule.imagePicker);
    gh.lazySingleton<_i388.FilePicker>(() => filePickersModule.filePicker);
    gh.lazySingleton<_i133.ImageFilePicker>(() => _i133.ImageFilePicker());
    gh.lazySingleton<_i133.VideoFilePicker>(() => _i133.VideoFilePicker());
    gh.lazySingleton<_i361.Dio>(() => dioModule.provideDio());
    gh.lazySingleton<_i53.AppRouter>(() => flavorConfigs.provideAppRouter());
    gh.lazySingleton<_i935.FlavorConfig>(
      () => flavorConfigs.provideFlavorConfig(),
    );
    gh.lazySingleton<_i719.AuthRepo>(() => _i719.AuthRepo());
    gh.lazySingleton<_i1000.LoginRoute>(() => _i1000.LoginRoute());
    gh.lazySingleton<_i489.VideoCloudStorageService>(
      () => _i87.VideoCloudinaryService(),
    );
    gh.lazySingleton<_i489.PdfCloudStorageService>(
      () => _i87.PdfCloudinaryService(),
    );
    gh.lazySingleton<_i530.AuthApi>(() => _i530.AuthApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i489.ImageCloudStorageService>(
      () => _i87.ImageCloudinaryService(),
    );
    gh.lazySingleton<_i1035.AuthCache>(
      () => _i1035.AuthCache(gh<_i962.CacheService>()),
    );
    gh.lazySingleton<_i571.AuthCubit>(
      () => _i571.AuthCubit(gh<_i719.AuthRepo>(), gh<_i1035.AuthCache>()),
    );
    return this;
  }
}

class _$FilePickersModule extends _i133.FilePickersModule {}

class _$DioModule extends _i634.DioModule {}

class _$FlavorConfigs extends _i60.FlavorConfigs {}
