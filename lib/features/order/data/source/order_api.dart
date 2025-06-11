import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'order_api.g.dart';

@RestApi()
@lazySingleton
abstract class OrderApi {
  @factoryMethod
  factory OrderApi(Dio dio) = _OrderApi;

  @GET('/orders')
  Future<MultiDataApiResponse> getOrders();

  
}
