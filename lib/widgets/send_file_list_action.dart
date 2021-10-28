import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendFileListAction extends StatelessWidget {
  final Function? sendImageGallery;
  final Function? sendImageCamera;
  final Function? sendVideoGallery;
  final Function? sendVideoCamera;
  final Function? onCancel;

  SendFileListAction({this.sendImageGallery, this.onCancel, this.sendImageCamera, this.sendVideoGallery, this.sendVideoCamera});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAction("image gallery", sendImageGallery),
          SizedBox(height: 8.0,),
          _buildAction("image camera", sendImageCamera),
          SizedBox(height: 8.0,),
          _buildAction("video gallery", sendVideoGallery),
          SizedBox(height: 8.0,),
          _buildAction("video camera", sendVideoCamera),
          SizedBox(height: 8.0,),
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