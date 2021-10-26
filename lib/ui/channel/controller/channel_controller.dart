import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_twilio/model/conversation_model.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/services/arguments/basic_chat_client_argument.dart';
import 'package:test_twilio/services/basic_chat_channel.dart';
import 'package:test_twilio/widgets/channel_list_action.dart';
import 'package:test_twilio/widgets/custom_input_text_field.dart';

class ChannelController extends GetxController {
  BasicChatClientArgument argument;
  ChannelController(this.argument);

  Rx<Map<String, ConversationModel>> listChannel = Rx({});

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100)).then((_) async {
      setRefreshChannelListCallback();
      await BasicChatChannel().initBasicChatClient(argument);
      BasicChatChannel().getChannels();
    });
  }

  void setRefreshChannelListCallback() {
    BasicChatChannel().setRefreshChannelListCallback((data) {
      if (data is Map) {
        final newMap = Map<String, ConversationModel>();
        for (final MapEntry entry in data.entries) {
          newMap[entry.key] = ConversationModel.fromJson(Map<String, dynamic>.from(entry.value as Map));
        }
        listChannel.value = newMap;
      }
    });
  }

  void checkJoinChannel(ConversationModel channel) {
    if (channel.status == 1) {
      Get.toNamed(RouteName.chat, arguments: channel);
    } else {
      Get.dialog(CupertinoAlertDialog(
        content: Text("Join to channel"),
        actions: [
          CupertinoDialogAction(child: Text("cancel"), onPressed: () {
            Get.back();
          },),
          CupertinoDialogAction(child: Text("join"), onPressed: () async {
            Get.back();
            final result = await BasicChatChannel().joinChannel(channel);
            if (result) {
              Get.toNamed(RouteName.chat, arguments: channel);
            } else {
              _joinChannelError();
            }
          },)
        ],
      ), barrierDismissible: false);
    }
  }

  void _joinChannelError() {
    Get.dialog(CupertinoAlertDialog(
      content: Text("Join channel error"),
      actions: [
        CupertinoDialogAction(child: Text("OK"), onPressed: () {
          Get.back();
        },)
      ],
    ));
  }

  void createChannel() {
    Get.bottomSheet(ChannelListAction(
      onCreate: () {
        _inputChannelName();
      },
    ));
  }

  void _inputChannelName() {
    Get.dialog(CustomInputTextField(message: "conversation name", titleAction: "Create", onUpdate: (channelName) async {
      final result = await BasicChatChannel().createConversation(channelName);
      if (result is bool) {
        print("result is bool");
      } else {
        print("error: $result");
      }
      Get.back();
    },));
  }
}