import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'subscription_api.g.dart';

@RestApi()
@lazySingleton
abstract class SubscriptionApi {
  @factoryMethod
  factory SubscriptionApi(Dio dio) = _SubscriptionApi;

  @GET('/subscription/me')
  Future<DataApiResponse> getMySubscription();

  @POST('/subscription/subscribe')
  Future<DataApiResponse> subscribeToPlan(
    @Body() Map<String, dynamic> body,
  );
}
