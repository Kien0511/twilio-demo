package com.example.test_twilio.arguments

class CreateChannelArgument(val channelName: String, val channelType: Int) {
    companion object {
        fun fromMap(json: HashMap<String, Any>): CreateChannelArgument{
            return CreateChannelArgument(json["channelName"].toString(), json["channelType"].toString().toInt())
        }
    }
}