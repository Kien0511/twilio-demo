class MessageModel {
  String? sid;
  String? author;
  String? dateCreated;
  String? dateUpdated;
  String? lastUpdatedBy;
  String? messageBody;
  String? channelSid;
  String? memberSid;
  int? messageIndex;
  int? type;
  bool? hasMedia;

  MessageModel.fromJson(Map<String, dynamic> json) {
    sid = json["sid"];
    author = json["author"];
    dateCreated = json["dateCreated"];
    dateUpdated = json["dateUpdated"];
    lastUpdatedBy = json["lastUpdatedBy"];
    messageBody = json["messageBody"];
    channelSid = json["channelSid"];
    memberSid = json["memberSid"];
    messageIndex = json["messageIndex"];
    type = json["type"];
    hasMedia = json["hasMedia"];
  }
}