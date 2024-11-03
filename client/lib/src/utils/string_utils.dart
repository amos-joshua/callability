

extension StringUtils on String {
  String get capitalized {
    if (isEmpty) return '';
    return replaceFirst(this[0], this[0].toUpperCase());
  }
}
