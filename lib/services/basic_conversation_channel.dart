import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_twilio/data/dao/conversations_dao.dart';
import 'package:test_twilio/data/dao/messages_dao.dart';
import 'package:test_twilio/data/dao/participants_dao.dart';
import 'package:test_twilio/data/database_helper.dart';
import 'package:test_twilio/data/entity/conversation_data_item.dart';
import 'package:test_twilio/data/entity/message_data_item.dart';
import 'package:test_twilio/repository/user_chat_repository.dart';

class BasicConversationsChannel {
  static final BasicConversationsChannel _basicChatChannel = BasicConversationsChannel._internal();

  BasicConversationsChannel._internal();

  factory BasicConversationsChannel() => _basicChatChannel;

  var _chatChannel = "com.example.demo_twilio/conversationChannel";

  MethodChannel? _methodChannel;
  UserChatRepository? _userChatRepository;
  Map<String,ConversationDataItem> mapConversations = {};
  List<MessageDataItem> messages = [];
  Function? _onUpdateConversation;
  Function? _onUpdateListMessage;

  void setOnUpdateConversation(Function onUpdateConversation) {
    this._onUpdateConversation = onUpdateConversation;
  }

  void removeOnUpdateConversation() {
    this._onUpdateConversation = null;
  }

  void setOnUpdateListMessage(Function onUpdateListMessage) {
    this._onUpdateListMessage = onUpdateListMessage;
  }

  void removeOnUpdateListMessage() {
    this._onUpdateListMessage = null;
  }

