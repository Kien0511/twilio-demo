import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twilio/ui/home/my_page/controller/my_page_controller.dart';

class MyPageScreen extends StatelessWidget {
  final controller = Get.put(MyPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("MyPage"),
    );
  }
}