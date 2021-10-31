import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twilio/bindings/app_bindings.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  NotificationService().initialize();
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
