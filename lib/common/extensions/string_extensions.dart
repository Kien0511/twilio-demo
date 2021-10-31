extension StringExtensions on String {
  bool? toBool() {
    try {
      return this.toLowerCase() == 'true';
    } catch (e) {
      return null;
    }
  }

  int? toInt() {
    try {
      return int.parse(this);
    } catch (e) {
      return null;
    }
  }
}