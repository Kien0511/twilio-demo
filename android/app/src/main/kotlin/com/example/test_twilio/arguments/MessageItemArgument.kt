package com.example.test_twilio.arguments

import android.util.Log
import com.example.test_twilio.ChatCallback
import com.twilio.conversations.Attributes
import com.twilio.conversations.Message
import com.twilio.conversations.Participant

class MessageItemArgument(val message: Message, val members: List<Participant>) {

    companion object {
        fun toMapList(list: MutableList<MessageItemArgument>, listener: ChatCallback): List<HashMap<String, Any?>> {
            val listHashMap = mutableListOf<HashMap<String, Any?>>()
            list.let {
                for (messageItem in it) {
                    listHashMap.add(messageItem.toMap(listener))
                }
            }
            return listHashMap
        }
    }
    fun toMap(listener: ChatCallback?): HashMap<String, Any?> {
        val hashMap = hashMapOf<String, Any?>()
        hashMap["message"] = messageMap(message, listener)
        hashMap["members"] = membersMap(members)
        return hashMap
    }

    private fun messageMap(message: Message, listener: ChatCallback?) : HashMap<String, Any?> {
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
            message.getMediaContentTemporaryUrl {
                Log.e(this@MessageItemArgument.javaClass.simpleName, it)
                listener?.getMediaPathComplete(MediaFilePathArgument(it, message.sid))
            }
        }
        hashMap["attributes"] = message.attributes.toString()
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