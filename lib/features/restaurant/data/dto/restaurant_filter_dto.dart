import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/pagination_dto.dart';
import 'package:app/core/shared/editioncontollers/boolean_editigcontroller.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:flutter/material.dart';

class RestaurantFilterDTO extends PaginationDto {
  final String type;

  final EditingController<String> workingDaysController;
  final EditingController<TimeOfDay> openingTimeController;
  final EditingController<TimeOfDay> closingTimeController;

  final BooleanEditingController hasDeliveryController;
  final BooleanEditingController hasBreakfastController;

  RestaurantFilterDTO({
    required this.type,
    super.page,
    super.limit,
    super.sort,
    super.keyword,
    super.fields,
  }) : workingDaysController = EditingController(),
       openingTimeController = EditingController(),
       closingTimeController = EditingController(),
       hasDeliveryController = BooleanEditingController(),
       hasBreakfastController = BooleanEditingController();

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'category': type,

      'day': workingDaysController.value,
      'startTime': openingTimeController.value?.toFormattedTime(),
      'endTime': closingTimeController.value?.toFormattedTime(),

      'hasDelivery': hasDeliveryController.value,

      'hasBreakfast': hasBreakfastController.value,
    }.withoutNullsOrEmpty().withoutFalse();
  }

  void copyFrom(RestaurantFilterDTO other) {
    pageController.setValue(other.pageController.value);
    limitController.setValue(other.limitController.value);
    sortController.text = other.sortController.text;
    keywordController.text = other.keywordController.text;
    fieldsController.text = other.fieldsController.text;

    if (other.workingDaysController.value != null) {
      workingDaysController.setValue(
        other.workingDaysController.value!,
      );
    }

    if (other.openingTimeController.value != null) {
      openingTimeController.setValue(
        other.openingTimeController.value!,
      );
    }

    if (other.closingTimeController.value != null) {
      closingTimeController.setValue(
        other.closingTimeController.value!,
      );
    }

    hasDeliveryController.setValue(other.hasDeliveryController.value);
    hasBreakfastController.setValue(
      other.hasBreakfastController.value,
    );
  }

  void clear() {
    workingDaysController.clear();
    openingTimeController.clear();
    closingTimeController.clear();
    hasDeliveryController.setValue(false);
    hasBreakfastController.setValue(false);
  }

  @override
  void dispose() {
    workingDaysController.dispose();
    openingTimeController.dispose();
    closingTimeController.dispose();
    hasDeliveryController.dispose();
    hasBreakfastController.dispose();
    super.dispose();
  }
}
