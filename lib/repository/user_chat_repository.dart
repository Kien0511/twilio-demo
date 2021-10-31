import 'package:test_twilio/network/api_result.dart';
import 'package:test_twilio/network/app_client.dart';
import 'package:test_twilio/network/network_exceptions.dart';

abstract class IUserChatRepository {
  Future<ApiResult<String>> getAccessToken(String identity, String password);
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
}