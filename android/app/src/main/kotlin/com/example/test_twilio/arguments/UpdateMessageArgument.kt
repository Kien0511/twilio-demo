package com.example.test_twilio.arguments

class UpdateMessageArgument(val messageId: String?, val messageBody: String?) {
    companion object {
        fun fromMap(json: HashMap<String, Any>): UpdateMessageArgument {
            return UpdateMessageArgument(json["messageId"]?.toString(), json["messageBody"]?.toString())
        }
    }
}