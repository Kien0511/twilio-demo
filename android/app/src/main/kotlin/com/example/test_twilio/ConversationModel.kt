package com.example.test_twilio
import android.util.Log
import com.twilio.conversations.CallbackListener
import com.twilio.conversations.Conversation
import com.twilio.conversations.ErrorInfo
import com.twilio.conversations.StatusListener
import java.util.Date

class ConversationModel(conversation: Conversation) {
    private var conversation: Conversation? = conversation

    fun join(listener: StatusListener) {
        if (conversation != null) {
            conversation!!.join(listener)
            return
        }
        listener.onError(ErrorInfo(-10004, "No channel in model"))
    }

    fun getConversation(listener: CallbackListener<Conversation>) {
        if (conversation != null) {
            listener.onSuccess(conversation)
            return
        }
        listener.onError(ErrorInfo(-10005, "No channel in model"))
    }

    fun toMap(): HashMap<String, Any?> {
        Log.e(this@ConversationModel.javaClass.simpleName, "${conversation?.friendlyName}")
        val hashMap = hashMapOf<String, Any?>()
        hashMap["friendlyName"] = conversation?.friendlyName
        hashMap["sid"] = conversation?.sid
        hashMap["dateUpdatedAsDate"] = conversation?.dateUpdatedAsDate?.time
        hashMap["dateCreatedAsDate"] = conversation?.dateCreatedAsDate?.time
        hashMap["status"] = conversation?.status?.value
        hashMap["lastMessageDate"] = conversation?.lastMessageDate?.time
        hashMap["notificationLevel"] = conversation?.notificationLevel?.value
        hashMap["lastMessageIndex"] = conversation?.lastMessageIndex
        return hashMap
    }
}
