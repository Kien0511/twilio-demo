import 'package:get/get.dart';
import 'package:test_twilio/model/channel_model.dart';
import 'package:test_twilio/ui/chat/controller/chat_controller.dart';

class ChatBinding extends Bindings {
  ChannelModel channelModel;

  ChatBinding(this.channelModel);

  @override
  void dependencies() {
    Get.lazyPut(() => ChatController(channelModel));
  }
}