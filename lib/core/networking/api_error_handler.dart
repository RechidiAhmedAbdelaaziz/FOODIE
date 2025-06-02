import 'package:dio/dio.dart';

import 'api_response_model.dart';

class ApiErrorHandler {
  static ErrorApiResponse handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return const ErrorApiResponse(
            message: "Connection to server failed",
          );
        case DioExceptionType.cancel:
          return const ErrorApiResponse(
            message: "Request to the server was cancelled",
          );
        case DioExceptionType.connectionTimeout:
          return const ErrorApiResponse(
            message: "Connection timeout with the server",
          );
        case DioExceptionType.unknown:
          return const ErrorApiResponse(
            message:
                "Connection to the server failed due to internet connection",
          );
        case DioExceptionType.receiveTimeout:
          return const ErrorApiResponse(
            message: "Receive timeout in connection with the server",
          );
        case DioExceptionType.badResponse:
          return _handleError(error.response?.data);
        case DioExceptionType.sendTimeout:
          return const ErrorApiResponse(
            message: "Send timeout in connection with the server",
          );
        default:
          return const ErrorApiResponse(
            message: "Something went wrong",
          );
      }
    } else {
      return const ErrorApiResponse(message: "Something went wrong");
    }
  }
}

ErrorApiResponse _handleError(dynamic data) {
  data as Map<String, dynamic>?;
  return ErrorApiResponse.fromJson(data ?? {});
}
