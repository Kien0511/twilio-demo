import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:test_twilio/model/message_item_model.dart';
import 'package:test_twilio/ui/chat/controller/chat_controller.dart';
import 'package:test_twilio/ui/login/controller/login_controller.dart';

class ChatScreen extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    controller.initController = true;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat screen"),
        ),
        body: Column(
          children: [
            Expanded(child: _buildListMessage()),
            _buildInputMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildListMessage() {
    return Obx(() => ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      controller: controller.listMessageController,
        itemBuilder: (context, index) {
          final MessageItemModel messageItem = controller.listMessage[index];
          if (messageItem.message?.author == author) {
            return _buildCurrentMessage(messageItem);
          } else {
            return _buildMessage(messageItem);
          }
        },
        separatorBuilder: (context, indext) {
          return SizedBox(
            height: 12.0,
          );
        },
        itemCount: controller.listMessage.length));
  }

  Widget _buildMessage(MessageItemModel messageItem) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: 256.0
          ),
          child: Container(
              color: Colors.red,
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
              child: Text("${messageItem.message?.messageBody}")),
        )
      ],
    );
  }

  Widget _buildCurrentMessage(MessageItemModel messageItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 256.0
          ),
          child: Container(
              color: Colors.blue,
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
              child: Text("${messageItem.message?.messageBody}", textAlign: TextAlign.right,)),
        )
      ],
    );
  }

  Widget _buildInputMessage() {
    return Row(
      children: [
        Expanded(child: TextField(
          controller: controller.inputTextController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal)),
              hintText: 'input',
              suffixStyle: const TextStyle(color: Colors.green)),
        )),
        Container(
          height: 40.0,
          child: InkWell(
            onTap: () {
              controller.sendMessage();
            },
            child: Center(child: Text("Send Message")),
          ),
        )
      ],
    );
  }
}
