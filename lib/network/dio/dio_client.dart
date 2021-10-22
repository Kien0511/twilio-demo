import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test_twilio/network/dio/cancel_token_factory.dart';
class DioClient {
  late Dio _dio;
  BaseOptions options;

  DioClient({required this.options, Interceptor? interceptor}) {
    _dio = Dio(options);
    if (interceptor != null) {
      _dio.interceptors..add(interceptor);
    }
    _dio.interceptors..add(PrettyDioLogger());

  }

  dynamic get(String path, {Map<String, dynamic>? queryParam, CancelToken? cancelToken, Options? options}) async {
    Response response;

    response = await _dio.get(path, options: options, queryParameters: queryParam, cancelToken: cancelToken ?? CancelTokenFactory.getInstance().cancelToken);

    return response.data;
  }

  dynamic put(String path, dynamic data, {CancelToken? cancelToken}) async {
    Response response;

    response = await _dio.put(path, data: data, cancelToken: cancelToken ?? CancelTokenFactory.getInstance().cancelToken);

    return response.data;
  }

  dynamic patch(String path, dynamic data, {CancelToken? cancelToken}) async {
    Response response;

    response = await _dio.patch(path, data: data, cancelToken: cancelToken ?? CancelTokenFactory.getInstance().cancelToken);

    return response.data;
  }

  dynamic post(String path, dynamic data, {CancelToken? cancelToken}) async {
    Response response;

    response = await _dio.post(path, data: data, cancelToken: cancelToken ?? CancelTokenFactory.getInstance().cancelToken);

    return response.data;
  }

  dynamic delete(String path, {Map<String, dynamic>? queryParam, CancelToken? cancelToken}) async {
    Response response;

    response = await _dio.delete(path, queryParameters: queryParam, cancelToken: cancelToken ?? CancelTokenFactory.getInstance().cancelToken);

    return response.data;
  }
}
