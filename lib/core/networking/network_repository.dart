import 'package:app/core/networking/api_error_handler.dart';
import 'package:app/core/networking/api_response_model.dart';
import 'package:app/core/networking/api_result_type.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:flutter/material.dart';

typedef RepoResult<T> = Future<ApiResult<T>>;
typedef RepoListResult<T> = Future<ApiResult<PaginationResult<T>>>;

class NetworkRepository {
  Future<ApiResult<T>> tryApiCall<T, D extends ApiResponseModel>({
    required Future<D> Function() apiCall,
    Future<D> Function()? localApiCall,
    required T Function(D response) onResult,
  }) async {
    try {
      final response = await apiCall();

      if (response.success == false) {
        return ApiResult.error(ApiErrorHandler.handle(response));
      }

      return ApiResult.success(onResult(response));
    } catch (e) {
      //Try get data from local cache
      if (localApiCall != null) {
        try {
          return ApiResult.success(onResult(await localApiCall()));
        } catch (e) {
          debugPrint("Error occurred while calling local API: $e");
          return ApiResult.error(ApiErrorHandler.handle(e));
        }
      }

      debugPrint("Error occurred while calling API: $e");
      return ApiResult.error(ApiErrorHandler.handle(e));
    }
  }
}
