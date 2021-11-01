import 'package:flutter/services.dart';
import 'package:test_twilio/ui/login/controller/login_controller.dart';

class BasicVideoChannel {
  static final BasicVideoChannel _basicVideoChannel = BasicVideoChannel
      ._internal();

  BasicVideoChannel._internal();

  factory BasicVideoChannel() => _basicVideoChannel;

  var _videoCallChannel = "com.example.demo_twilio/videoCallChannel";

  MethodChannel? _methodChannel;

  void initMethodChannel() {
    _methodChannel = MethodChannel(_videoCallChannel);
    _methodChannel?.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {

      }
    });
  }

  Future<void> connectToRoom() async {
    _methodChannel?.invokeMethod(MethodChannelVideoCall.connectToRoom, accessToken);
  }

  void disconnect() {
    _methodChannel?.invokeMethod(MethodChannelVideoCall.disconnect, accessToken);
  }
}

class MethodChannelVideoCall {
  static const String connectToRoom = "connectToRoom";
  static const String disconnect = "disconnect";
}