import 'package:app/core/constants/data.dart';
import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class WorkingTimeDto with FormDTO {
  final WorkingTimeModel? _workingTime;

  static TimeOfDay _timeOfDayFromString(String? json) {
    if (json == null) return TimeOfDay(hour: 0, minute: 0);
    final parts = json.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  WorkingTimeDto([this._workingTime])
    : dayController = EditingController<String>(
        _workingTime?.day ?? AppData.weekDays.first,
      ),
      startTimeController = EditingController<TimeOfDay>(
        _timeOfDayFromString(_workingTime?.startTime),
      ),
      endTimeController = EditingController<TimeOfDay>(
        _timeOfDayFromString(_workingTime?.endTime),
      );

  final EditingController<String> dayController;
  final EditingController<TimeOfDay> startTimeController;
  final EditingController<TimeOfDay> endTimeController;

  bool get isModified =>
      (dayController.value != _workingTime?.day) ||
      (startTimeController.value?.toFormattedTime() !=
          _workingTime?.startTime) ||
      (endTimeController.value?.toFormattedTime() !=
          _workingTime?.endTime);

  void getCopyFrom(WorkingTimeDto other) {
    dayController.value = other.dayController.value;
    startTimeController.value = other.startTimeController.value;
    endTimeController.value = other.endTimeController.value;
  }

  @override
  void dispose() {
    dayController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'day': dayController.value,
      'startTime': startTimeController.value?.toFormattedTime(),
      'endTime': endTimeController.value?.toFormattedTime(),
    }.withoutNullsOrEmpty();
  }
}
