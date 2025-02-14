extension LowerCaseToSpace on String {
  String toSpaceSeperated() {
    String newString = '';
    for (String s in split('')) {
      if (s._isUpperCase()) {
        newString += ' $s';
        continue;
      }
      newString += s;
    }
    return newString;
  }

  String capitalize() {
    if (isEmpty) {
      return this; // Return empty string if input is empty
    }

    return this[0].toUpperCase() + substring(1);
  }

  String toTitleCase() => split(' ').map((word) => word.capitalize()).join(" ");

  bool _isUpperCase() => this == toUpperCase();
}
