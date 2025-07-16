import 'package:flutter/material.dart';

extension DateFormatter on DateTime {


  // * 12/01/2023
  String toDdMmYyyy() {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year.toString();
    return '$day - $month - $year';
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
