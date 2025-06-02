extension MapExtension<T, V> on Map<T, V> {
  Map<T, V> withoutNullsOrEmpty() {
    // remove entries with null or empty values or equal to {}
    // if entry value is a list and is empty  remove it
    // remove ({} , null , empty string , empty list) values from list entries
    return Map<T, V>.fromEntries(
      entries
          .map(
            (e) => MapEntry(
              e.key,
              e.value is List
                  ? (e.value as List).withoutNullsOrEmpty() as V
                  : e.value,
            ),
          )
          .where(
            (element) =>
                element.value != null &&
                element.value != '' &&
                element.value != {} &&
                element.value != [],
          ),
    );
  }
}

extension ListExtension<T> on List<T> {
  List<T> withoutNullsOrEmpty() {
    return where(
      (element) =>
          element != null &&
          element != '' &&
          element != {} &&
          element != [],
    ).toList();
  }
}
