import 'package:test_twilio/model/members_model.dart';
import 'package:test_twilio/model/message_model.dart';

class MessageItemModel {
  MessageModel? message;
  MembersModel? members;

  MessageItemModel.fromJson(Map<String, dynamic> json) {
    message = MessageModel.fromJson(Map<String, dynamic>.from(json["message"] as Map));
    members = MembersModel.fromJson(Map<String, dynamic>.from(json["members"] as Map));
  }
}