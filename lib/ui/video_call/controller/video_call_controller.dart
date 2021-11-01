import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_twilio/services/basic_video_channel.dart';

class VideoCallController extends GetxController {
  RxBool permissionGranted = RxBool(false);
  RxBool isMicOn = RxBool(true);
  RxBool isVolumeOn = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100)).then((_) async {
      if (await _requestPermissions()) {
        _connectToRoom();
      }
    });
  }

  Future<bool> _requestPermissions() async {
    permissionGranted.value = await Permission.camera.request().isGranted && await Permission.microphone.request().isGranted;
    return permissionGranted.value;
  }

  Future<void> _connectToRoom() async {
    BasicVideoChannel().connectToRoom();
  }

  @override
  void onClose() {
    BasicVideoChannel().disconnect();
    super.onClose();
  }

  void micChange() {
    isMicOn.value = !isMicOn.value;
  }

  void volumeChange() {
    isVolumeOn.value = !isVolumeOn.value;
  }

  void endCall() {
    Get.back();
  }
}