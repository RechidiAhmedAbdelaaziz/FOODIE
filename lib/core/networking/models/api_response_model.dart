import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

abstract class ApiResponseModel {
  final bool? success;
  final int? statusCode;

  ApiResponseModel({this.success, this.statusCode});
}

@JsonSerializable(createToJson: false)
class VoidApiResponse extends ApiResponseModel {
  VoidApiResponse({super.success, super.statusCode});

  factory VoidApiResponse.fromJson(Map<String, dynamic> json) =>
      _$VoidApiResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class DataApiResponse extends ApiResponseModel {
  final Map<String, dynamic> data;

  DataApiResponse({
    required this.data,
    super.success,
    super.statusCode,
  });

  factory DataApiResponse.fromJson(Map<String, dynamic> json) =>
      _$DataApiResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class MultiDataApiResponse extends ApiResponseModel {
  final List<Map<String, dynamic>> data;

  MultiDataApiResponse({
    required this.data,
    super.success,
    super.statusCode,
  });

  factory MultiDataApiResponse.fromJson(Map<String, dynamic> json) =>
      _$MultiDataApiResponseFromJson(json);
}

//* ERROR MODEL
@JsonSerializable(createToJson: false)
class ErrorApiResponse extends ApiResponseModel {
  final String message;

  ErrorApiResponse({
    this.message = 'Oops! Something went wrong',
    super.success,
    super.statusCode,
  });

  factory ErrorApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorApiResponseFromJson(json);
}
