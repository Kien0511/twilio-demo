class SendMessageArgument {
  String? messageBody;
  String? messageId;

  SendMessageArgument(this.messageBody, this.messageId);

  Map<String, dynamic> toMap() {
    return {
      "messageBody": messageBody,
      "messageId": messageId
    };
  }
}