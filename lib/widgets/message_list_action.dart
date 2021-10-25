import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageListAction extends StatelessWidget {
  final Function? onUpdateMessage;
  final Function? onDeleteMessage;
  final Function? onCancel;

  MessageListAction({this.onUpdateMessage, this.onDeleteMessage, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAction("Update message", onUpdateMessage),
          Divider(height: 1.0,),
          _buildAction("Delete message", onDeleteMessage),
          Divider(height: 1.0,),
          SizedBox(height: 24.0,),
          _buildAction("cancel", onCancel),
        ],
      ),
    );
  }

  Widget _buildAction(String message, Function? onTap) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Get.back();
          onTap?.call();
        },
        child: Container(
          height: 56.0,
          child: Center(child: Text(message)),
        ),
      ),
    );
  }
}