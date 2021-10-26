class ConversationModel {
  String? friendlyName;
  String? sid;
  int? dateUpdatedAsDate;
  int? dateCreatedAsDate;
  int? status;
  int? lastMessageDate;
  int? notificationLevel;
  int? lastMessageIndex;
  int? type;

  ConversationModel.fromJson(Map<String, dynamic> json) {
    friendlyName = json['friendlyName'];
    sid = json['sid'];
    dateUpdatedAsDate = json['dateUpdatedAsDate'];
    dateCreatedAsDate = json['dateCreatedAsDate'];
    status = json['status'];
    lastMessageDate = json['lastMessageDate'];
    notificationLevel = json['notificationLevel'];
    lastMessageIndex = json['lastMessageIndex'];
    type = json['type'];
  }

  Map<String, dynamic> toMap() {
    return {
      "friendlyName": friendlyName,
      "sid": sid,
      "dateUpdatedAsDate": dateUpdatedAsDate,
      "dateCreatedAsDate": dateCreatedAsDate,
      "status": status,
      "lastMessageDate": lastMessageDate,
      "notificationLevel": notificationLevel,
      "lastMessageIndex": lastMessageIndex,
      "type": type,
    };
  }
}