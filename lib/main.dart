import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twilio/bindings/app_bindings.dart';
import 'package:test_twilio/routes/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      navigatorKey: Get.key,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: RouteName.splash,
      initialBinding: AppBindings(),
      enableLog: true,
      debugShowCheckedModeBanner: true,
    );
  }
}
