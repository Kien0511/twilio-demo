import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:test_twilio/data/entity/conversation_data_item.dart';
import 'package:test_twilio/ui/chat/binding/chat_binding.dart';
import 'package:test_twilio/ui/chat/chat_screen.dart';
import 'package:test_twilio/ui/home/binding/home_binding.dart';
import 'package:test_twilio/ui/home/home_screen.dart';
import 'package:test_twilio/ui/login/binding/login_binding.dart';
import 'package:test_twilio/ui/login/login_screen.dart';
import 'package:test_twilio/ui/splash/bindings/splash_binding.dart';
import 'package:test_twilio/ui/splash/splash_screen.dart';
import 'package:test_twilio/ui/video_call/binding/video_call_binding.dart';
import 'package:test_twilio/ui/video_call/video_call_screen.dart';

class RouteName {
  static const String splash = "/splash";
  static const String login = "/login";
  static const String home = "/home";
  static const String videoCall = "/videoCall";
  static const String chat = "/chat";
}

/// AppRouter manages routes of app
class AppRouter {
  /// Generate Route that returns a Route<dynamic> and takes in RouteSettings
  static Route<Widget> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return GetPageRoute(
            page: () => SplashScreen(),
            binding: SplashBinding(),
            settings: settings);
      case RouteName.login:
        return GetPageRoute(
            page: () => LoginScreen(),
            binding: LoginBinding(),
            settings: settings);
      case RouteName.home:
        return GetPageRoute(
            page: () => HomeScreen(),
            binding: HomeBinding(),
            settings: settings);
      case RouteName.chat:
        return GetPageRoute(
            page: () => ChatScreen(),
            binding: ChatBinding(settings.arguments as ConversationDataItem),
            settings: settings);
      case RouteName.videoCall:
        return GetPageRoute(
            page: () => VideoCallScreen(),
            binding: VideoCallBinding(),
            settings: settings);
      default:
        return GetPageRoute<Widget>(
          page: () => Scaffold(),
        );
    }
  }
}
