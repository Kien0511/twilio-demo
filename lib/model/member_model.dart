class MemberModel {
  String? sid;
  int? lastConsumedMessageIndex;
  String? lastConsumptionTimestamp;
  String? identity;
  int? type;

  MemberModel.fromJson(Map<String, dynamic> json) {
    sid = json["sid"];
    lastConsumedMessageIndex = json["lastConsumedMessageIndex"];
    lastConsumptionTimestamp = json["lastConsumptionTimestamp"];
    identity = json["identity"];
    type = json["type"];
  }
}