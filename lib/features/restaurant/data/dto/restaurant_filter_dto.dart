import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/pagination_dto.dart';
import 'package:app/core/shared/editioncontollers/boolean_editigcontroller.dart';

class RestaurantFilterDTO extends PaginationDto {
  final String type;

  final BooleanEditingController hasDeliveryController;
  final BooleanEditingController isOpenController;

  RestaurantFilterDTO({
    required this.type,
    super.page,
    super.limit,
    super.sort,
    super.keyword,
    super.fields,
  }) : hasDeliveryController = BooleanEditingController(),
       isOpenController = BooleanEditingController();

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'category': type,

      if (isOpenController.value) ...{
        'day': DateTime.now().toFormattedDay(),
        'startTime': DateTime.now().toFormattedTime(),
        'endTime': DateTime.now().toFormattedTime(),
      },

      'hasDelivery': hasDeliveryController.value,
    }.withoutNullsOrEmpty().withoutFalse();
  }

  void copyFrom(RestaurantFilterDTO other) {
    pageController.setValue(other.pageController.value);
    limitController.setValue(other.limitController.value);
    sortController.text = other.sortController.text;
    keywordController.text = other.keywordController.text;
    fieldsController.text = other.fieldsController.text;

    hasDeliveryController.setValue(other.hasDeliveryController.value);
    isOpenController.setValue(other.isOpenController.value);
  }

  void clear() {
    hasDeliveryController.setValue(false);
    isOpenController.setValue(false);
  }

  @override
  void dispose() {
    hasDeliveryController.dispose();
    isOpenController.dispose();
    super.dispose();
  }
}
