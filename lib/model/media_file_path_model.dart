class MediaFilePathModel {
  String? url;
  String? messageSid;

  MediaFilePathModel.fromJson(Map<String, dynamic> json) {
    url = json["url"];
    messageSid = json["messageSid"];
  }
}