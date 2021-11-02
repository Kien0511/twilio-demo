import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twilio/data/entity/message_data_item.dart';
import 'package:test_twilio/model/reaction_attribute.dart';
import 'package:test_twilio/common/extensions/iterable_extension.dart';
import 'package:test_twilio/ui/login/controller/login_controller.dart';

class MessageListAction extends StatelessWidget {
  final Function? onDeleteMessage;
  final MessageDataItem? message;
  final Function(MessageDataItem?)? onReactionSelected;

  MessageListAction({this.onDeleteMessage, this.message, this.onReactionSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildListReaction(),
          _buildAction("Delete message", onDeleteMessage),
        ],
      ),
    );
  }

  Widget _buildListReaction() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildReaction(Reaction.reactionHeart, ReactionName.reactionHeart),
          _buildReaction(Reaction.reactionThumbsUp, ReactionName.reactionThumbsUp),
          _buildReaction(Reaction.reactionLaugh, ReactionName.reactionLaugh),
          _buildReaction(Reaction.reactionSad, ReactionName.reactionSad),
          _buildReaction(Reaction.reactionPouting, ReactionName.reactionPouting),
          _buildReaction(Reaction.reactionThumbsDown, ReactionName.reactionThumbsDown),
        ],
      ),
    );
  }

  Widget _buildReaction(String reaction, String reactionName) {
    var reactionAttribute = message?.toReactionAttribute();
    final isSelected = _isReactionSelected(reactionAttribute?.reactions, reactionName);
    return InkWell(
      borderRadius: BorderRadius.circular(4.0),
      onTap: () {
        if (isSelected) {
          reactionAttribute?.removeReaction(reactionName, author);
          print(reactionAttribute);
          Get.back();
          final newMessage = MessageDataItem.fromMap(message!.toMap());
          newMessage.attributes = reactionAttribute?.toJson().toString();
          onReactionSelected?.call(newMessage);
        } else {
          if (reactionAttribute == null) {
            reactionAttribute = ReactionAttribute();
          }
          reactionAttribute?.addReaction(reactionName, author);
          print(reactionAttribute);
          Get.back();
          final newMessage = MessageDataItem.fromMap(message!.toMap());
          newMessage.attributes = reactionAttribute?.toJson().toString();
          onReactionSelected?.call(newMessage);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: isSelected ? Colors.blue : Colors.transparent
        ),
          padding: EdgeInsets.all(8.0),
          child: Text(reaction, style: TextStyle(fontSize: 24.0),)),
    );
  }

  Widget _buildAction(String message, Function? onTap) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          Get.back();
          onTap?.call();
        },
        child: Row(
          children: [
            Container(
              width: 48.0,
            height: 48.0,
                child: Icon(Icons.delete, color: Colors.red,)),
            Text("Delete", style: TextStyle(color: Colors.red),)
          ],
        ),
      ),
    );
  }

  bool _isReactionSelected(Reactions? reactions, String reactionName) {
    switch (reactionName) {
      case ReactionName.reactionHeart:
        return reactions?.heart?.firstWhereOrNull((element) => element == author) != null;
      case ReactionName.reactionThumbsUp:
        return reactions?.thumbsUp?.firstWhereOrNull((element) => element == author) != null;
      case ReactionName.reactionLaugh:
        return reactions?.laugh?.firstWhereOrNull((element) => element == author) != null;
      case ReactionName.reactionSad:
        return reactions?.sad?.firstWhereOrNull((element) => element == author) != null;
      case ReactionName.reactionPouting:
        return reactions?.pouting?.firstWhereOrNull((element) => element == author) != null;
      case ReactionName.reactionThumbsDown:
        return reactions?.thumbsDown?.firstWhereOrNull((element) => element == author) != null;
      default:
        return false;
    }
  }
}