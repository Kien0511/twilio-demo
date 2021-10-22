import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_twilio/model/access_token_response.dart';
import 'package:test_twilio/network/api_result.dart';
import 'package:test_twilio/repository/user_chat_repository.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/services/arguments/basic_chat_client_argument.dart';

String author = "";

class LoginController extends GetxController {
  final UserChatRepository _userChatRepository;

  LoginController(this._userChatRepository);

  TextEditingController loginTextController = TextEditingController();

  Future<void> login() async {
    if (loginTextController.text.trim().isEmpty) {
      return;
    }
    final ApiResult<AccessTokenResponse> apiResult = await _userChatRepository.getAccessToken(loginTextController.text.trim().toString());
    apiResult.when(success: (AccessTokenResponse data) async {
      print("success");
      author = loginTextController.text.trim().toString();
      Get.toNamed(RouteName.channel, arguments: BasicChatClientArgument(data.token!, "firebaseToken"));
    }, failure: (error) {
      print("error");
    });
  }
}