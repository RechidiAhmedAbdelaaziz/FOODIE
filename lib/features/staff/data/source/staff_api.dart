import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'staff_api.g.dart';

@RestApi()
@lazySingleton
abstract class StaffApi {
  @factoryMethod
  factory StaffApi(Dio dio) = _StaffApi;

  @GET('/staffs')
  Future<MultiDataApiResponse> getStaffs(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/staffs/{id}')
  Future<DataApiResponse> getStaffById(@Path('id') String id);

  @GET('/staffs/money')
  Future<DataApiResponse> getStaffMoney();

  @POST('/staffs')
  Future<DataApiResponse> createStaff(
    @Body() Map<String, dynamic> body,
  );

  @PUT('/staffs/{id}')
  Future<DataApiResponse> updateStaff(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/staffs/{id}')
  Future<VoidApiResponse> deleteStaff(@Path('id') String id);
}
