package com.example.test_twilio.message

import ChatCallbackListener
import android.util.Log
import com.example.test_twilio.BasicChatClientCallback
import com.example.test_twilio.arguments.MessageItemArgument
import com.twilio.chat.Channel
import com.twilio.chat.ChannelListener
import com.twilio.chat.Member
import com.twilio.chat.Message
import java.util.ArrayList

class MessageClient: ChannelListener{

    companion object {
        private var instance: MessageClient? = null
        fun getInstance(): MessageClient {
            if (instance == null) {
                instance = MessageClient()
            }
            return instance!!
        }
    }

    private var channel: Channel? = null
    private var listener: BasicChatClientCallback? = null

    val messageItemList = ArrayList<MessageItemArgument>()

    fun setChannel(channel: Channel?) {
        this.channel = channel
    }

    fun setBasicChatClientCallback(listener: BasicChatClientCallback) {
        this.listener = listener
    }

    fun getLastMessage(count: Int = 50) {
        channel?.messages?.getLastMessages(count, ChatCallbackListener<List<Message>>() {
            messageItemList.clear()
            val members = channel?.members
            members?.let { membersList ->
                if (it.isNotEmpty()) {
                    for (i in it.indices) {
                        messageItemList.add(MessageItemArgument(it[i], membersList))
                    }
                }
            }
            listener?.getMessageCompleted()
        })
    }

    override fun onMessageAdded(message: Message?) {
        Log.e(this@MessageClient.javaClass.name, "onMessageAdded ${message.toString()}")
        channel?.members?.let {
            messageItemList.add(MessageItemArgument(message!!, it))
            listener?.getMessageCompleted()
        }
    }

    override fun onMessageUpdated(p0: Message?, p1: Message.UpdateReason?) {
    }

    override fun onMessageDeleted(p0: Message?) {
    }

    override fun onMemberAdded(member: Member?) {
        Log.e(this@MessageClient.javaClass.simpleName, "member added: ${member.toString()}")
    }

    override fun onMemberUpdated(member: Member?, p1: Member.UpdateReason?) {
        Log.e(this@MessageClient.javaClass.simpleName, "member updated: ${member.toString()}")
    }

    override fun onMemberDeleted(member: Member?) {
        Log.e(this@MessageClient.javaClass.simpleName, "member deleted: ${member.toString()}")
    }

    override fun onTypingStarted(p0: Channel?, p1: Member?) {
    }

    override fun onTypingEnded(p0: Channel?, p1: Member?) {
    }

    override fun onSynchronizationChanged(p0: Channel?) {
    }

    fun removeListener() {
        channel?.removeListener(this);
    }

    fun addListener() {
        channel?.addListener(this);
    }

    fun sendMessage(message: String) {
        channel?.messages?.sendMessage(Message.options().withBody(message),  ChatCallbackListener<Message>(success = {
            Log.e(this@MessageClient.javaClass.simpleName, "send message callback success: $it")
        }, fail = {
            Log.e(this@MessageClient.javaClass.simpleName, "send message callback error: $it")
        }) )
    }
}