extension ListComparison<T> on List<T> {
  /// Compares this list with another list and returns true if they contain
  /// the same elements in the same order.
  ///
  /// Example usage:
  /// ```dart
  /// final list1 = [1, 2, 3];
  /// final list2 = [1, 2, 3];
  /// final areEqual = list1.isEqualTo(list2); // returns true
  /// ```
  bool isEqualTo(List<T> other) {
    if (length != other.length) return false;

    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }

    return true;
  }

  /// Returns true if this list contains all elements from the other list,
  /// regardless of order.
  bool containsAll(List<T> other, bool Function(T e, T o) check) {
    if (length != other.length) return false;

    final thisCopy = List<T>.from(this);

    for (final element in other) {
      final index = thisCopy.indexWhere((e) => check(e, element));
      if (index == -1) return false;
      thisCopy.removeAt(index);
    }

    return true;
  }
}
