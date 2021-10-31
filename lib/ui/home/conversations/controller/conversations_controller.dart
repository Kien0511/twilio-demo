import 'package:get/get.dart';
import 'package:test_twilio/data/database_helper.dart';
import 'package:test_twilio/data/entity/conversation_data_item.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/services/basic_conversation_channel.dart';

class ConversationsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      BasicConversationsChannel().setOnUpdateConversation(() {
        update(["listConversation"]);
      });
      getConversations();
    });
  }

  Future<void> getConversations() async {
    final localData = await DatabaseHelper().conversationsDao?.getUserConversations();
    final conversations = await BasicConversationsChannel().getConversations();
    final localDataMap = Map.fromIterable(localData ?? [], key: (e) => e.sid, value: (e) => e);
    final conversationsMap = Map.fromIterable(conversations, key: (e) => e.sid, value: (e) => e);
    getConversationsMap().clear();
    for (ConversationDataItem element in conversations) {
      final isExists = localDataMap[element.sid] != null;
      if (isExists) {
        localDataMap.remove(element.sid);
      }
    }
    getConversationsMap().addAll(Map<String, ConversationDataItem>.from(conversationsMap));
    getConversationsMap().addAll(Map<String, ConversationDataItem>.from(localDataMap));
    print(getConversationsMap());
    update(["listConversation"]);
  }

  Map<String,ConversationDataItem> getConversationsMap() {
    return BasicConversationsChannel().mapConversations;
  }

  void joinConversation(ConversationDataItem conversation) {
    Get.toNamed(RouteName.chat, arguments: conversation);
  }
}