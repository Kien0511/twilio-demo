package com.example.test_twilio.arguments

class SendMessageArgument(val messageBody: String?, val messageId: String?) {
    companion object {
        fun fromMap(data: HashMap<String, Any?>) : SendMessageArgument {
            return SendMessageArgument(data["messageBody"]?.toString(), data["messageId"]?.toString())
        }
    }
}