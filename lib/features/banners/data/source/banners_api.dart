import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'banners_api.g.dart';

@RestApi()
@lazySingleton
abstract class BannersApi {
  @factoryMethod
  factory BannersApi(Dio dio) = _BannersApi;

  @GET('/banners')
  Future<MultiDataApiResponse> getBanners();
}
