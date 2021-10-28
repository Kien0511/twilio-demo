import 'package:dio/dio.dart';

import 'dio/dio_client.dart';

/// AppClient
class AppClient extends DioClient {
  AppClient() : super(options: _getDioOptions());

  /// config dio client option
  static BaseOptions _getDioOptions() {
    return BaseOptions(
        baseUrl: "https://c897-27-76-237-147.ngrok.io",
        connectTimeout: 30000,
        headers: _getAuthenticationHeader());
  }

  ///get HTTP Header
  static Map<String, String> _getAuthenticationHeader() {
    return <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
}
