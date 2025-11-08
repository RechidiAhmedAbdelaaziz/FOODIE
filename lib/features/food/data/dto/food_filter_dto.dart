import 'package:app/core/shared/dto/pagination_dto.dart';

class FoodFilterDTO extends PaginationDto {
  String? _restaurantId;

  FoodFilterDTO({
    String? id,
    super.page,
    super.limit,
    super.keyword,
    super.fields,
    super.sort,
  }) : _restaurantId = id;

  void setId(String id) => _restaurantId = id;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      if (_restaurantId != null) 'restaurant': _restaurantId,
    };
  }
}
