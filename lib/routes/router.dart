import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:test_twilio/model/conversation_model.dart';
import 'package:test_twilio/services/arguments/basic_chat_client_argument.dart';
import 'package:test_twilio/ui/channel/binding/channel_binding.dart';
import 'package:test_twilio/ui/channel/channel_screen.dart';
import 'package:test_twilio/ui/chat/bindings/chat_binding.dart';
import 'package:test_twilio/ui/chat/chat_screen.dart';
import 'package:test_twilio/ui/login/binding/login_binding.dart';
import 'package:test_twilio/ui/login/login_screen.dart';
import 'package:test_twilio/ui/splash/bindings/splash_binding.dart';
import 'package:test_twilio/ui/splash/splash_screen.dart';

class RouteName {
  static const String splash = "/splash";
  static const String login = "/login";
  static const String channel = "/channel";
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
      case RouteName.channel:
        return GetPageRoute(
            page: () => ChannelScreen(),
            binding: ChannelBinding(settings.arguments as BasicChatClientArgument),
            settings: settings);
      case RouteName.chat:
        return GetPageRoute(
            page: () => ChatScreen(),
            binding: ChatBinding(settings.arguments as ConversationModel),
            settings: settings);
      default:
        return GetPageRoute<Widget>(
          page: () => Scaffold(),
        );
    }
  }
}
