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
}
