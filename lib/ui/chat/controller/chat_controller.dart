import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_twilio/model/conversation_model.dart';
import 'package:test_twilio/model/message_item_model.dart';
import 'package:test_twilio/services/basic_chat_channel.dart';
import 'package:test_twilio/widgets/custom_input_text_field.dart';
import 'package:test_twilio/widgets/message_list_action.dart';
import 'package:test_twilio/widgets/send_file_list_action.dart';

class ChatController extends GetxController {
  final ConversationModel channelModel;

  ChatController(this.channelModel);

  bool initController = false;

  RxList<MessageItemModel> listMessage = RxList([]);

  TextEditingController inputTextController = TextEditingController();

  ScrollController listMessageController = ScrollController();

  RxString typingDescription = RxString("");

  bool _inProgressGetMessage = false;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      setRefreshMessagesListCallback();
      setMessageDeleteCallback();
      setMessageUpdateCallback();
      setTypingCallback();
      typing();
      BasicChatChannel().getMessages(channelModel);
    });
  }

  void typing() {
    inputTextController.addListener(() {
      BasicChatChannel().typing();
    });
  }

  void setTypingCallback() {
    BasicChatChannel().setTypingCallback((String data) {
      typingDescription.value = data;
    });
  }

  void setRefreshMessagesListCallback() {
    BasicChatChannel().setRefreshMessagesListCallback((data) async {
      if (data is List) {
        final List<MessageItemModel> listMessage = [];
        await Future.forEach(data, (element) {
          if (element is Map) {
            listMessage.add(MessageItemModel.fromJson(Map<String, dynamic>.from(element)));
          }
        });
        this.listMessage.clear();
        this.listMessage.addAll(listMessage.reversed);
      }
      print(data);
    });
  }

  void setMessageDeleteCallback() {
    BasicChatChannel().setMessageDeleteCallback((data) {
      final messageItem = MessageItemModel.fromJson(Map<String, dynamic>.from(data as Map));
      this.listMessage.removeWhere((element) => element.message?.sid == messageItem.message!.sid);
    });
  }
  
  void setMessageUpdateCallback() {
    BasicChatChannel().setMessageUpdateCallback((data) {
      final messageItem = MessageItemModel.fromJson(Map<String, dynamic>.from(data as Map));
      final index = this.listMessage.indexWhere((element) => element.message!.sid == messageItem.message!.sid);
      if (index != -1) {
        this.listMessage.removeAt(index);
        this.listMessage.insert(index, messageItem);
      }
    });
  }

  @override
  void onClose() {
    BasicChatChannel().removeChannelListener();
    super.onClose();
  }

  void sendMessage() {
    if (inputTextController.text.trim().toString().isNotEmpty) {
      BasicChatChannel().sendMessage(inputTextController.text.trim().toString());
      inputTextController.text = "";
    }
  }

  void showMessageListAction(MessageItemModel messageItem) {
    Get.bottomSheet(MessageListAction(onUpdateMessage: () {
      Get.dialog(CustomInputTextField(message: messageItem.message!.messageBody!, onUpdate: (messageBody) {
        Get.back();
        BasicChatChannel().updateMessage(messageItem.message!.sid!, messageBody);
      },));
    }, onDeleteMessage: () {
      BasicChatChannel().deleteMessage(messageItem.message!.sid!);
    },));
  }

  void inviteByIdentity() {
    Get.dialog(CustomInputTextField(message: "user identity", onUpdate: (userIdentity) {
      Get.back();
      BasicChatChannel().inviteByIdentity(userIdentity);
    }));
  }

  Future<void> getMessageBefore() async {
    if (_inProgressGetMessage) {
      return;
    }
    print("start get message before");
    _inProgressGetMessage = true;
    final data = await BasicChatChannel().getMessageBefore();
    _inProgressGetMessage = false;
    if (data is List) {
      final List<MessageItemModel> listMessage = [];
      await Future.forEach(data, (element) {
        if (element is Map) {
          listMessage.add(MessageItemModel.fromJson(Map<String, dynamic>.from(element)));
        }
      });
      this.listMessage.addAll(listMessage.reversed);
    }
    print(data);
  }

  void checkLoadMoreMessage() {
    if (listMessageController.offset >= listMessageController.position.maxScrollExtent - 100.0) {
      getMessageBefore();
    }
  }

  void sendFile() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        _sendFileListAction();
      }
    } else {
      if (await Permission.photos.request().isGranted || await Permission.photos.request().isLimited) {
        _sendFileListAction();
      }
    }

  }

  void _sendFileListAction() {
    final ImagePicker imagePicker = ImagePicker();
    Get.bottomSheet(SendFileListAction(
      sendImageGallery: () async {
        final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          BasicChatChannel().sendFile(image.path);
        } else {
          print("image picker error");
        }
      },
      sendImageCamera: () {

      },
      sendVideoGallery: () {

      },
      sendVideoCamera: () {

      },
    ));
  }
}