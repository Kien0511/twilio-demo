import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:test_twilio/ui/splash/controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    controller.initController = true;
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Splash"),
        ),
      ),
    );
  }
}