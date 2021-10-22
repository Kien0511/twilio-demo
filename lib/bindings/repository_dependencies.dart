
import 'package:get/get.dart';
import 'package:test_twilio/repository/user_chat_repository.dart';

/// injectRepositories
void injectRepositories() {
  Get.put(UserChatRepository(Get.find()));
}
