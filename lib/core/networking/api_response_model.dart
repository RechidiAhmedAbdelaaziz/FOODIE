import 'package:app/core/shared/models/pagination_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

abstract class ApiResponseModel {
  final bool? success;
  final int? statusCode;

  const ApiResponseModel({this.success, this.statusCode});
}

@JsonSerializable(createToJson: false)
class VoidApiResponse extends ApiResponseModel {
  const VoidApiResponse({super.success, super.statusCode});

  factory VoidApiResponse.fromJson(Map<String, dynamic> json) =>
      _$VoidApiResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class DataApiResponse extends ApiResponseModel {
  @JsonKey(defaultValue: <String, dynamic>{})
  final Map<String, dynamic> data;

  const DataApiResponse({
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
  final PaginationModel? pagination;

  const MultiDataApiResponse({
    required this.data,
    this.pagination,
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

  const ErrorApiResponse({
    this.message = 'Oops! Something went wrong',
    super.success,
    super.statusCode,
  });

  factory ErrorApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorApiResponseFromJson(json);
}
