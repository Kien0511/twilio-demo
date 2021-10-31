import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twilio/common/extensions/datetime_extensions.dart';
import 'package:test_twilio/common/extensions/int_extensions.dart';
import 'package:test_twilio/data/entity/message_data_item.dart';
import 'package:test_twilio/model/reaction_attribute.dart';
import 'package:test_twilio/ui/chat/controller/chat_controller.dart';
import 'package:test_twilio/ui/login/controller/login_controller.dart';
import 'package:test_twilio/widgets/emoji_text.dart';
import 'package:test_twilio/widgets/send_status.dart';

class ChatScreen extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          title: Text(
            "${controller.conversationDataItem.friendlyName}",
            style: TextStyle(
                color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
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

  Widget _buildInputMessage() {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.attachment_rounded),
          SizedBox(width: 16.0,),
          Expanded(
              child: TextFormField(
                controller: controller.messageTextController,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "New Message",
                  hintStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(),
                  labelText: "New Message",
                  suffixIcon: InkWell(onTap: () {
                    controller.sendTextMessage();
                  },child: Icon(Icons.send)),
                  filled: true,
                  fillColor: Colors.white
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildListMessage() {
    return GetBuilder(
      init: controller,
      id: "listMessage",
      builder: (_) {
        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.all(16.0),
            reverse: true,
            itemBuilder: (context, index) {
              final message = controller.getMessages()[index];
              if (message.author == author) {
                return _buildCurrentMessage(message);
              } else {
                return _buildItemMessage(message);
              }
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 12.0,);
            },
            itemCount: controller.getMessages().length);
      },
    );
  }

  Widget _buildItemMessage(MessageDataItem message) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: 256.0
          ),
          child: message.type == 1? _buildMediaMessage(message) : Container(
              color: Colors.red,
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
              child: Text("${message.body}")),
        )
      ],
    );
  }

  Widget _buildCurrentMessage(MessageDataItem message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: 256.0
          ),
          child: message.type == 1? _buildMediaMessage(message) : Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onLongPress: () {
                    controller.showMessageListAction(message);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blue[900],
                    ),
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${message.body}", textAlign: TextAlign.right, style: TextStyle(color: Colors.white),),
                          SizedBox(height: 8.0,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${message.dateCreated?.toDateTime().toDateString()}", style: TextStyle(fontSize: 12.0, color: Colors.white),),
                              SizedBox(width: 8.0,),
                              SendStatus(message.sendStatus)
                            ],
                          )
                        ],
                      )),
                ),
              ),
              _buildReaction(message),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMediaMessage(MessageDataItem message) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: 100.0,
          margin: EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: message.author == author ? Colors.blue[900] : Colors.grey[350]
          ),
          padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.0,
                          child: Icon(Icons.download_rounded)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${message.mediaFileName}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${message.mediaSize?.toFileSize()}",
                              style: TextStyle(color: Colors.grey[600]),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0,),
              Row(
                children: [
                  Text("${message.dateCreated?.toDateTime().toDateString()}", style: TextStyle(fontSize: 12.0, color: Colors.white),),
                  SizedBox(width: 8.0,),
                  SendStatus(message.sendStatus)
                ],
              ),
            ],
          ),
        ),
        _buildReaction(message)
      ],
    );
  }

  Widget _buildReaction(MessageDataItem message) {
    final reactions = message.toReactionAttribute()?.reactions;
    return reactions != null ? Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          reactions.heart?.isNotEmpty == true ? EmojiText(text: Reaction.reactionHeart, count: reactions.heart?.length) : SizedBox(),
          reactions.thumbsUp?.isNotEmpty == true ? EmojiText(text: Reaction.reactionThumbsUp, count: reactions.thumbsUp?.length) : SizedBox(),
          reactions.laugh?.isNotEmpty == true ? EmojiText(text: Reaction.reactionLaugh, count: reactions.laugh?.length) : SizedBox(),
          reactions.sad?.isNotEmpty == true ? EmojiText(text: Reaction.reactionSad, count: reactions.sad?.length) : SizedBox(),
          reactions.pouting?.isNotEmpty == true ? EmojiText(text: Reaction.reactionPouting, count: reactions.pouting?.length) : SizedBox(),
          reactions.thumbsDown?.isNotEmpty == true ? EmojiText(text: Reaction.reactionThumbsDown, count: reactions.thumbsDown?.length) : SizedBox(),
        ],
      ),
    ) : SizedBox();
  }
}