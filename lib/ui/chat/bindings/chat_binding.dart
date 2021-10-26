import 'package:get/get.dart';
import 'package:test_twilio/model/conversation_model.dart';
import 'package:test_twilio/ui/chat/controller/chat_controller.dart';

class ChatBinding extends Bindings {
  ConversationModel channelModel;

  ChatBinding(this.channelModel);

  @override
  void dependencies() {
    Get.lazyPut(() => ChatController(channelModel));
  }
}