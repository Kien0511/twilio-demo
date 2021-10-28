package com.example.test_twilio.arguments

import com.twilio.conversations.Message
import com.twilio.conversations.Participant

class MessageItemArgument(val message: Message, val members: List<Participant>) {

    companion object {
        fun toMapList(list: MutableList<MessageItemArgument>): List<HashMap<String, Any?>> {
            val listHashMap = mutableListOf<HashMap<String, Any?>>()
            list.let {
                for (messageItem in it) {
                    listHashMap.add(messageItem.toMap())
                }
            }
            return listHashMap
        }
    }
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
        hashMap["conversationSid"] = message.conversationSid
        hashMap["participantSid"] = message.participantSid
        hashMap["messageIndex"] = message.messageIndex
        hashMap["type"] = message.type.value
        hashMap["hasMedia"] = message.hasMedia()
        if (message.hasMedia()) {
            hashMap["mediaFileName"] = message.mediaFileName
            hashMap["mediaSid"] = message.mediaSid
            hashMap["mediaType"] = message.mediaType
            hashMap["mediaSize"] = message.mediaSize
        }
        return hashMap
    }

    private fun membersMap(members: List<Participant>) : HashMap<String, Any?> {
        val hashMap = hashMapOf<String, Any?>()
        hashMap["members"] = memberMap(members)
        return hashMap
    }

    private fun memberMap(membersList: List<Participant>) : List<HashMap<String, Any?>> {
        val listHashMap = mutableListOf<HashMap<String, Any?>>()
        for (member in membersList) {
            val hashMap = hashMapOf<String, Any?>()
            hashMap["sid"] = member.sid
            hashMap["lastReadMessageIndex"] = member.lastReadMessageIndex
            hashMap["lastReadTimestamp"] = member.lastReadTimestamp
            hashMap["identity"] = member.identity
            hashMap["type"] = member.type.value
            listHashMap.add(hashMap)
        }
        return listHashMap
    }
}