import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDateString({String pattern = "yyyy/MM/dd HH:mm"}) {
    try {
      return DateFormat(pattern).format(this);
    } catch (e) {
      return "";
    }
  }
}