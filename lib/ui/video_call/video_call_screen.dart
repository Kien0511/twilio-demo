import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twilio/ui/video_call/controller/video_call_controller.dart';

class VideoCallScreen extends GetView<VideoCallController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Call"),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Obx(() => controller.permissionGranted.value
            ? Stack(
                children: [
                  Platform.isIOS
                      ? Container()
                      : AndroidView(viewType: "AndroidCameraView"),
                  _buildListAction(),
                ],
              )
            : Container(
          color: Colors.black,
        )),
      ),
    );
  }

  Widget _buildListAction() {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(
              () => _buildAction(
                  iconActive: Icons.mic_off_rounded,
                  iconInactive: Icons.mic_none_rounded,
                  colorActive: Colors.black.withOpacity(0.5),
                  colorInactive: Colors.white,
                  isActive: controller.isMicOn.value,
                  onTap: () {
                    controller.micChange();
                  }),
            ),
            SizedBox(
              width: 24.0,
            ),
            _buildAction(
              width: 64.0,
              height: 64.0,
              colorInactive: Colors.red[400],
              colorActive: Colors.white,
              iconActive: Icons.call_end,
              iconInactive: Icons.call_end,
              iconSize: 36.0,
              onTap: () {
                controller.endCall();
              }
            ),
            SizedBox(
              width: 24.0,
            ),
            Obx(() => _buildAction(
                iconActive: Icons.volume_up_rounded,
                iconInactive: Icons.volume_off,
                colorActive: Colors.black.withOpacity(0.5),
                colorInactive: Colors.white,
                isActive: controller.isVolumeOn.value,
                onTap: () {
                  controller.volumeChange();
                })),
          ],
        ),
      ),
    );
  }

  Widget _buildAction({
    double width = 48.0,
    double height = 48.0,
    Color? colorActive,
    Color? colorInactive,
    required IconData iconActive,
    required IconData iconInactive,
    bool isActive = false,
    double iconSize = 24.0,
    Function? onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? colorActive : colorInactive),
        child: Icon(
          isActive ? iconActive : iconInactive,
          color: isActive ? colorInactive : colorActive,
          size: iconSize,
        ),
      ),
    );
  }
}
