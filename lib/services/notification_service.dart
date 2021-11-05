import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:test_twilio/main.dart';
import 'package:test_twilio/routes/router.dart';
import 'package:test_twilio/services/app_lifecycle_observer.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  NotificationService._internal();

  factory NotificationService() => _notificationService;

  late AndroidNotificationChannel channel;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> initialize() async {
    listenerEvent();


    AppLifecycleObserver().testStatus.listen((bool b) {
      print("initialize testStatus: $b");
    });

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
        makeFakeCallInComing();
        // flutterLocalNotificationsPlugin.show(
        //   message.data["twi_message_id"],
        //   notification.title,
        //   notification.body,
        //   NotificationDetails(
        //     android: AndroidNotificationDetails(
        //       channel.id,
        //       channel.name,
        //       channelDescription: channel.description,
        //       channelShowBadge: true,
        //       importance: Importance.high,
        //     ),
        //   ),
        // );
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: ${message.data}");
    });
  }
}

Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  listenerEvent();
  makeFakeCallInComing();
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

Future<void> listenerEvent() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  // We also handle the message potentially returning null.
  try {
    FlutterCallkitIncoming.onEvent.listen((event) {
      print(event);
      switch (event!.name) {
        case CallEvent.ACTION_CALL_INCOMING:
        // TODO: received an incoming call
          break;
        case CallEvent.ACTION_CALL_START:
        // TODO: started an outgoing call
        // TODO: show screen calling in Flutter
          break;
        case CallEvent.ACTION_CALL_ACCEPT:
        // TODO: accepted an incoming call
        // TODO: show screen calling in Flutter
        Future.delayed(Duration(milliseconds: 1000)).then((value) {
          AppLifecycleObserver().addInComingCallState(event);
          test22.add(true);
        });

          break;
        case CallEvent.ACTION_CALL_DECLINE:
        // TODO: declined an incoming call
          break;
        case CallEvent.ACTION_CALL_ENDED:
        // TODO: ended an incoming/outgoing call
          break;
        case CallEvent.ACTION_CALL_TIMEOUT:
        // TODO: missed an incoming call
          break;
        case CallEvent.ACTION_CALL_CALLBACK:
        // TODO: only Android - click action `Call back` from missed call notification
          break;
        case CallEvent.ACTION_CALL_TOGGLE_HOLD:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_MUTE:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_DMTF:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_GROUP:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
        // TODO: only iOS
          break;
      }
    });
  } on Exception {}
}

Future<void> makeFakeCallInComing() async {
  await Future.delayed(const Duration(seconds: 1), () async {
    _currentUuid = _uuid.v4();
    var params = <String, dynamic>{
      'id': _currentUuid,
      'nameCaller': 'Hien Nguyen',
      'appName': 'Callkit',
      'avatar': 'https://i.pravatar.cc/100',
      'handle': '0123456789',
      'type': 1,
      'duration': 30000,
      'extra': <String, dynamic>{'userId': '1a2b3c4d'},
      'android': <String, dynamic>{
        'isCustomNotification': true,
        'isShowLogo': false,
        'ringtonePath': 'ringtone_default',
        'backgroundColor': '#0955fa',
        'background': 'https://i.pravatar.cc/500',
        'actionColor': '#4CAF50'
      },
      'ios': <String, dynamic>{
        'iconName': 'AppIcon40x40',
        'handleType': '',
        'supportsVideo': true,
        'maximumCallGroups': 2,
        'maximumCallsPerCallGroup': 1,
        'audioSessionMode': 'default',
        'audioSessionActive': true,
        'audioSessionPreferredSampleRate': 44100.0,
        'audioSessionPreferredIOBufferDuration': 0.005,
        'supportsDTMF': true,
        'supportsHolding': true,
        'supportsGrouping': false,
        'supportsUngrouping': false,
        'ringtonePath': 'Ringtone.caf'
      }
    };
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  });
}

Future<void> endCurrentCall() async {
  var params = <String, dynamic>{'id': _currentUuid};
  await FlutterCallkitIncoming.endCall(params);
}

Future<void> startOutGoingCall() async {
  _currentUuid = _uuid.v4();
  var params = <String, dynamic>{
    'id': _currentUuid,
    'nameCaller': 'Hien Nguyen',
    'handle': '0123456789',
    'type': 1,
    'extra': <String, dynamic>{'userId': '1a2b3c4d'},
    'ios': <String, dynamic>{'handleType': 'number'}
  }; //number/email
  await FlutterCallkitIncoming.startCall(params);
}

var _uuid = Uuid();
var _currentUuid;
var textEvents = "";


