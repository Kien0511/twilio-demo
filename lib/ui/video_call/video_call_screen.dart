import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:test_twilio/ui/video_call/controller/video_call_controller.dart';

class VideoCallScreen extends GetView<VideoCallController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Call"),),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Platform.isIOS ? Container() : AndroidView(viewType: "AndroidCameraView"),
      ),
    );
  }
}