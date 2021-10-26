class MemberModel {
  String? sid;
  int? lastReadMessageIndex;
  String? lastReadTimestamp;
  String? identity;
  int? type;

  MemberModel.fromJson(Map<String, dynamic> json) {
    sid = json["sid"];
    lastReadMessageIndex = json["lastReadMessageIndex"];
    lastReadTimestamp = json["lastReadTimestamp"];
    identity = json["identity"];
    type = json["type"];
  }
}