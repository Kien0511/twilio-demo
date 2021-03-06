package com.example.test_twilio.message

import ChatCallbackListener
import ChatStatusListener
import android.database.Cursor
import android.net.Uri
import android.provider.OpenableColumns
import android.util.Log
import android.webkit.MimeTypeMap
import com.example.test_twilio.BasicChatClientCallback
import com.example.test_twilio.TwilioApplication
import com.example.test_twilio.arguments.MessageItemArgument
import com.example.test_twilio.arguments.SendMessageArgument
import com.twilio.conversations.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.io.File
import java.io.FileInputStream
import java.io.InputStream
import java.util.ArrayList

class MessageClient: ConversationListener{

    companion object {
        private var instance: MessageClient? = null
        fun getInstance(): MessageClient {
            if (instance == null) {
                instance = MessageClient()
            }
            return instance!!
        }
    }

    private var conversation: Conversation? = null
    private var listener: BasicChatClientCallback? = null
    private var canLoadMore = true

    val messageItemList = ArrayList<MessageItemArgument>()

    fun setConversation(conversation: Conversation?) {
        this.conversation = conversation
    }

    fun setBasicChatClientCallback(listener: BasicChatClientCallback) {
        this.listener = listener
    }

    fun getLastMessage(count: Int = 50) {
        conversation?.getLastMessages(count, ChatCallbackListener<List<Message>> {
            canLoadMore = it.size == count
            messageItemList.clear()
            val participantsList = conversation?.participantsList
            participantsList?.let { membersList ->
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
        conversation?.participantsList?.let {
            val item = MessageItemArgument(message!!, it)
            messageItemList.add(item)
            listener?.addMessageSuccess(item)
        }
    }

    override fun onMessageUpdated(message: Message?, p1: Message.UpdateReason?) {
        Log.e(this@MessageClient.javaClass.name, "onMessageUpdated ${message.toString()}")
        message?.let { messageUpdate ->
            conversation?.participantsList?.let {
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
            conversation?.participantsList?.let {
                messageItemList.removeIf { t: MessageItemArgument -> t.message.sid == messageDelete.sid }
                listener?.removeMessageSuccess(MessageItemArgument(messageDelete, it))
            }
        }
    }

    override fun onParticipantAdded(participant: Participant?) {
        Log.e(this@MessageClient.javaClass.simpleName, "onParticipantAdded: ${participant.toString()}")
    }

    override fun onParticipantUpdated(participant: Participant?, reason: Participant.UpdateReason?) {
        Log.e(this@MessageClient.javaClass.simpleName, "onParticipantUpdated: ${participant.toString()}")
    }

    override fun onParticipantDeleted(participant: Participant?) {
        Log.e(this@MessageClient.javaClass.simpleName, "onParticipantDeleted: ${participant.toString()}")
    }

    override fun onTypingStarted(p0: Conversation?, participant: Participant?) {
        participant?.let {
            listener?.onTypingStarted("${it.identity} is typing....")
        }
        Log.e(this@MessageClient.javaClass.simpleName, "onTypingStarted: ${participant.toString()}")
    }

    override fun onTypingEnded(p0: Conversation?, participant: Participant?) {
        participant?.let {
            listener?.onTypingEnded("")
        }
        Log.e(this@MessageClient.javaClass.simpleName, "onTypingEnded: ${participant.toString()}")
    }

    override fun onSynchronizationChanged(p0: Conversation?) {
    }

    fun removeListener() {
        conversation?.removeListener(this)
    }

    fun addListener() {
        conversation?.addListener(this)
    }

    fun sendMessage(message: SendMessageArgument) {
        val jsonObject = JSONObject()
        jsonObject.put("messageId", message.messageId)
        conversation?.sendMessage(Message.options().withAttributes(Attributes(jsonObject)).withBody(message.messageBody),  ChatCallbackListener<Message>(success = {
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
            conversation?.removeMessage(it.message, ChatStatusListener(
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

    fun addParticipantByIdentity(identity: String) {
        conversation?.addParticipantByIdentity(identity, null, ChatStatusListener(
                success = {
                    Log.e(this@MessageClient.javaClass.simpleName, "inviteByIdentity callback success")
                },
                fail = { errorInfo ->
                    Log.e(this@MessageClient.javaClass.simpleName, "inviteByIdentity callback failed: $errorInfo")
                }
        ))
    }

    fun typing() {
        conversation?.typing()
    }

    fun getMessageBefore(count: Int = 50) {
        if (messageItemList.isNotEmpty() && canLoadMore) {
            val messageIndex = messageItemList.first().message.messageIndex
            conversation?.getMessagesBefore(messageIndex, count, ChatCallbackListener(
                    success = {
                        canLoadMore = it.size == count
                        val participantsList = conversation?.participantsList
                        val listTemp = mutableListOf<MessageItemArgument>()
                        participantsList?.let { membersList ->
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

    fun sendFile(message: SendMessageArgument) {
        CoroutineScope(Dispatchers.IO).launch {
            kotlin.runCatching {
                val file = File(message.messageBody!!)
                val name = file.name
                val type = getMimeType(message.messageBody)
                val stream = FileInputStream(file)
                val jsonObject = JSONObject()
                jsonObject.put("messageId", message.messageId)

                val options = Message.options()
                        .withMediaFileName(name)
                        .withMedia(stream, type)
                        .withAttributes(Attributes(jsonObject))
                        .withMediaProgressListener(object : ProgressListener {
                            override fun onStarted() {
                                Log.e(this@MessageClient.javaClass.simpleName, "onStarted")
                            }

                            override fun onProgress(bytes: Long) {
                                Log.e(this@MessageClient.javaClass.simpleName, "onProgress: $bytes")
                            }

                            override fun onCompleted(mediaSid: String?) {
                                Log.e(this@MessageClient.javaClass.simpleName, "onCompleted")
                            }
                        })

                conversation?.sendMessage(options, ChatCallbackListener(
                        success = {
                            Log.e(this@MessageClient.javaClass.simpleName, "send message callback success: $it")
                        },
                        fail = {
                            Log.e(this@MessageClient.javaClass.simpleName, "send message callback error: $it")
                        }
                ))
            }

        }
    }

    private fun getMimeType(url: String?): String? {
        val type: String?
        val extension: String = MimeTypeMap.getFileExtensionFromUrl(url)
        type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
        return type
    }
}