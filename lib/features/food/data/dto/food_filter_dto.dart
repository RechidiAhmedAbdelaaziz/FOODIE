import 'package:app/core/shared/dto/pagination_dto.dart';

class FoodFilterDTO extends PaginationDto {
  String? _id;

  FoodFilterDTO({
    String? id,
    super.page,
    super.limit,
    super.keyword,
    super.fields,
    super.sort,
  }) : _id = id;

  void setId(String id) => _id = id;

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), if (_id != null) 'id': _id};
  }
}
