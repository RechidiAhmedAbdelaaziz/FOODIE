import 'package:app/core/shared/dto/pagination_dto.dart';

class FoodFilterDTO extends PaginationDto {
  final String? id;

  FoodFilterDTO({
    this.id,
    super.page,
    super.limit,
    super.keyword,
    super.fields,
    super.sort,
  });

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), if (id != null) 'id': id};
  }
}
