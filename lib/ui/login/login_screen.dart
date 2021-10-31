import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:test_twilio/ui/login/controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.identityTextController,
            ),
            SizedBox(
              height: 24.0,
            ),
            TextField(
              controller: controller.passwordTextController,
            ),
            SizedBox(
              height: 24.0,
            ),
            Material(
              color: Colors.red,
              child: InkWell(
                onTap: () {
                  controller.login();
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 56.0,
                    child: Text("Login")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
