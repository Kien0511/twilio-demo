import 'package:test_twilio/common/exceptions/app_exception.dart';

class NetworkConnectionException extends AppException {
  NetworkConnectionException()
      : super(
    error: 'NetworkConnectionException',
    message: 'Not connected to the network',
  );
}
