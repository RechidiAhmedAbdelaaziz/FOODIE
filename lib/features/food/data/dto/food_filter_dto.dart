import 'package:app/core/shared/dto/pagination_dto.dart';

class FoodFilterDTO extends PaginationDto {
  FoodFilterDTO({
    super.page,
    super.limit,
    super.keyword,
    super.fields,
    super.sort,
  });
}
