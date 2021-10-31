import 'package:floor/floor.dart';
import 'package:test_twilio/common/extensions/string_extensions.dart';

@Entity(tableName: "participant_table")
class ParticipantDataItem {
  @primaryKey
  String? sid;
  String? identity;
  String? conversationSid;
  String? friendlyName;
  bool? isOnline;
  int? lastReadMessageIndex;
  String? lastReadTimestamp;
  bool? typing = false;

  @ignore
  ParticipantDataItem.fromMap(Map<String, dynamic> data) {
    sid = data["sid"]?.toString();
    identity = data["identity"]?.toString();
    conversationSid = data["conversationSid"]?.toString();
    friendlyName = data["friendlyName"]?.toString();
    isOnline = data["isOnline"]?.toString().toBool();
    lastReadMessageIndex = data["lastReadMessageIndex"]?.toString().toInt();
    lastReadTimestamp = data["lastReadTimestamp"]?.toString();
    typing = data["typing"]?.toString().toBool();
  }

  @ignore
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    data["sid"] = sid;
    data["identity"] = identity;
    data["conversationSid"] = conversationSid;
    data["friendlyName"] = friendlyName;
    data["isOnline"] = isOnline;
    data["lastReadMessageIndex"] = lastReadMessageIndex;
    data["lastReadTimestamp"] = lastReadTimestamp;
    data["typing"] = typing;
    return data;
  }
}