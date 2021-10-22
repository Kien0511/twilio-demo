abstract class AppException implements Exception {
  final dynamic error;
  final String? message;

  AppException({this.error, this.message});
}
