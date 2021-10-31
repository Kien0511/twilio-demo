import 'package:get/get.dart';
import 'package:test_twilio/routes/router.dart';

class SplashController extends GetxController {
  var initController = false;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 2)).then((_) {
      Get.offAllNamed(RouteName.login);
    });
  }
}