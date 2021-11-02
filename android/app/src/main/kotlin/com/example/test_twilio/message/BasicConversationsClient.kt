package com.example.test_twilio.message

import ConversationsCallbackListener
import ConversationsStatusListener
import MessageDataItem
import android.util.Log
import android.webkit.MimeTypeMap
import com.example.test_twilio.HandleMethodChatListener
import com.example.test_twilio.TwilioApplication
import com.example.test_twilio.common.enums.Direction
import com.example.test_twilio.common.enums.SendStatus
import com.example.test_twilio.common.extensions.toConversationDataItem
import com.example.test_twilio.common.extensions.toMessageDataItem
import com.twilio.conversations.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.io.File
import java.io.FileInputStream
import java.io.InputStream
import java.util.*

class BasicConversationsClient: ConversationsClientListener {
    companion object {
        private var instance: BasicConversationsClient? = null
        fun getInstance() : BasicConversationsClient {
            if (instance == null) {
                instance = BasicConversationsClient()
            }
            return instance!!
        }
    }
    private var token: String? = null
    private var conversationsClient: ConversationsClient? = null
    private var listener: HandleMethodChatListener? = null
    private var conversationListener = object  : ConversationListener {
        override fun onMessageAdded(message: Message?) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onMessageAdded: ${message?.toString()}")
            message?.let {
                addMessage(it)
            }
        }

