package com.example.test_twilio

import ChatCallbackListener
import ChatStatusListener
import ToastStatusListener
import android.content.Context
import android.util.Log
import com.example.test_twilio.arguments.ConversationArgument
import com.example.test_twilio.arguments.MessageItemArgument
import com.example.test_twilio.arguments.SendMessageArgument
import com.example.test_twilio.arguments.UpdateMessageArgument
import com.example.test_twilio.message.MessageClient
import com.twilio.conversations.*
import java.util.*

class BasicChatClient(private val context: Context)
    : CallbackListener<ConversationsClient>
    , ConversationsClientListener, BasicChatClientCallback
{
    private var accessToken: String? = null
    private var fcmToken: String? = null
    private val conversations = HashMap<String?, ConversationModel>()
    private var listener: ChatCallback? = null
    private var messageClient: MessageClient? = null

    private var conversationsClient: ConversationsClient? = null

    init {
        if (BuildConfig.DEBUG) {
            ConversationsClient.setLogLevel(ConversationsClient.LogLevel.VERBOSE)
        }
    }

    fun getConservations(): HashMap<String?, Any?> {
        val hashMap = hashMapOf<String?, Any?>()
        for (entry in conversations.entries) {
            hashMap[entry.key] = entry.value.toMap()
        }
        return hashMap
    }

    fun clearChannel() {
        conversations.clear()
    }

    fun setMainActivityCallback(listener: ChatCallback) {
        this.listener = listener
    }

    fun setFCMToken(fcmToken: String) {
        this.fcmToken = fcmToken
        if (conversationsClient != null) {
            setupFcmToken()
        }
    }


    private fun setupFcmToken() {
        conversationsClient!!.registerFCMToken(ConversationsClient.FCMToken(fcmToken),
                ToastStatusListener(
                        "Firebase Messaging registration successful",
                        "Firebase Messaging registration not successful"))
    }

    fun unregisterFcmToken() {
        conversationsClient!!.unregisterFCMToken(ConversationsClient.FCMToken(fcmToken),
                ToastStatusListener(
                        "Firebase Messaging unRegistration successful",
                        "Firebase Messaging unRegistration not successful"))
    }

    fun createClient(accessToken: String?, firebaseToken: String?) {
        this.accessToken = accessToken
        this.fcmToken = firebaseToken
        if (conversationsClient != null) {
            shutdown()
        }
        val props = ConversationsClient.Properties.newBuilder()
                .setRegion("us1")
                .setDeferCertificateTrustToPlatform(false)
                .createProperties()

        ConversationsClient.create(context.applicationContext,
                this.accessToken!!,
                props,
                this)
    }

    fun updateAccessToken(accessToken: String?) {
        conversationsClient?.let {
            this.accessToken = accessToken
            it.updateToken(accessToken, ChatStatusListener(
                    success = {
                        Log.e(this@BasicChatClient.javaClass.simpleName, "Update accessToken success")
                    },
                    fail = {
                        Log.e(this@BasicChatClient.javaClass.simpleName, "Update accessToken failed")
                    }
            ))
        }
    }

    private fun shutdown() {
        conversationsClient!!.removeListener(this)
        conversationsClient!!.shutdown()
        conversationsClient = null // Client no longer usable after shutdown()
    }

    // Client created, remember the reference and set up UI
    override fun onSuccess(client: ConversationsClient) {
        conversationsClient = client
        conversationsClient?.addListener(this)

        if (fcmToken != null) {
            setupFcmToken()
        }

//        listener?.onCreateBasicChatClientComplete()
    }

    override fun onConversationAdded(conversation: Conversation?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onConversationAdded")
        conversations[conversation?.sid] = ConversationModel(conversation!!)
        refreshChannelList()
    }

    override fun onConversationUpdated(conversation: Conversation?, reason: Conversation.UpdateReason?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onConversationUpdated")
        conversations[conversation?.sid] = ConversationModel(conversation!!)
        refreshChannelList()
    }

    override fun onConversationDeleted(conversation: Conversation?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onConversationDeleted")
        conversations.remove(conversation?.sid)
        refreshChannelList()
    }

    override fun onConversationSynchronizationChange(conversation: Conversation?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onConversationSynchronizationChange")
        refreshChannelList()
    }

    // Client not created, fail
    override fun onError(errorInfo: ErrorInfo?) {
        conversationsClient = null
    }

    // Token expiration events
    override fun onTokenAboutToExpire() {
        if (conversationsClient != null) {
          listener?.generateNewAccessToken()
        }
    }

    override fun onTokenExpired() {
        accessToken = null
        if (conversationsClient != null) {
            listener?.generateNewAccessToken()
        }
    }

    override fun onClientSynchronization(synchronizationStatus: ConversationsClient.SynchronizationStatus?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onClientSynchronization: ${synchronizationStatus?.toString()}")
        if (synchronizationStatus == ConversationsClient.SynchronizationStatus.COMPLETED) {
            listener?.onCreateBasicChatClientComplete()
        }
    }
    override fun onConnectionStateChange(connectionState: ConversationsClient.ConnectionState?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onConnectionStateChange: ${connectionState.toString()}")
    }
    override fun onUserSubscribed(p0: User?) {}
    override fun onUserUnsubscribed(p0: User?) {}
    override fun onUserUpdated(p0: User?, p1: User.UpdateReason?) {}
    override fun onNewMessageNotification(p0: String?, p1: String?, p2: Long) {}
    override fun onAddedToConversationNotification(conversationSid: String?) {}
    override fun onRemovedFromConversationNotification(conversationSid: String?) {}
    override fun onNotificationFailed(p0: ErrorInfo?) {}
    override fun onNotificationSubscribed() {}

    fun getListConversation() {
        conversationsClient?.myConversations?.forEach { conversation ->
            Log.e(this@BasicChatClient.javaClass.simpleName, "getListConversation: ${conversation.friendlyName}")
            Log.e(this@BasicChatClient.javaClass.simpleName, "getListConversation: ${conversation.sid}")
            conversations[conversation.sid] = ConversationModel(conversation)
        }
        refreshChannelList()
    }

    private fun refreshChannelList() {
        Log.e(this@BasicChatClient.javaClass.simpleName, "refreshChannelList")
        listener?.refreshChannelList()
    }

    fun getMessages(conversationArgument: ConversationArgument) {
        Log.e(this.javaClass.simpleName, "getMessages: $conversationArgument")
        val conversationModel = conversations[conversationArgument.sid]
        conversationModel?.getConversation { conversation ->
            messageClient = MessageClient.getInstance()
            messageClient?.setConversation(conversation)
            messageClient?.setBasicChatClientCallback(this@BasicChatClient)
            messageClient?.addListener()
            messageClient?.getLastMessage()
        }
    }

    fun getMessageItemList(): List<HashMap<String, Any?>> {
        val listHashMap = mutableListOf<HashMap<String, Any?>>()

        messageClient?.messageItemList?.let {
            for (messageItem in it) {
                listHashMap.add(messageItem.toMap(listener))
            }
        }
        return listHashMap
    }

    fun removeConversationListener() {
        messageClient?.removeListener()
    }

    override fun getMessageCompleted() {
        listener?.refreshMessagesList()
    }

    fun sendMessage(sendMessageArgument: SendMessageArgument) {
        messageClient?.sendMessage(sendMessageArgument)
    }

    fun joinConversation(conversationArgument: ConversationArgument) {
        val conversationModel = conversations[conversationArgument.sid]
        conversationModel?.getConversation { conversation ->
            conversation?.join(ChatStatusListener(success = {
                Log.e(this@BasicChatClient.javaClass.simpleName, "join success")
                listener?.joinChannelSuccess()
            }, fail = {
                Log.e(this@BasicChatClient.javaClass.simpleName, "join error")
                listener?.joinChannelError()
            }))
        }
    }

    fun deleteMessage(messageId: String) {
        messageClient?.deleteMessage(messageId)
    }

    override fun removeMessageSuccess(messageItemArgument: MessageItemArgument) {
        listener?.removeMessageSuccess(messageItemArgument)
    }

    fun updateMessage(messageArgument: UpdateMessageArgument) {
        messageClient?.updateMessage(messageArgument.messageId, messageArgument.messageBody)
    }

    override fun updateMessageSuccess(messageItemArgument: MessageItemArgument) {
        listener?.updateMessageSuccess(messageItemArgument)
    }

    fun createConversation(conversationName: String) {
        conversationsClient?.createConversation(conversationName, ChatCallbackListener(
                success = {
                    Log.e(this.javaClass.simpleName, "createChannel success: $it")
                    listener?.createChannelResult(true)
                    conversations[it.sid] = ConversationModel(it)
                    refreshChannelList()
                },
                fail = { errorInfo ->
                    Log.e(this.javaClass.simpleName, "createChannel failed: $errorInfo")
                    listener?.createChannelResult(errorInfo.message)
                }
        ))
    }

    fun inviteByIdentity(identity: String) {
        messageClient?.addParticipantByIdentity(identity)
    }

    fun typing() {
        messageClient?.typing()
    }

    override fun onTypingStarted(description: String) {
        listener?.onTypingStarted(description)
    }

    override fun onTypingEnded(description: String) {
        listener?.onTypingEnded(description)
    }

    override fun loadMoreMessageComplete(list: MutableList<MessageItemArgument>) {
        listener?.loadMoreMessageComplete(list)
    }

    fun getMessageBefore() {
        messageClient?.getMessageBefore()
    }

    fun sendFile(sendMessageArgument: SendMessageArgument) {
        messageClient?.sendFile(sendMessageArgument)
    }

    override fun addMessageSuccess(messageItemArgument: MessageItemArgument) {
        listener?.addMessageSuccess(messageItemArgument)
    }
}

interface BasicChatClientCallback {
    fun getMessageCompleted()
    fun addMessageSuccess(messageItemArgument: MessageItemArgument)
    fun removeMessageSuccess(messageItemArgument: MessageItemArgument)
    fun updateMessageSuccess(messageItemArgument: MessageItemArgument)
    fun onTypingStarted(description: String)
    fun onTypingEnded(description: String)
    fun loadMoreMessageComplete(list: MutableList<MessageItemArgument>)
}
