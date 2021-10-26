import 'package:get/get.dart';
import 'package:test_twilio/model/access_token_response.dart';
import 'package:test_twilio/model/conversation_model.dart';
import 'package:test_twilio/network/api_result.dart';
import 'package:test_twilio/repository/user_chat_repository.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/services/arguments/basic_chat_client_argument.dart';
import 'package:test_twilio/services/basic_chat_channel.dart';

class SplashController extends GetxController {
  var initController = false;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 2)).then((_) {
      Get.offAllNamed(RouteName.login);
    });
  }
}