        override fun onMessageUpdated(message: Message?, reason: Message.UpdateReason?) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onMessageUpdated: ${message?.toString()}")
            message?.let {
                updateMessage(it)
            }
        }

        override fun onMessageDeleted(message: Message?) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onMessageDeleted: ${message?.toString()}")
            message?.let {
                deleteMessage(it)
            }
        }

        override fun onParticipantAdded(participant: Participant?) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onParticipantAdded: ${participant?.toString()}")
        }

        override fun onParticipantUpdated(
            participant: Participant?,
            reason: Participant.UpdateReason?
        ) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onParticipantUpdated: ${participant?.toString()}")
        }

        override fun onParticipantDeleted(participant: Participant?) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onParticipantDeleted: ${participant?.toString()}")
        }

        override fun onTypingStarted(conversation: Conversation?, participant: Participant?) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onTypingStarted: ${participant?.toString()}")
        }

        override fun onTypingEnded(conversation: Conversation?, participant: Participant?) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onTypingEnded: ${participant?.toString()}")
        }

        override fun onSynchronizationChanged(conversation: Conversation?) {
            Log.e(this@BasicConversationsClient.javaClass.simpleName, "onSynchronizationChanged: ${conversation?.toString()}")
        }

    }

    fun setMethodChatListener(listener: HandleMethodChatListener) {
        this.listener = listener
    }

    fun create(token: String?) {
        this.token = token

        val context = TwilioApplication.instance.applicationContext
        val props = ConversationsClient.Properties.newBuilder().createProperties()
        ConversationsClient.create(context, token!!, props, ConversationsCallbackListener(
            success = {
                conversationsClient = it
                conversationsClient?.addListener(this@BasicConversationsClient)
            },
            fail = {
                listener?.createConversationsClientError(it)
            }
        ))
    }

    override fun onConversationAdded(conversation: Conversation?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onConversationAdded: ${conversation?.toString()}")
        conversation?.let {
            insertOrUpdateConversation(it)
        }
    }

    override fun onConversationUpdated(
        conversation: Conversation?,
        reason: Conversation.UpdateReason?
    ) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onConversationUpdated: ${conversation?.toString()}")
        conversation?.let {
            insertOrUpdateConversation(it)
        }
    }

    override fun onConversationDeleted(conversation: Conversation?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onConversationDeleted: ${conversation?.toString()}")
        conversation?.let {
            insertOrUpdateConversation(it)
        }
    }

    override fun onConversationSynchronizationChange(conversation: Conversation?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onConversationSynchronizationChange: ${conversation?.toString()}")
        conversation?.let {
            insertOrUpdateConversation(it)
        }
    }

    override fun onError(errorInfo: ErrorInfo?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onError: ${errorInfo?.toString()}")
    }

    override fun onUserUpdated(user: User?, reason: User.UpdateReason?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onUserUpdated: ${user?.toString()}")
    }

    override fun onUserSubscribed(user: User?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onUserSubscribed: ${user?.toString()}")
    }

    override fun onUserUnsubscribed(user: User?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onUserUnsubscribed: ${user?.toString()}")
    }

    override fun onClientSynchronization(status: ConversationsClient.SynchronizationStatus?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onClientSynchronization: ${status?.toString()}")
        if (status == ConversationsClient.SynchronizationStatus.COMPLETED) {
            listener?.createConversationsClientSuccess()
        }
    }

    override fun onNewMessageNotification(
        conversationSid: String?,
        messageSid: String?,
        messageIndex: Long
    ) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onNewMessageNotification: $conversationSid")
    }

    override fun onAddedToConversationNotification(conversationSid: String?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onAddedToConversationNotification: $conversationSid")
    }

    override fun onRemovedFromConversationNotification(conversationSid: String?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onRemovedFromConversationNotification: $conversationSid")
    }

    override fun onNotificationSubscribed() {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onNotificationSubscribed")
    }

    override fun onNotificationFailed(errorInfo: ErrorInfo?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onNotificationFailed: ${errorInfo?.toString()}")
    }

    override fun onConnectionStateChange(state: ConversationsClient.ConnectionState?) {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onConnectionStateChange: ${state?.toString()}")
    }

    override fun onTokenExpired() {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onTokenExpired")
    }

    override fun onTokenAboutToExpire() {
        Log.e(this@BasicConversationsClient.javaClass.simpleName, "onTokenAboutToExpire")
    }

    private fun insertOrUpdateConversation(conversation: Conversation) {
        conversation.addListener(conversationListener)
        listener?.insertConversation(conversation.toConversationDataItem())
        listener?.updateConversation(conversation.toConversationDataItem())
        conversation.getParticipantsCount {
            listener?.updateParticipantCount(conversation.toConversationDataItem(participantsCount = it))
        }
        conversation.getMessagesCount {
            listener?.updateMessageCount(conversation.toConversationDataItem(messagesCount = it))
        }
        conversation.getUnreadMessagesCount {
            listener?.updateUnreadMessagesCount(conversation.toConversationDataItem(unreadMessagesCount = it))
        }
        listener?.updateConversationLastMessage(conversation.sid)
    }

    fun setFirebaseToken(fcmToken: String) {
        conversationsClient?.registerFCMToken(ConversationsClient.FCMToken(fcmToken), ConversationsStatusListener(
            success = {
                Log.e(this@BasicConversationsClient.javaClass.simpleName, "registerFCMToken success")
            },
            fail = {
                Log.e(this@BasicConversationsClient.javaClass.simpleName, "registerFCMToken $it")
            }
        ))
    }

    fun getConversations() {
        val myConversations = conversationsClient?.myConversations
        val conversations = myConversations?.map {
            it.toConversationDataItem()
        }

        listener?.deleteGoneUserConversations(conversations)

        myConversations?.forEach {
            insertOrUpdateConversation(it)
        }
        listener?.getConversationsComplete(conversations)
    }

    fun fetchMessages(conversationsSid: String, count: Int = 50) {
        val identity = conversationsClient?.myIdentity
        conversationsClient?.getConversation(conversationsSid, ConversationsCallbackListener(
            success = { conversation ->
                Log.e(this@BasicConversationsClient.javaClass.simpleName, "getConversation $conversation")
                conversation.getLastMessages(count, ConversationsCallbackListener(
                    success = { listMessage ->
                        Log.e(this@BasicConversationsClient.javaClass.simpleName, "getLastMessages $listMessage")
                        listener?.insertListMessage(listMessage.map {it.toMessageDataItem(identity!!)})
                    },
                    fail = { errorInfo ->
                        Log.e(this@BasicConversationsClient.javaClass.simpleName, "getLastMessages $errorInfo")
                    }
                ))
            },
            fail = { errorInfo ->
                Log.e(this@BasicConversationsClient.javaClass.simpleName, "getConversation $errorInfo")
            }
        ))
    }

    fun sendTextMessage(message: MessageDataItem) {
        conversationsClient?.getConversation(message.conversationSid, ConversationsCallbackListener(
            success = { conversation ->
                val identity = conversationsClient!!.myIdentity
                val participantSid = conversation.getParticipantByIdentity(conversationsClient!!.myIdentity).sid
                val attributes = Attributes(message.uuid!!)
                val options = Message.options().withBody(message.body).withAttributes(attributes)
                val newMessage = MessageDataItem(
                    sid = "",
                    conversationSid = conversation.sid,
                    participantSid = participantSid,
                    type = Message.Type.TEXT.value,
                    author = identity,
                    dateCreated = Date().time,
                    body = message.body,
                    index = -1,
                    attributes = attributes.toString(),
                    direction = Direction.OUTGOING.value,
                    sendStatus = SendStatus.SENDING.value,
                    uuid = message.uuid
                    )
                listener?.insertMessage(newMessage)
                conversation.sendMessage(options, ConversationsCallbackListener(
                    success = {
                        listener?.updateMessageByUuid(it.toMessageDataItem(identity, message.uuid))
                    },
                    fail = { errorInfo ->
                        Log.e(this@BasicConversationsClient.javaClass.simpleName, "sendMessage $errorInfo")
                    }
                ))
            },
            fail = { errorInfo ->
                Log.e(this@BasicConversationsClient.javaClass.simpleName, "sendTextMessage $errorInfo")
            }
        ))
    }

    fun addMessage(message: Message) {
        val identity = conversationsClient?.myIdentity
        identity?.let {
            listener?.updateMessageByUuid(message.toMessageDataItem(identity, message.attributes.string ?: ""))
        }
    }

    fun deleteMessage(message: Message) {
        val identity = conversationsClient?.myIdentity
        identity?.let {
            listener?.deleteMessage(message.toMessageDataItem(identity, message.attributes.string ?: ""))
        }
    }

    fun removeMessage(message: MessageDataItem) {
        conversationsClient?.getConversation(message.conversationSid, ConversationsCallbackListener(
            success = { conversation ->
                message.index?.let { index ->
                    conversation.getMessageByIndex(index, ConversationsCallbackListener(
                        success = {
                            conversation.removeMessage(it, ConversationsStatusListener(
                                success = {
                                    Log.e(this@BasicConversationsClient.javaClass.simpleName, "removeMessage Success")
                                    listener?.removeMessageSuccess()
                                },
                                fail = { errorInfo ->
                                    Log.e(this@BasicConversationsClient.javaClass.simpleName, "removeMessage $errorInfo")
                                    listener?.removeMessageFailed()
                                }
                            ))
                        },
                        fail = { errorInfo ->
                            Log.e(this@BasicConversationsClient.javaClass.simpleName, "removeMessage $errorInfo")
                            listener?.removeMessageFailed()
                        }
                    ))
                }
            },
            fail = { errorInfo ->
                Log.e(this@BasicConversationsClient.javaClass.simpleName, "removeMessage $errorInfo")
                listener?.removeMessageFailed()
            }
        ))
    }

    fun updateMessage(message: Message) {
        val identity = conversationsClient?.myIdentity
        identity?.let {
            listener?.updateMessage(message.toMessageDataItem(identity))
        }
    }

    fun reactionMessage(message: MessageDataItem) {
        conversationsClient?.getConversation(message.conversationSid, ConversationsCallbackListener(
            success = { conversation ->
                message.index?.let { index ->
                    conversation.getMessageByIndex(index, ConversationsCallbackListener(
                        success = {
                            it.setAttributes(Attributes(JSONObject(message.attributes!!)), ConversationsStatusListener(
                                success = {
                                    Log.e(this@BasicConversationsClient.javaClass.simpleName, "reactionMessage Success")
                                    listener?.reactionSuccess()
                                },
                                fail = { errorInfo ->
                                    Log.e(this@BasicConversationsClient.javaClass.simpleName, "reactionMessage $errorInfo")
                                    listener?.reactionFailed()
                                }
                            ))
                        },
                        fail = { errorInfo ->
                            Log.e(this@BasicConversationsClient.javaClass.simpleName, "reactionMessage $errorInfo")
                            listener?.reactionFailed()
                        }
                    ))
                }
            },
            fail = { errorInfo ->
                Log.e(this@BasicConversationsClient.javaClass.simpleName, "reactionMessage $errorInfo")
                listener?.reactionFailed()
            }
        ))
    }

    fun sendMediaFile(message: MessageDataItem) {
        CoroutineScope(Dispatchers.IO).launch {
            kotlin.runCatching {
                message.filePath?.let { filePath ->
                    val file = File(filePath)
                    val name = file.name
                    val type = getMimeType(filePath)
                    val stream = FileInputStream(file)

                    val identity = conversationsClient?.myIdentity
                    conversationsClient?.getConversation(message.conversationSid, ConversationsCallbackListener(
                        success = { conversation ->
                            val participantSid = conversation.getParticipantByIdentity(identity).sid

                        },
                        fail = {

                        }
                    ))
                }
            }
        }
    }

    private fun getMediaMessageOptions(
        uri: String,
        inputStream: InputStream,
        fileName: String?,
        mimeType: String?,
        messageUuid: String
    ): Message.Options {
        val attributes = Attributes(messageUuid)
        var options = Message.options().withMedia(inputStream, mimeType).withAttributes(attributes)
            .withMediaProgressListener(object : ProgressListener{
                override fun onStarted() {
                    TODO("Not yet implemented")
                }

                override fun onProgress(bytes: Long) {
                    TODO("Not yet implemented")
                }

                override fun onCompleted(mediaSid: String?) {
                    TODO("Not yet implemented")
                }

            })
        if (fileName != null) {
            options = options.withMediaFileName(fileName)
        }
        return options
    }


    private fun getMimeType(url: String?): String? {
        val type: String?
        val extension: String = MimeTypeMap.getFileExtensionFromUrl(url)
        type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
        return type
    }
}