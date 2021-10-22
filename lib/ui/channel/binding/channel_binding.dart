import 'package:get/get.dart';
import 'package:test_twilio/services/arguments/basic_chat_client_argument.dart';
import 'package:test_twilio/ui/channel/controller/channel_controller.dart';

class ChannelBinding extends Bindings {
  BasicChatClientArgument argument;

  ChannelBinding(this.argument);

  @override
  void dependencies() {
    Get.lazyPut(() => ChannelController(argument));
  }
}