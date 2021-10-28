import 'package:get/get.dart';
import 'package:test_twilio/ui/video_call/controller/video_call_controller.dart';

class VideoCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoCallController());
  }
}