import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twilio/data/entity/conversation_data_item.dart';
import 'package:test_twilio/ui/home/conversations/controller/conversations_controller.dart';
import 'package:test_twilio/common/extensions/int_extensions.dart';
import 'package:test_twilio/common/extensions/datetime_extensions.dart';

class ConversationsScreen extends StatelessWidget {
  final controller = Get.put(ConversationsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent[700],
        title: Text(
          "Conversations",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildListConversation(),
    );
  }

  Widget _buildListConversation() {
    return GetBuilder(
      init: controller,
      id: "listConversation",
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            children: List.generate(controller.getConversationsMap().length, (index) {
              final conversation = controller.getConversationsMap().values.toList()[index];
              return _buildItemConversation(conversation);
            }),
          ),
        );
      },
    );
  }

  Widget _buildItemConversation(ConversationDataItem conversation) {
    return InkWell(
      onTap: () {
        controller.joinConversation(conversation);
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.red,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(conversation.friendlyName ?? "", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),)),
                Text("${conversation.participantsCount ?? 0} participants")
              ],
            ),
            SizedBox(height: 4.0,),
            Row(
              children: [
                Expanded(child: Text(conversation.lastMessageText ?? "")),
                Text("${conversation.lastMessageDate?.toDateTime().toDateString()}")
              ],
            ),
          ],
        ),
      ),
    );
  }
}