import 'package:test_twilio/model/member_model.dart';

class MembersModel {
  List<MemberModel?>? membersList;
  MembersModel.fromJson(Map<String, dynamic> json) {
    final list = json["members"];
    if (list is List) {
      membersList = [];
      for (final element in list) {
        if (element is Map) {
          membersList?.add(MemberModel.fromJson(Map<String, dynamic>.from(element)));
        }
      }
    }
  }
}