import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/networking/api_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pagination_result.g.dart';

class PaginationResult<T> {
  final PaginationModel? pagination;
  final List<T> data;

  PaginationResult({
    this.pagination = const PaginationModel(),
    List<T>? data,
  }) : data = data ?? [];

  PaginationResult<T> add(T item) =>
      copyWith(data: data.withUnique(item));

  PaginationResult<T> addAll(PaginationResult<T> result) => copyWith(
    data: data.withAllUnique(result.data),
    pagination: result.pagination,
  );

  PaginationResult<T> remove(T item) =>
      copyWith(data: data.without(item));

  PaginationResult<T> replace(T item) =>
      copyWith(data: data.withReplace(item));

  PaginationResult<T> copyWith({
    PaginationModel? pagination,
    List<T>? data,
  }) {
    return PaginationResult(
      pagination: pagination ?? this.pagination,
      data: data ?? this.data,
    );
  }

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;

  PaginationResult.fromResponse({
    required MultiDataApiResponse response,
    required T Function(Map<String, dynamic>) fromJson,
  }) : pagination = response.pagination,
       data = response.data.map((e) => fromJson(e)).toList();
}

@JsonSerializable(createToJson: false)
class PaginationModel {
  final int? page;

  const PaginationModel({this.page});

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}
