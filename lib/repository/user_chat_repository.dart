import 'package:test_twilio/model/access_token_response.dart';
import 'package:test_twilio/network/api_result.dart';
import 'package:test_twilio/network/app_client.dart';
import 'package:test_twilio/network/network_exceptions.dart';

abstract class IUserChatRepository {
  Future<ApiResult<AccessTokenResponse>> getAccessToken(String identity, {int ttl = 3600});
}

class UserChatRepository extends IUserChatRepository {
  final AppClient _appClient;

  UserChatRepository(this._appClient);

  @override
  Future<ApiResult<AccessTokenResponse>> getAccessToken(String identity, {int ttl = 3600}) async {
    try {
      final data = {
        "identity" : identity,
        "ttl": ttl,
      };
      final response = await _appClient.get("/token.php", queryParam: data);
      print("AccessTokenResponse: $response");
      return ApiResult.success(data: AccessTokenResponse.fromJson(response));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}