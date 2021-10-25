class CreateChannelArgument {
  String channelName;
  int channelType;

  CreateChannelArgument(this.channelName, this.channelType);

  Map<String, dynamic> toMap() {
    return {
      "channelName": channelName,
      "channelType": channelType
    };
  }
}