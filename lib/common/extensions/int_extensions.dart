extension IntExtensions on int {
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  String toFileSize() {
    try {
      if (this > (1024 * 1024 * 1024)) {
        return "${(this / (1024 * 1024 * 1024)).floor()} gB";
      } else if (this > (1024 * 1024)) {
        return "${(this / (1024 * 1024)).floor()} mB";
      } else {
        return "${(this / 1024).floor()} kB";
      }
    } catch (e) {
      return "";
    }
  }
}
