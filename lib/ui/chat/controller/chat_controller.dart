import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_twilio/model/channel_model.dart';
import 'package:test_twilio/model/message_item_model.dart';
import 'package:test_twilio/services/basic_chat_channel.dart';
import 'package:test_twilio/widgets/custom_input_text_field.dart';
import 'package:test_twilio/widgets/message_list_action.dart';

class ChatController extends GetxController {
  final ChannelModel channelModel;

  ChatController(this.channelModel);

  bool initController = false;

  RxList<MessageItemModel> listMessage = RxList([]);

  TextEditingController inputTextController = TextEditingController();

  ScrollController listMessageController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      setRefreshMessagesListCallback();
      setMessageDeleteCallback();
      setMessageUpdateCallback();
      BasicChatChannel().getMessages(channelModel);
    });
  }

  void setRefreshMessagesListCallback() {
    BasicChatChannel().setRefreshMessagesListCallback((data) async {
      if (data is List) {
        final List<MessageItemModel> listMessage = [];
        await Future.forEach(data, (element) {
          if (element is Map) {
            listMessage.add(MessageItemModel.fromJson(Map<String, dynamic>.from(element)));
          }
        });
        this.listMessage.clear();
        this.listMessage.addAll(listMessage);
        try {
          Future.delayed(Duration(milliseconds: 100)).then((_) {
            listMessageController.jumpTo(listMessageController.position.maxScrollExtent);
          });
        } catch (e) {
          print(e);
        }
      }
      print(data);
    });
  }

  void setMessageDeleteCallback() {
    BasicChatChannel().setMessageDeleteCallback((data) {
      final messageItem = MessageItemModel.fromJson(Map<String, dynamic>.from(data as Map));
      this.listMessage.removeWhere((element) => element.message?.sid == messageItem.message!.sid);
    });
  }
  
  void setMessageUpdateCallback() {
    BasicChatChannel().setMessageUpdateCallback((data) {
      final messageItem = MessageItemModel.fromJson(Map<String, dynamic>.from(data as Map));
      final index = this.listMessage.indexWhere((element) => element.message!.sid == messageItem.message!.sid);
      if (index != -1) {
        this.listMessage.removeAt(index);
        this.listMessage.insert(index, messageItem);
      }
    });
  }

  @override
  void onClose() {
    BasicChatChannel().removeChannelListener();
    super.onClose();
  }

  void sendMessage() {
    if (inputTextController.text.trim().toString().isNotEmpty) {
      BasicChatChannel().sendMessage(inputTextController.text.trim().toString());
      inputTextController.text = "";
    }
  }

  void showMessageListAction(MessageItemModel messageItem) {
    Get.bottomSheet(MessageListAction(onUpdateMessage: () {
      Get.dialog(CustomInputTextField(message: messageItem.message!.messageBody!, onUpdate: (messageBody) {
        Get.back();
        BasicChatChannel().updateMessage(messageItem.message!.sid!, messageBody);
      },));
    }, onDeleteMessage: () {
      BasicChatChannel().deleteMessage(messageItem.message!.sid!);
    },));
  }

  void inviteByIdentity() {
    Get.dialog(CustomInputTextField(message: "user identity", onUpdate: (userIdentity) {
      Get.back();
      BasicChatChannel().inviteByIdentity(userIdentity);
    }));
  }
}