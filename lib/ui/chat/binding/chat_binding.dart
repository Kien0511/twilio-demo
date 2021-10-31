import 'package:get/get.dart';
import 'package:test_twilio/data/entity/conversation_data_item.dart';
import 'package:test_twilio/ui/chat/controller/chat_controller.dart';

class ChatBinding extends Bindings {
  final ConversationDataItem conversationDataItem;

  ChatBinding(this.conversationDataItem);

  @override
  void dependencies() {
    Get.lazyPut(() => ChatController(conversationDataItem));
  }
}