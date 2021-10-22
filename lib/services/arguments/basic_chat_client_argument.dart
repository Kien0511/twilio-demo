class BasicChatClientArgument {
  String? accessToken;
  String? firebaseToken;

  BasicChatClientArgument(this.accessToken, this.firebaseToken);

  Map<String, dynamic> toMap() {
    return {"accessToken": accessToken, "firebaseToken": firebaseToken};
  }
}