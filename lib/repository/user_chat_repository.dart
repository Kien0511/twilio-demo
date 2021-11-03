import 'package:test_twilio/network/api_result.dart';
import 'package:test_twilio/network/app_client.dart';
import 'package:test_twilio/network/network_exceptions.dart';

abstract class IUserChatRepository {
  Future<ApiResult<String>> getAccessToken(String identity, String password);
  Future<ApiResult<dynamic>> sendNotification(String identity, String body);
  Future<ApiResult<dynamic>> registerBinding(String identity, String accessToken);
}

class UserChatRepository extends IUserChatRepository {
  final AppClient _appClient;

  UserChatRepository(this._appClient);

  @override
  Future<ApiResult<String>> getAccessToken(String identity, String password) async {
    try {
      final data = {
        "identity" : identity,
        "password": password,
      };
      final response = await _appClient.get("/token-service", queryParam: data);
      print("AccessTokenResponse: $response");
      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> sendNotification(String identity, String body) async {
    try {
      final data = {
        "identity": identity,
        "body": body
      };
      final result = await _appClient.get("/send-notification", queryParam: data);
      return ApiResult.success(data: result);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult> registerBinding(String identity, String accessToken) async {
    try {
      final data = {
        "identity": identity,
        "BindingType": "fcm",
        "Address": accessToken
      };
      final result = await _appClient.get("/register-binding", queryParam: data);
      print("result: $result");
      return ApiResult.success(data: result);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}