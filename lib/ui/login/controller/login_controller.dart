import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_twilio/network/api_result.dart';
import 'package:test_twilio/repository/user_chat_repository.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/services/basic_conversation_channel.dart';

String author = "";
String accessToken = "";

class LoginController extends GetxController {
  final UserChatRepository _userChatRepository;

  LoginController(this._userChatRepository);

  TextEditingController identityTextController = TextEditingController(text: "user00");
  TextEditingController passwordTextController = TextEditingController(text: "password00");

  Future<void> login() async {
    final identity = identityTextController.text.trim().toString();
    final password = passwordTextController.text.trim().toString();
    final ApiResult<String> apiResult = await _userChatRepository.getAccessToken(identity, password);
    apiResult.when(success: (String data) async {
      print("success");
      author = identity;
      accessToken = data;
      final result = await BasicConversationsChannel().createConversationsClient(data);
      if (result is bool) {
        print("create success");
        FirebaseMessaging.instance.getToken().then((value) {
          print("fcmToken: $value");
          if (value != null) {
            BasicConversationsChannel().setFirebaseToken(value);
          }
        });
        Get.toNamed(RouteName.home);
      } else {
        print("create failed");
      }
    }, failure: (error) {
      print("error");
    });
  }
}