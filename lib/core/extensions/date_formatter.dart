import 'package:flutter/material.dart';

extension DateFormatter on DateTime {
  // * 12 Mon 2023
  String toFormattedDate() {
    final day = this.day.toString().padLeft(2, '0');
    final year = this.year.toString();
    final monthName = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][month - 1];
    return '$day $monthName $year';
  }

  // * Firday, Saturday, Sunday ...
  String toFormattedDay() {
    final weekday = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ][this.weekday - 1];
    return weekday;
  }

  // * ##:##
  String toFormattedTime() {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

extension TimeFormatter on TimeOfDay {
  // * ##:##
  String toFormattedTime() {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
