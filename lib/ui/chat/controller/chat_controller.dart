import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_twilio/model/channel_model.dart';
import 'package:test_twilio/model/message_item_model.dart';
import 'package:test_twilio/services/basic_chat_channel.dart';

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
}