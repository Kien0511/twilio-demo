import 'package:floor/floor.dart';
import 'package:test_twilio/common/extensions/string_extensions.dart';

@Entity(tableName: "conversation_table")
class ConversationDataItem {
  @primaryKey
  String? sid;
  String? friendlyName;
  String? attributes;
  String? uniqueName;
  int? dateUpdated;
  int? dateCreated;
  int? lastMessageDate;
  String? lastMessageText;
  int? lastMessageSendStatus;
  String? createdBy;
  int? participantsCount;
  int? messagesCount;
  int? unreadMessagesCount;
  int? participatingStatus;
  int? notificationLevel;

  @ignore
  ConversationDataItem.fromMap(Map<String, dynamic> data) {
    sid = data["sid"]?.toString();
    friendlyName = data["friendlyName"]?.toString();
    attributes = data["attributes"]?.toString();
    uniqueName = data["uniqueName"]?.toString();
    dateUpdated = data["dateUpdated"]?.toString().toInt();
    dateCreated = data["dateCreated"]?.toString().toInt();
    lastMessageDate = data["lastMessageDate"]?.toString().toInt();
    lastMessageText = data["lastMessageText"]?.toString();
    lastMessageSendStatus = data["lastMessageSendStatus"]?.toString().toInt();
    createdBy = data["createdBy"]?.toString();
    participantsCount = data["participantsCount"]?.toString().toInt();
    messagesCount = data["messagesCount"]?.toString().toInt();
    unreadMessagesCount = data["unreadMessagesCount"]?.toString().toInt();
    participatingStatus = data["participatingStatus"]?.toString().toInt();
    notificationLevel = data["notificationLevel"]?.toString().toInt();
  }

  @ignore
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    data["sid"] = sid;
    data["friendlyName"] = friendlyName;
    data["attributes"] = attributes;
    data["uniqueName"] = uniqueName;
    data["dateUpdated"] = dateUpdated;
    data["dateCreated"] = dateCreated;
    data["lastMessageDate"] = lastMessageDate;
    data["lastMessageText"] = lastMessageText;
    data["lastMessageSendStatus"] = lastMessageSendStatus;
    data["createdBy"] = createdBy;
    data["participantsCount"] = participantsCount;
    data["messageCount"] = messagesCount;
    data["unreadMessagesCount"] = unreadMessagesCount;
    data["participatingStatus"] = participatingStatus;
    data["notificationLevel"] = notificationLevel;
    return data;
  }
}