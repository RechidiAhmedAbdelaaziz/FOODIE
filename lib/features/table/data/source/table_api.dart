import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'table_api.g.dart';

@RestApi()
@lazySingleton
abstract class TableApi {
  @factoryMethod
  factory TableApi(Dio dio) = _TableApi;

  @GET('/tables')
  Future<MultiDataApiResponse> getTables();

  @GET('/tables/{id}')
  Future<DataApiResponse> getTableById(@Path('id') String id);

  @POST('/tables')
  Future<DataApiResponse> createTable(
    @Body() Map<String, dynamic> tableData,
  );

  @PATCH('/tables/{id}')
  Future<DataApiResponse> updateTable(
    @Path('id') String id,
    @Body() Map<String, dynamic> tableData,
  );

  @DELETE('/tables/{id}')
  Future<VoidApiResponse> deleteTable(@Path('id') String id);
}
