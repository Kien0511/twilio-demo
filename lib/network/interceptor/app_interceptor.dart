import 'package:dio/dio.dart';
import 'package:test_twilio/common/exceptions/network_connection_exception.dart';
import 'package:test_twilio/network/network_info.dart';

class AppInterceptor extends Interceptor {
  final NetworkInfo networkInfo;
  AppInterceptor(this.networkInfo);

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (await networkInfo.isConnected()) {
      return options;
    }

    throw NetworkConnectionException();
  }

  @override
  Future onError(DioError err,  ErrorInterceptorHandler handler) async {
    return err;
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    return response;
  }
}