class MessageModel {
  String? sid;
  String? author;
  String? dateCreated;
  String? dateUpdated;
  String? lastUpdatedBy;
  String? messageBody;
  String? conversationSid;
  String? participantSid;
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
    conversationSid = json["conversationSid"];
    participantSid = json["participantSid"];
    messageIndex = json["messageIndex"];
    type = json["type"];
    hasMedia = json["hasMedia"];
  }
}