import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_twilio/common/exceptions/network_connection_exception.dart';
import 'package:flutter/foundation.dart';
part 'network_exceptions.freezed.dart';

@freezed
class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.unauthorisedRequest() = UnauthorisedRequest;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.invalidateError(dynamic error) = InvalidateError;

  const factory NetworkExceptions.serverExceptionError(int code, String message) = ServerExceptionError;

  const factory NetworkExceptions.defaultError() = DefaultError;

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;

        if (error is DioError && error.error is NetworkConnectionException) return NetworkExceptions.noInternetConnection();

        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.other:
              networkExceptions = NetworkExceptions.defaultError();
              break;
            case DioErrorType.response:
              switch (error.response!.statusCode) {
                case 401:
                  networkExceptions = NetworkExceptions.unauthorisedRequest();
                  break;

                case 422:
                  networkExceptions = NetworkExceptions.invalidateError(error.response!.data);
                  break;

                default:
                  networkExceptions = NetworkExceptions.serverExceptionError(error.response!.statusCode!, error.response!.data['message']);
              }
              break;

            default:
              networkExceptions = NetworkExceptions.defaultError();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = NetworkExceptions.defaultError();
        }
        return networkExceptions;
      } catch (_) {
        return NetworkExceptions.defaultError();
      }
    } else {
      return NetworkExceptions.defaultError();
    }
  }
}