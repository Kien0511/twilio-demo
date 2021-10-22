package com.example.test_twilio.arguments

import com.twilio.chat.Member
import com.twilio.chat.Members
import com.twilio.chat.Message

class MessageItemArgument(val message: Message, val members: Members) {
    fun toMap(): HashMap<String, Any?> {
        val hashMap = hashMapOf<String, Any?>()
        hashMap["message"] = messageMap(message)
        hashMap["members"] = membersMap(members)
        return hashMap
    }

    private fun messageMap(message: Message) : HashMap<String, Any?> {
        val hashMap = hashMapOf<String, Any?>()
        hashMap["sid"] = message.sid
        hashMap["author"] = message.author
        hashMap["dateCreated"] = message.dateCreated
        hashMap["dateUpdated"] = message.dateUpdated
        hashMap["lastUpdatedBy"] = message.lastUpdatedBy
        hashMap["messageBody"] = message.messageBody
        hashMap["channelSid"] = message.channelSid
        hashMap["memberSid"] = message.memberSid
        hashMap["messageIndex"] = message.messageIndex
        hashMap["type"] = message.type.value
        hashMap["hasMedia"] = message.hasMedia()
        return hashMap
    }

    private fun membersMap(members: Members) : HashMap<String, Any?> {
        val hashMap = hashMapOf<String, Any?>()
        hashMap["members"] = memberMap(members.membersList)
        return hashMap
    }

    private fun memberMap(membersList: List<Member>) : List<HashMap<String, Any?>> {
        val listHashMap = mutableListOf<HashMap<String, Any?>>()
        for (member in membersList) {
            val hashMap = hashMapOf<String, Any?>()
            hashMap["sid"] = member.sid
            hashMap["lastConsumedMessageIndex"] = member.lastConsumedMessageIndex
            hashMap["lastConsumptionTimestamp"] = member.lastConsumptionTimestamp
            hashMap["identity"] = member.identity
            hashMap["type"] = member.type.value
        }
        return listHashMap
    }
}