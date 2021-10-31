import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_twilio/data/database_helper.dart';
import 'package:test_twilio/data/entity/conversation_data_item.dart';
import 'package:test_twilio/data/entity/message_data_item.dart';
import 'package:test_twilio/services/basic_conversation_channel.dart';
import 'package:test_twilio/widgets/message_list_action.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final ConversationDataItem conversationDataItem;

  TextEditingController messageTextController = TextEditingController();

  ChatController(this.conversationDataItem);

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      BasicConversationsChannel().setOnUpdateListMessage(() {
        update(["listMessage"]);
      });
      loadMessages();
    });
  }

  Future<void> loadMessages() async {
    final localMessage = await DatabaseHelper().messagesDao?.getMessagesSorted(conversationDataItem.sid!);
    final messages = await BasicConversationsChannel().getMessages(conversationDataItem.sid!);
    final Map<String, MessageDataItem> localDataMap = Map.fromIterable(localMessage ?? [], key: (e) {
      if (e.sid?.isNotEmpty == true) {
        return e.sid!;
      } else {
        return e.uuid!;
      }
    }, value: (e) => e);
    getMessages().clear();
    for (MessageDataItem message in messages) {
      final isExists = localDataMap[message.sid] != null || localDataMap[message.uuid] != null;
      if (isExists) {
        localDataMap.remove(message.sid);
        localDataMap.remove(message.uuid);
      }
    }
    getMessages().addAll(messages.reversed);
    getMessages().addAll(localDataMap.values.toList().reversed);
    print(getMessages());
    update(["listMessage"]);
  }

  Future<void> sendTextMessage() async {
    if (messageTextController.text.trim().isEmpty) {
      return;
    }
    final map = {
      "conversationSid": conversationDataItem.sid,
      "body": messageTextController.text.trim().toString(),
      "uuid": Uuid().v4()
    };
    MessageDataItem messageDataItem = MessageDataItem.fromMap(map);
    BasicConversationsChannel().sendTextMessage(messageDataItem);
    messageTextController.text = "";
  }

  List<MessageDataItem> getMessages() {
    return BasicConversationsChannel().messages;
  }

  void showMessageListAction(MessageDataItem message) {
    Get.bottomSheet(MessageListAction(
      onUpdateMessage: () {

      },
      onDeleteMessage: () async {
        final result = await BasicConversationsChannel().removeMessage(message);
        if (result) {
          print("Delete success");
        } else {
          print("Delete failed");
        }
      },
    ));
  }
}