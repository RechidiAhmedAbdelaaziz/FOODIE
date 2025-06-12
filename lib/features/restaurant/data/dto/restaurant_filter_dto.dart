import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/pagination_dto.dart';

class RestaurantFilterDTO extends PaginationDto {
  final String type;

  RestaurantFilterDTO({
    required this.type,
    super.page,
    super.limit,
    super.sort,
    super.keyword,
    super.fields,
  });

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'type': type}.withoutNullsOrEmpty();
  }
}
