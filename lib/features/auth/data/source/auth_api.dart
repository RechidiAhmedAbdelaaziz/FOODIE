import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'auth_api.g.dart';

@RestApi()
@lazySingleton
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/auth/login')
  Future<VoidApiResponse> login(@Body() Map<String, dynamic> body);

  @GET('/auth/refresh-token')
  Future<DataApiResponse> refreshToken({
    @Query('refresh_token') required String refreshToken,
  });

  @POST('/auth/verify-code')
  Future<DataApiResponse> verifyCode({
    @Body() required Map<String, dynamic> body,
  });
}
