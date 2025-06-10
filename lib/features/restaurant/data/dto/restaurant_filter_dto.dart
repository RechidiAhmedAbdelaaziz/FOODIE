import 'package:app/core/shared/dto/pagination_dto.dart';

class RestaurantFilterDto extends PaginationDto {
  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),

      'longitude': '', //TODO: Override with actual value
      'latitude': '',
    };
  }
}
