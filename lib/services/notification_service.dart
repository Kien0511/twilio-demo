import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  NotificationService._internal();

  factory NotificationService() => _notificationService;

  late AndroidNotificationChannel channel;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> initialize() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("handling message: $message");
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                channelShowBadge: true,
                importance: Importance.high,
              ),
            ),
          );
        }
      },
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');

  // final channel = const AndroidNotificationChannel(
  //   'high_importance_channel',
  //   'High Importance Notifications',
  //   description: 'This channel is used for important notifications.',
  //   importance: Importance.high,
  // );
  //
  // final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  //
  // await FirebaseMessaging.instance
  //     .setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  //
  // RemoteNotification? notification = message.notification;
  // AndroidNotification? android = message.notification?.android;
  // if (notification != null && android != null) {
  //   flutterLocalNotificationsPlugin.show(
  //     notification.hashCode,
  //     "${notification.title} from background",
  //     notification.body,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         channelDescription: channel.description,
  //         channelShowBadge: true,
  //         icon: 'launch_background',
  //       ),
  //     ),
  //   );
  // }
}

