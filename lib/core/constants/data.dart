abstract class AppData {
  static const List<String> foodCategories = [
    'Food',
    'Drinks',
    'Desserts',
    'Snacks',
    'Breakfast',
    'Lunch',
    'Dinner',
  ];

  static const List<String> restaurantTypes = [
    'cafe',
    'restaurant',
    'fastFood',
    'breakfast',
  ];

  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static List<String> dayTimes = [
    for (var hour = 0; hour < 24; hour++) ...[
      '${hour.toString().padLeft(2, '0')}:00',
      '${hour.toString().padLeft(2, '0')}:30',
    ],
  ];
}
