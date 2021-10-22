class AccessTokenResponse {
  String? identity;
  String? token;

  AccessTokenResponse({this.identity, this.token});

  AccessTokenResponse.fromJson(Map<String, dynamic> json) {
    identity = json['identity'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identity'] = this.identity;
    data['token'] = this.token;
    return data;
  }
}
