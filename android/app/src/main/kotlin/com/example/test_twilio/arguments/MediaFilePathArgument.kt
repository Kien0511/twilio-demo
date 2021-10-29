package com.example.test_twilio.arguments

class MediaFilePathArgument(val url: String, val messageSid: String) {
    fun toMap(): HashMap<String, Any?> {
        val hashMap = hashMapOf<String, Any?>()
        hashMap["url"] = url
        hashMap["messageSid"] = messageSid
        return hashMap
    }
}