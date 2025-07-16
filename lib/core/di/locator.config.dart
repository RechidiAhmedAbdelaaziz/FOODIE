// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/core/flavors/flavors.dart' as _i600;
import 'package:app/core/localization/localization_cubit.dart' as _i224;
import 'package:app/core/networking/dio/dio.service.dart' as _i634;
import 'package:app/core/routing/router.dart' as _i421;
import 'package:app/core/services/cache/cache_service.dart' as _i962;
import 'package:app/core/services/cloudstorage/cloud_storage.service.dart'
    as _i489;
import 'package:app/core/services/cloudstorage/cloudinary.service.dart' as _i87;
import 'package:app/core/services/filepicker/file_picker_service.dart' as _i133;
import 'package:app/core/services/geolocator/geo_locator_service.dart' as _i735;
import 'package:app/core/services/qr/qr_service.dart' as _i425;
import 'package:app/core/services/socketio/socket_io_service.dart' as _i117;
import 'package:app/core/services/sounds/sound_service.dart' as _i99;
import 'package:app/features/auth/data/repository/auth_repository.dart'
    as _i719;
import 'package:app/features/auth/data/source/auth_api.dart' as _i530;
import 'package:app/features/auth/data/source/auth_cache.dart' as _i1035;
import 'package:app/features/auth/logic/auth_cubit.dart' as _i571;
import 'package:app/features/banners/data/repository/banners_repository.dart'
    as _i288;
import 'package:app/features/banners/data/source/banners_api.dart' as _i4;
import 'package:app/features/food/data/repository/food_category_repository.dart'
    as _i226;
import 'package:app/features/food/data/repository/food_repository.dart'
    as _i811;
import 'package:app/features/food/data/source/food_api.dart' as _i531;
import 'package:app/features/food/data/source/food_category_api.dart' as _i350;
import 'package:app/features/history/data/repository/history_repository.dart'
    as _i883;
import 'package:app/features/history/data/source/history_api.dart' as _i892;
import 'package:app/features/order/data/repository/order_repository.dart'
    as _i913;
import 'package:app/features/order/data/source/order_api.dart' as _i46;
import 'package:app/features/restaurant/data/repository/restaurant_repository.dart'
    as _i275;
import 'package:app/features/restaurant/data/source/restaurant_api.dart'
    as _i728;
import 'package:app/features/staff/data/repository/staff_repository.dart'
    as _i798;
import 'package:app/features/staff/data/source/staff_api.dart' as _i850;
import 'package:app/features/subscription/data/repository/subscription_repository.dart'
    as _i399;
import 'package:app/features/subscription/data/source/subscription_api.dart'
    as _i989;
import 'package:app/features/table/data/repository/table_repository.dart'
    as _i729;
import 'package:app/features/table/data/source/table_api.dart' as _i611;
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
    final flavorConfigModule = _$FlavorConfigModule();
    gh.lazySingleton<_i883.HistoryRepo>(() => _i883.HistoryRepo());
    gh.lazySingleton<_i226.FoodCategoryRepository>(
      () => _i226.FoodCategoryRepository(),
    );
    gh.lazySingleton<_i811.FoodRepo>(() => _i811.FoodRepo());
    gh.lazySingleton<_i288.BannersRepo>(() => _i288.BannersRepo());
    gh.lazySingleton<_i798.StaffRepo>(() => _i798.StaffRepo());
    gh.lazySingleton<_i275.RestaurantRepo>(() => _i275.RestaurantRepo());
    gh.lazySingleton<_i729.TableRepo>(() => _i729.TableRepo());
    gh.lazySingleton<_i913.OrderRepo>(() => _i913.OrderRepo());
    gh.lazySingleton<_i719.AuthRepo>(() => _i719.AuthRepo());
    gh.lazySingleton<_i224.LocalizationCubit>(() => _i224.LocalizationCubit());
    gh.lazySingleton<_i425.QrService>(() => _i425.QrService());
    gh.lazySingleton<_i735.GeoLocatorService>(() => _i735.GeoLocatorService());
    gh.lazySingleton<_i117.SocketIoService>(() => _i117.SocketIoService());
    gh.lazySingleton<_i962.CacheService>(() => _i962.CacheService());
    gh.lazySingleton<_i183.ImagePicker>(() => filePickersModule.imagePicker);
    gh.lazySingleton<_i388.FilePicker>(() => filePickersModule.filePicker);
    gh.lazySingleton<_i133.ImageFilePicker>(() => _i133.ImageFilePicker());
    gh.lazySingleton<_i133.VideoFilePicker>(() => _i133.VideoFilePicker());
    gh.lazySingleton<_i99.SoundService>(() => _i99.SoundService());
    gh.lazySingleton<_i421.AppRouter>(() => _i421.AppRouter());
    gh.lazySingleton<_i361.Dio>(() => dioModule.provideDio());
    gh.lazySingleton<_i935.FlavorConfig>(() => flavorConfigModule.config);
    gh.lazySingleton<_i399.SubscriptionRepo>(() => _i399.SubscriptionRepo());
    gh.lazySingleton<_i489.VideoCloudStorageService>(
      () => _i87.VideoCloudinaryService(),
    );
    gh.lazySingleton<_i489.PdfCloudStorageService>(
      () => _i87.PdfCloudinaryService(),
    );
    gh.lazySingleton<_i892.HistoryApi>(() => _i892.HistoryApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i531.FoodApi>(() => _i531.FoodApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i350.FoodCategoryApi>(
      () => _i350.FoodCategoryApi(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i4.BannersApi>(() => _i4.BannersApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i850.StaffApi>(() => _i850.StaffApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i728.RestaurantApi>(
      () => _i728.RestaurantApi(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i611.TableApi>(() => _i611.TableApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i46.OrderApi>(() => _i46.OrderApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i530.AuthApi>(() => _i530.AuthApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i989.SubscriptionApi>(
      () => _i989.SubscriptionApi(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i489.ImageCloudStorageService>(
      () => _i87.ImageCloudinaryService(),
    );
    gh.lazySingleton<_i1035.AuthCache>(
      () => _i1035.AuthCache(gh<_i962.CacheService>()),
    );
    gh.lazySingleton<_i571.AuthCubit>(
      () =>
          _i571.AuthCubit(gh<_i719.AuthRepo>(), gh<_i1035.AuthCache>())..init(),
    );
    return this;
  }
}

class _$FilePickersModule extends _i133.FilePickersModule {}

class _$DioModule extends _i634.DioModule {}

class _$FlavorConfigModule extends _i600.FlavorConfigModule {}
