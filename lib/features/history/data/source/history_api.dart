import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'history_api.g.dart';

@RestApi()
@lazySingleton
abstract class HistoryApi {
  @factoryMethod
  factory HistoryApi(Dio dio) = _HistoryApi;

  @GET('/history')
  Future<MultiDataApiResponse> getHistory({
    @Queries() required Map<String, dynamic> queries,
  });

  @GET('/history/last')
  Future<DataApiResponse> getLastHistory();
}
