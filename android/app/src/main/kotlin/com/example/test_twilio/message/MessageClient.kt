package com.example.test_twilio.message

import ChatCallbackListener
import ChatStatusListener
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
    private var canLoadMore = true

    val messageItemList = ArrayList<MessageItemArgument>()

    fun setChannel(channel: Channel?) {
        this.channel = channel
    }

    fun setBasicChatClientCallback(listener: BasicChatClientCallback) {
        this.listener = listener
    }

    fun getLastMessage(count: Int = 50) {
        channel?.messages?.getLastMessages(count, ChatCallbackListener<List<Message>> {
            canLoadMore = it.size == 50
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

    override fun onMessageUpdated(message: Message?, p1: Message.UpdateReason?) {
        Log.e(this@MessageClient.javaClass.name, "onMessageUpdated ${message.toString()}")
        message?.let { messageUpdate ->
            channel?.members?.let {
                val index = messageItemList.indexOfFirst { messageItemArgument -> messageItemArgument.message.sid == messageUpdate.sid }
                val messageItemArgument = MessageItemArgument(messageUpdate, it)
                if (index != -1) {
                    messageItemList.removeAt(index)
                    messageItemList.add(index, messageItemArgument)
                }
                listener?.updateMessageSuccess(messageItemArgument)
            }
        }
    }

    override fun onMessageDeleted(message: Message?) {
        Log.e(this@MessageClient.javaClass.name, "onMessageDeleted ${message.toString()}")
        message?.let { messageDelete ->
            channel?.members?.let {
                messageItemList.removeIf { t: MessageItemArgument -> t.message.sid == messageDelete.sid }
                listener?.removeMessageSuccess(MessageItemArgument(messageDelete, it))
            }
        }
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

    override fun onTypingStarted(p0: Channel?, member: Member?) {
        member?.let {
            listener?.onTypingStarted("${it.identity} is typing....")
        }
        Log.e(this@MessageClient.javaClass.simpleName, "onTypingStarted: ${member.toString()}")
    }

    override fun onTypingEnded(p0: Channel?, member: Member?) {
        member?.let {
            listener?.onTypingEnded("")
        }
        Log.e(this@MessageClient.javaClass.simpleName, "onTypingEnded: ${member.toString()}")
    }

    override fun onSynchronizationChanged(p0: Channel?) {
    }

    fun removeListener() {
        channel?.removeListener(this)
    }

    fun addListener() {
        channel?.addListener(this)
    }

    fun sendMessage(message: String) {
        channel?.messages?.sendMessage(Message.options().withBody(message),  ChatCallbackListener<Message>(success = {
            Log.e(this@MessageClient.javaClass.simpleName, "send message callback success: $it")
        }, fail = {
            Log.e(this@MessageClient.javaClass.simpleName, "send message callback error: $it")
        }) )
    }

    fun deleteMessage(messageId: String) {
        val messageItemArgument = messageItemList.firstOrNull {
            it.message.sid == messageId
        }
        messageItemArgument?.let {
            channel?.messages?.removeMessage(it.message, ChatStatusListener(
                    success = {
                        Log.e(this@MessageClient.javaClass.simpleName, "delete message callback success")
                    },
                    fail = { errorInfo ->
                        Log.e(this@MessageClient.javaClass.simpleName, "delete message callback failed: $errorInfo")
                    }
            ))
        }
    }

    fun updateMessage(messageId: String?, body: String?) {
        val messageItemArgument = messageItemList.firstOrNull {
            it.message.sid == messageId
        }
        messageItemArgument?.let {
            it.message.updateMessageBody(body, ChatStatusListener (
                    success = {
                        Log.e(this@MessageClient.javaClass.simpleName, "update message callback success")
                    },
                    fail = { errorInfo ->
                        Log.e(this@MessageClient.javaClass.simpleName, "update message callback failed: $errorInfo")
                    }
                    ))
        }
    }

    fun inviteByIdentity(identity: String) {
        channel?.members?.addByIdentity(identity, ChatStatusListener(
                success = {
                    Log.e(this@MessageClient.javaClass.simpleName, "inviteByIdentity callback success")
                },
                fail = { errorInfo ->
                    Log.e(this@MessageClient.javaClass.simpleName, "inviteByIdentity callback failed: $errorInfo")
                }
        ))
    }

    fun typing() {
        channel?.typing()
    }

    fun getMessageBefore(count: Int = 50) {
        if (messageItemList.isNotEmpty() && canLoadMore) {
            val messageIndex = messageItemList.first().message.messageIndex
            channel?.messages?.getMessagesBefore(messageIndex, count, ChatCallbackListener(
                    success = {
                        canLoadMore = it.size == count
                        val members = channel?.members
                        val listTemp = mutableListOf<MessageItemArgument>()
                        members?.let { membersList ->
                            if (it.isNotEmpty()) {
                                for (i in it.indices) {
                                    listTemp.add(MessageItemArgument(it[i], membersList))
                                }
                            }
                        }
                        messageItemList.addAll(0, listTemp)
                        listener?.loadMoreMessageComplete(listTemp)
                        Log.e(this@MessageClient.javaClass.simpleName, "getMessagesBefore success: $it")
                    },
                    fail = {
                        Log.e(this@MessageClient.javaClass.simpleName, "getMessagesBefore failed: $it")
                    }
            ))
        }
    }
}