package com.example.test_twilio.common.extensions

import ConversationDataItem
import MessageDataItem
import com.example.test_twilio.common.enums.Direction
import com.example.test_twilio.common.enums.SendStatus
import com.twilio.conversations.Conversation
import com.twilio.conversations.ErrorInfo
import com.twilio.conversations.Message

fun ErrorInfo.toMap() : HashMap<String, Any?> {
    val map = hashMapOf<String, Any?>()
    map["reason"] = reason.description
    map["status"] = status
    map["code"] = code
    map["message"] = message
    return map
}

fun Conversation.toConversationDataItem(
    sid: String? = null,
    friendlyName: String? = null,
    attributes: String? = null,
    uniqueName: String? = null,
    dateUpdated: Long? = null,
    dateCreated: Long? = null,
    lastMessageDate: Long? = null,
    lastMessageText: String? = null,
    lastMessageSendStatus: Int? = null,
    createdBy: String? = null,
    participantsCount: Long? = null,
    messagesCount: Long? = null,
    unreadMessagesCount: Long? = null,
    participatingStatus: Int? = null,
    notificationLevel: Int? = null,
): ConversationDataItem {

    return ConversationDataItem(
        sid ?: this.sid,
        friendlyName ?: this.friendlyName,
        attributes ?: this.attributes.toString(),
        uniqueName ?: this.uniqueName,
        dateUpdated ?: this.dateUpdatedAsDate?.time ?: 0,
        dateCreated ?: this.dateCreatedAsDate?.time ?: 0,
        lastMessageDate ?: 0,
        lastMessageText ?: "",
        lastMessageSendStatus ?: SendStatus.UNDEFINED.value,
        createdBy ?: this.createdBy,
        participantsCount ?: 0,
        messagesCount ?: 0,
        unreadMessagesCount ?: 0,
        participatingStatus ?: this.status.value,
        notificationLevel ?: this.notificationLevel.value
    )
}


fun Message.toMessageDataItem(currentUserIdentity: String = participant.identity, uuid: String = ""): MessageDataItem {
    return MessageDataItem(
        this.sid,
        this.conversationSid,
        this.participantSid,
        this.type.value,
        this.author,
        this.dateCreatedAsDate.time,
        this.messageBody ?: "",
        this.messageIndex,
        this.attributes.toString(),
        if (this.author == currentUserIdentity) Direction.OUTGOING.value else Direction.INCOMING.value,
        if (this.author == currentUserIdentity) SendStatus.SENT.value else SendStatus.UNDEFINED.value,
        uuid,
        if (this.type == Message.Type.MEDIA) this.mediaSid else null,
        if (this.type == Message.Type.MEDIA) this.mediaFileName else null,
        if (this.type == Message.Type.MEDIA) this.mediaType else null,
        if (this.type == Message.Type.MEDIA) this.mediaSize else null
    )
}

fun List<ConversationDataItem>.toMap(): List<HashMap<String,Any?>> {
    val list = mutableListOf<HashMap<String, Any?>>()
    this.forEach {
        list.add(it.toMap())
    }
    return list;
}

@JvmName("toMapMessageDataItem")
fun List<MessageDataItem>.toMap(): List<HashMap<String,Any?>> {
    val list = mutableListOf<HashMap<String, Any?>>()
    this.forEach {
        list.add(it.toMap())
    }
    return list;
}