  void initMethodChannel(
      UserChatRepository userChatRepository) {
    this._userChatRepository = userChatRepository;
    _methodChannel = MethodChannel(_chatChannel);
    _methodChannel?.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case MethodChannelConversation.insertConversation:
          _insertConversation(ConversationDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
        case MethodChannelConversation.updateConversation:
          _updateConversation(ConversationDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
        case MethodChannelConversation.updateParticipantCount:
          _updateParticipantCount(ConversationDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
        case MethodChannelConversation.updateMessageCount:
          _updateMessageCount(ConversationDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
        case MethodChannelConversation.updateUnreadMessagesCount:
          _updateUnreadMessagesCount(ConversationDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
        case MethodChannelConversation.updateConversationLastMessage:
          _updateConversationLastMessage(call.arguments as String);
          break;
        case MethodChannelConversation.deleteGoneUserConversations:
          _deleteGoneUserConversations(call.arguments);
          break;
        case MethodChannelConversation.insertMessage:
          _insertMessage(MessageDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
        case MethodChannelConversation.updateMessageByUuid:
          _updateMessageByUuid(MessageDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
        case MethodChannelConversation.deleteMessage:
          _deleteMessage(MessageDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
        case MethodChannelConversation.updateMessage:
          _updateMessage(MessageDataItem.fromMap(Map<String, dynamic>.from(call.arguments as Map)));
          break;
      }
    });
  }

  void _insertConversation(ConversationDataItem conversationDataItem) async {
    mapConversations[conversationDataItem.sid!] = conversationDataItem;
    _onUpdateConversation?.call();
    await DatabaseHelper().conversationsDao?.insert(conversationDataItem);
  }

  void _updateConversation(ConversationDataItem conversationDataItem) async {
    mapConversations[conversationDataItem.sid!]?.participatingStatus = conversationDataItem.participatingStatus!;
    mapConversations[conversationDataItem.sid!]?.notificationLevel = conversationDataItem.notificationLevel!;
    mapConversations[conversationDataItem.sid!]?.friendlyName = conversationDataItem.friendlyName!;
    _onUpdateConversation?.call();
    await DatabaseHelper().conversationsDao?.update(
        conversationDataItem.sid!,
        conversationDataItem.participatingStatus!,
        conversationDataItem.notificationLevel!,
        conversationDataItem.friendlyName!);
  }

  void _updateParticipantCount(ConversationDataItem conversationDataItem) async {
    mapConversations[conversationDataItem.sid!]?.participantsCount = conversationDataItem.participantsCount!;
    _onUpdateConversation?.call();
    await DatabaseHelper().conversationsDao?.updateParticipantCount(
        conversationDataItem.sid!, conversationDataItem.participantsCount!);
  }

  void _updateMessageCount(ConversationDataItem conversationDataItem) async {
    mapConversations[conversationDataItem.sid!]?.messagesCount = conversationDataItem.messagesCount!;
    _onUpdateConversation?.call();
    await DatabaseHelper().conversationsDao?.updateMessagesCount(
        conversationDataItem.sid!, conversationDataItem.messagesCount!);
  }

  void _updateUnreadMessagesCount(ConversationDataItem conversationDataItem) async {
    mapConversations[conversationDataItem.sid!]?.unreadMessagesCount = conversationDataItem.unreadMessagesCount!;
    _onUpdateConversation?.call();
    await DatabaseHelper().conversationsDao?.updateUnreadMessagesCount(
        conversationDataItem.sid!, conversationDataItem.unreadMessagesCount!);
  }

  void _updateConversationLastMessage(String conversationSid) async {
    final lastMessage = await DatabaseHelper().messagesDao?.getLastMessage(conversationSid);
    if (lastMessage != null) {
      mapConversations[conversationSid]?.lastMessageText = lastMessage.body ?? "";
      mapConversations[conversationSid]?.lastMessageSendStatus = lastMessage.sendStatus;
      mapConversations[conversationSid]?.lastMessageDate = lastMessage.dateCreated;
      _onUpdateConversation?.call();
      await DatabaseHelper().conversationsDao?.updateLastMessage(
          conversationSid,
          lastMessage.body ?? "",
          lastMessage.sendStatus!,
          lastMessage.dateCreated!);
    } else {
      final result = await _methodChannel?.invokeMethod(MethodChannelConversation.fetchMessages, conversationSid);
      _insertListMessage(result);
    }
  }

  Future<dynamic> createConversationsClient(String token) async {
    try {
      final result = await _methodChannel?.invokeMethod(MethodChannelConversation.createConversationsClient, token);
      return result;
    } catch (e) {
      return e;
    }
  }

  void setFirebaseToken(String fcmToken) {
    _methodChannel?.invokeMethod(MethodChannelConversation.setFirebaseToken, fcmToken);
  }

  Future<List<ConversationDataItem>> getConversations() async {
    try {
      final result = await _methodChannel?.invokeMethod(MethodChannelConversation.getConversations);
      final List<ConversationDataItem> conversations = [];
      if (result is List) {
        if (result.isNotEmpty) {
          final data = result.map((e) => ConversationDataItem.fromMap(Map<String, dynamic>.from(e as Map)));
          conversations.addAll(data);
        }
      }
      print(result);
      return conversations;
    } catch (e) {
      return [];
    }
  }

  void _deleteGoneUserConversations(dynamic data) async {
    if (data is List) {
      if (data.isNotEmpty) {
        final List<ConversationDataItem> conversations = [];
        final listTemp = data.map((e) => ConversationDataItem.fromMap(Map<String, dynamic>.from(e as Map)));
        conversations.addAll(listTemp);
        await DatabaseHelper().conversationsDao?.deleteGoneUserConversations(conversations);
      }
    }
  }

  Future<void> _insertListMessage(dynamic data) async {
    if (data is List) {
      if (data.isNotEmpty) {
        final List<MessageDataItem> messages = [];
        final listTemp = data.map((e) => MessageDataItem.fromMap(Map<String, dynamic>.from(e as Map)));
        messages.addAll(listTemp);
        await DatabaseHelper().messagesDao?.insert(messages);
        _updateConversationLastMessage(messages.first.conversationSid!);
      }
    }
  }

  Future<List<MessageDataItem>> getMessages(String conversationSid) async {
    try {
      final result = await _methodChannel?.invokeMethod(MethodChannelConversation.getMessages, conversationSid);
      _insertListMessage(result);
      final List<MessageDataItem> messages = [];
      if (result is List) {
        if (result.isNotEmpty) {
          final data = result.map((e) => MessageDataItem.fromMap(Map<String, dynamic>.from(e as Map)));
          messages.addAll(data);
        }
      }
      print(result);
      return messages;
    } catch (e) {
      return [];
    }
  }

  Future<void> _insertMessage(MessageDataItem message) async {
    await DatabaseHelper().messagesDao?.insertOrReplace(message);
    _updateConversationLastMessage(message.conversationSid!);
    messages.insert(0, message);
    _onUpdateListMessage?.call();
  }

  Future<void> _updateMessageByUuid(MessageDataItem message) async {
    await DatabaseHelper().messagesDao?.updateByUuidOrInsert(message);
    _updateConversationLastMessage(message.conversationSid!);
    final index = messages.indexWhere((element) => element.uuid == message.uuid);
    if (index != -1) {
      messages.removeAt(index);
      messages.insert(index, message);
    } else {
      messages.insert(0, message);
    }
    _onUpdateListMessage?.call();
  }

  void sendTextMessage(MessageDataItem message) {
    _methodChannel?.invokeMethod(MethodChannelConversation.sendTextMessage, message.toMap());
  }

  Future<void> _deleteMessage(MessageDataItem message) async {
    await DatabaseHelper().messagesDao?.deleteMessage(message.sid!);
    _updateConversationLastMessage(message.conversationSid!);
    messages.removeWhere((element) => element.sid == message.sid);
    _onUpdateListMessage?.call();
  }

  Future<bool> removeMessage(MessageDataItem message) async {
    try {
      final result = await _methodChannel?.invokeMethod(MethodChannelConversation.removeMessage, message.toMap());
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateMessage(MessageDataItem message) async {
    final uuid = (await DatabaseHelper().messagesDao?.getMessageBySid(message.sid!))?.uuid ?? "";
    final newMessage = message;
    newMessage.uuid = uuid;
    await DatabaseHelper().messagesDao?.insertOrReplace(newMessage);
    _updateConversationLastMessage(newMessage.conversationSid!);
    final index = messages.indexWhere((element) {
      if (newMessage.uuid?.isNotEmpty == true) {
        return element.uuid == newMessage.uuid || element.sid == newMessage.sid;
      } else {
        return element.sid == newMessage.sid;
      }
    });
    if (index != -1) {
      messages.removeAt(index);
      messages.insert(index, message);
    } else {
      messages.insert(0, message);
    }
    _onUpdateListMessage?.call();
  }

  Future<bool> reactionMessage(MessageDataItem message) async {
    try {
      final result = await _methodChannel?.invokeMethod(MethodChannelConversation.reactionMessage, message.toMap());
      return result;
    } catch (e) {
      return false;
    }
  }

  void sendMediaFile(MessageDataItem message) async {
    _methodChannel?.invokeMethod(MethodChannelConversation.sendMediaFile, message.toMap());
  }
}

class MethodChannelConversation {
  static const String createConversationsClient = "createConversationsClient";
  static const String insertConversation = "insertConversation";
  static const String updateConversation = "updateConversation";
  static const String updateParticipantCount = "updateParticipantCount";
  static const String updateMessageCount = "updateMessageCount";
  static const String updateUnreadMessagesCount = "updateUnreadMessagesCount";
  static const String updateConversationLastMessage = "updateConversationLastMessage";
  static const String deleteGoneUserConversations = "deleteGoneUserConversations";

  static const String setFirebaseToken = "setFirebaseToken";
  static const String getConversations = "getConversations";
  static const String fetchMessages = "fetchMessages";
  static const String insertMessage = "insertMessage";
  static const String getMessages = "getMessages";
  static const String sendTextMessage = "sendTextMessage";
  static const String updateMessageByUuid = "updateMessageByUuid";
  static const String deleteMessage = "deleteMessage";
  static const String removeMessage = "removeMessage";
  static const String updateMessage = "updateMessage";
  static const String reactionMessage = "reactionMessage";
  static const String sendMediaFile = "sendMediaFile";
}
