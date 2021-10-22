import 'package:flutter/services.dart';
import 'package:test_twilio/model/access_token_response.dart';
import 'package:test_twilio/model/channel_model.dart';
import 'package:test_twilio/network/api_result.dart';
import 'package:test_twilio/repository/user_chat_repository.dart';
import 'package:test_twilio/services/arguments/basic_chat_client_argument.dart';
import 'package:test_twilio/ui/login/controller/login_controller.dart';

class BasicChatChannel {
  static final BasicChatChannel _basicChatChannel = BasicChatChannel._internal();

  BasicChatChannel._internal();

  factory BasicChatChannel() => _basicChatChannel;

  var _chatChannel = "com.example.demo_twilio/chatChannel";

  MethodChannel? _methodChannel;
  UserChatRepository? _userChatRepository;

  Function? _refreshChannelListCallback;
  Function? _refreshMessagesListCallback;

  void setRefreshChannelListCallback(Function refreshChannelListCallback) {
    this._refreshChannelListCallback = refreshChannelListCallback;
  }

  void removeRefreshChannelListCallback() {
    _refreshChannelListCallback = null;
  }

  void setRefreshMessagesListCallback(Function refreshMessagesListCallback) {
    this._refreshMessagesListCallback = refreshMessagesListCallback;
  }

  void removeRefreshMessagesListCallback() {
    _refreshMessagesListCallback = null;
  }

  void initMethodChannel(UserChatRepository userChatRepository) {
    this._userChatRepository = userChatRepository;
    _methodChannel = MethodChannel(_chatChannel);
    _methodChannel?.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case MethodChannelChat.refreshChannelList:
          _refreshChannelListCallback?.call(call.arguments);
          break;
        case MethodChannelChat.refreshMessagesList:
          _refreshMessagesListCallback?.call(call.arguments);
          break;
        case MethodChannelChat.generateNewAccessToken:
          generateNewAccessToken();
          break;
      }
    });
  }

  Future<bool> initBasicChatClient(BasicChatClientArgument argument) async {
    try {
      final result = await _methodChannel?.invokeMethod(MethodChannelChat.initBasicChatClient, argument.toMap());
      print("initBasicChatClient: $result");
      return result;
    } catch (e) {
      return false;
    }
  }

  void getChannels() {
    _methodChannel?.invokeMethod(MethodChannelChat.getChannels);
  }

  void getMessages(ChannelModel channelModel) {
    _methodChannel?.invokeMethod(MethodChannelChat.getMessages, channelModel.toMap());
  }

  void removeChannelListener() {
    _methodChannel?.invokeMethod(MethodChannelChat.removeChannelListener);
  }

  void sendMessage(String message) {
    _methodChannel?.invokeMethod(MethodChannelChat.sendMessage, message);
  }

  Future<bool> joinChannel(ChannelModel channelModel) async {
    try {
      final result = await _methodChannel?.invokeMethod(MethodChannelChat.joinChannel, channelModel.toMap());
      print("joinChannel: $result");
      return result;
    } catch (e) {
      return false;
    }
  }

  void generateNewAccessToken() async {
    final ApiResult<AccessTokenResponse> result = await _userChatRepository!.getAccessToken(author);
    result.when(success: (AccessTokenResponse data) {
      _methodChannel?.invokeMethod(MethodChannelChat.generateNewAccessSuccess, data.token);
    }, failure: (error) {
      print("generate new token error: $error");
    });
  }
}

class MethodChannelChat {
  static const String initBasicChatClient = "initBasicChatClient";
  static const String refreshChannelList = "refreshChannelList";
  static const String getChannels = "getChannels";
  static const String getMessages = "getMessages";
  static const String refreshMessagesList = "refreshMessagesList";
  static const String removeChannelListener = "removeChannelListener";
  static const String sendMessage = "sendMessage";
  static const String joinChannel = "joinChannel";
  static const String generateNewAccessToken = "generateNewAccessToken";
  static const String generateNewAccessSuccess = "generateNewAccessSuccess";
}
