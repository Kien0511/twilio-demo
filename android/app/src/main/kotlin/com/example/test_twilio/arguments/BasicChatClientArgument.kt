package com.example.test_twilio.arguments

class BasicChatClientArgument(var accessToken: String?, var firebaseToken: String?) {

    companion object {
        fun fromMap(data: HashMap<String, Any>): BasicChatClientArgument {
            val accessToken = data.get("accessToken")?.toString()
            val firebaseToken = data.get("firebaseToken")?.toString()
            return BasicChatClientArgument(accessToken = accessToken, firebaseToken = firebaseToken);
        }
    }
}