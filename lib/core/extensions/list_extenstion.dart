extension ListExtension<T> on List<T> {
  bool equals(List<T> other) {
    if (length != other.length) return false;
    for (var i = 0; i < length; i++) {
      if (contains(other[i])) continue;
      return false;
    }
    return true;
  }

  void addFirst(T item) => insert(0, item);

  void addUnique(T item) {
    if (!contains(item)) add(item);
  }

  void addUniqueFirst(T item) {
    if (!contains(item)) addFirst(item);
  }

  List<T> withUnique(T item) => List<T>.from(this)..addUnique(item);

  List<T> withUniqueFirst(T item) {
    final lsit = List<T>.from(this);
    lsit.addUniqueFirst(item);
    return lsit;
  }

  void addAllUnique(List<T> items) => items.forEach(addUnique);

  List<T> withAllUnique(List<T> items) =>
      List<T>.from(this)..addAllUnique(items);

  void replace(T item) {
    final index = indexWhere((e) => e == item);
    if (index == -1) return;
    this[index] = item;
  }

  List<T> withReplace(T item) {
    final list = List<T>.from(this);
    list.replace(item);
    return list;
  }

  List<T> without(T item) => where((e) => e != item).toList();
}
