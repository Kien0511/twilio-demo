class UpdateMessageArgument {
  String messageId;
  String messageBody;

  UpdateMessageArgument(this.messageId, this.messageBody);

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "messageBody": messageBody,
    };
  }
}