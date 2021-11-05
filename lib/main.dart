import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twilio/bindings/app_bindings.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/services/app_lifecycle_observer.dart';
import 'package:test_twilio/services/notification_service.dart';

final test22 = StreamController<bool>.broadcast();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  NotificationService().initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    delayPush();
    WidgetsBinding.instance?.addObserver(AppLifecycleObserver());

    AppLifecycleObserver().status.listen((AppLifecycleState state) {
      print(Get.currentRoute);
    });

    AppLifecycleObserver().inCallComingStatus.listen((dynamic event) {
      print("event: $event");
    });

    AppLifecycleObserver().testStatus.listen((bool b) {
      print("testStatus: $b");
    });

    test22.stream.listen((bool b) {
      print("test 22: $b");
    });
  }

  void delayPush() {
    Future.delayed(Duration(seconds: 3), (){
      AppLifecycleObserver().addInComingCallState({"test": "test"});
      test22.add(false);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(AppLifecycleObserver());
    print('finish app lifecycle observer');
    super.dispose();
  }

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
