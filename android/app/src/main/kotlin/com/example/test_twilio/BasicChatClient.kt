package com.example.test_twilio

import ChatCallbackListener
import ChatStatusListener
import ToastStatusListener
import android.content.Context
import android.util.Log
import com.example.test_twilio.arguments.ChannelArgument
import com.example.test_twilio.arguments.CreateChannelArgument
import com.example.test_twilio.arguments.MessageItemArgument
import com.example.test_twilio.arguments.UpdateMessageArgument
import com.example.test_twilio.message.MessageClient
import com.twilio.chat.*
import java.util.*

class BasicChatClient(private val context: Context)
    : CallbackListener<ChatClient>()
    , ChatClientListener, BasicChatClientCallback
{
    private var accessToken: String? = null
    private var fcmToken: String? = null
    private val channels = HashMap<String?, ChannelModel>()
    private var listener: MainActivityCallback? = null
    private var messageClient: MessageClient? = null

    private var chatClient: ChatClient? = null

    init {
        if (BuildConfig.DEBUG) {
            ChatClient.setLogLevel(ChatClient.LogLevel.VERBOSE)
        }
    }

    fun getChannel(): HashMap<String?, Any?> {
        val hashMap = hashMapOf<String?, Any?>()
        for (entry in channels.entries) {
            hashMap[entry.key] = entry.value.toMap()
        }
        return hashMap
    }

    fun clearChannel() {
        channels.clear()
    }

    fun setMainActivityCallback(listener: MainActivityCallback) {
        this.listener = listener
    }

    fun setFCMToken(fcmToken: String) {
        this.fcmToken = fcmToken
        if (chatClient != null) {
            setupFcmToken()
        }
    }


    private fun setupFcmToken() {
        chatClient!!.registerFCMToken(ChatClient.FCMToken(fcmToken),
                ToastStatusListener(
                        "Firebase Messaging registration successful",
                        "Firebase Messaging registration not successful"))
    }

    fun unregisterFcmToken() {
        chatClient!!.unregisterFCMToken(ChatClient.FCMToken(fcmToken),
                ToastStatusListener(
                        "Firebase Messaging unRegistration successful",
                        "Firebase Messaging unRegistration not successful"))
    }

    fun createClient(accessToken: String?, firebaseToken: String?) {
        this.accessToken = accessToken
        this.fcmToken = firebaseToken
        if (chatClient != null) {
            shutdown()
        }
        val props = ChatClient.Properties.Builder()
                .setRegion("us1")
                .setDeferCertificateTrustToPlatform(false)
                .createProperties()

        ChatClient.create(context.applicationContext,
                this.accessToken!!,
                props,
                this)
    }

    fun updateAccessToken(accessToken: String?) {
        chatClient?.let {
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
        chatClient!!.removeListener(this)
        chatClient!!.shutdown()
        chatClient = null // Client no longer usable after shutdown()
    }

    // Client created, remember the reference and set up UI
    override fun onSuccess(client: ChatClient) {
        chatClient = client
        chatClient?.addListener(this)

        if (fcmToken != null) {
            setupFcmToken()
        }

        listener?.onCreateBasicChatClientComplete()
    }

    // Client not created, fail
    override fun onError(errorInfo: ErrorInfo?) {
        chatClient = null
    }

    // Token expiration events
    override fun onTokenAboutToExpire() {
        if (chatClient != null) {
          listener?.generateNewAccessToken()
        }
    }

    override fun onTokenExpired() {
        accessToken = null
        if (chatClient != null) {
            listener?.generateNewAccessToken()
        }
    }

    override fun onChannelAdded(channel: Channel?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onChannelAdded")
        channels[channel?.sid] = ChannelModel(channel!!)
        refreshChannelList()
    }
    override fun onChannelDeleted(channel: Channel?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onChannelDeleted")
        channels.remove(channel?.sid)
        refreshChannelList()
    }
    override fun onChannelInvited(channel: Channel?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onChannelInvited")
        channels[channel?.sid] = ChannelModel(channel!!)
        refreshChannelList()
    }
    override fun onChannelJoined(channel: Channel?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onChannelJoined")
        channels[channel?.sid] = ChannelModel(channel!!)
        refreshChannelList()
    }
    override fun onChannelSynchronizationChange(channel: Channel?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onChannelSynchronizationChange")
        refreshChannelList()
    }
    override fun onChannelUpdated(channel: Channel?, p1: Channel.UpdateReason?) {
        Log.e(this@BasicChatClient.javaClass.simpleName, "onChannelUpdated")
        channels[channel?.sid] = ChannelModel(channel!!)
        refreshChannelList()
    }
    override fun onClientSynchronization(p0: ChatClient.SynchronizationStatus?) {}
    override fun onConnectionStateChange(p0: ChatClient.ConnectionState?) {}
    override fun onRemovedFromChannelNotification(p0: String?) {}
    override fun onUserSubscribed(p0: User?) {}
    override fun onUserUnsubscribed(p0: User?) {}
    override fun onUserUpdated(p0: User?, p1: User.UpdateReason?) {}
    override fun onAddedToChannelNotification(p0: String?) {}
    override fun onInvitedToChannelNotification(p0: String?) {}
    override fun onNewMessageNotification(p0: String?, p1: String?, p2: Long) {}
    override fun onNotificationFailed(p0: ErrorInfo?) {}
    override fun onNotificationSubscribed() {}

    fun getPublicChannelsList() {
        chatClient?.channels?.getPublicChannelsList(object : CallbackListener<Paginator<ChannelDescriptor>>() {
            override fun onSuccess(channelDescriptorPaginator: Paginator<ChannelDescriptor>?) {
                channelDescriptorPaginator?.let {
                    getChannelsPage(it)
                }
            }
        })
    }

    fun getUserChannelsList() {
        chatClient?.channels?.getUserChannelsList(object : CallbackListener<Paginator<ChannelDescriptor>>() {
            override fun onSuccess(channelDescriptorPaginator: Paginator<ChannelDescriptor>?) {
                channelDescriptorPaginator?.let {
                    getChannelsPage(it)
                }
            }
        })
    }

    private fun getChannelsPage(paginator: Paginator<ChannelDescriptor>) {
        for (cd in paginator.items) {
            channels[cd.sid] = ChannelModel(cd)
        }
        refreshChannelList()

        if (paginator.hasNextPage()) {
            paginator.requestNextPage(object : CallbackListener<Paginator<ChannelDescriptor>>() {
                override fun onSuccess(channelDescriptorPaginator: Paginator<ChannelDescriptor>) {
                    getChannelsPage(channelDescriptorPaginator)
                }
            })
        } else {
            // Get subscribed channels last - so their status will overwrite whatever we received
            // from public list. Ugly workaround for now.
            val chans = chatClient?.channels?.subscribedChannels
            if (chans != null) {
                for (channel in chans) {
                    channels[channel.sid] = ChannelModel(channel)
                }
            }
            refreshChannelList()
        }
    }

    private fun refreshChannelList() {
        listener?.refreshChannelList()
    }

    fun getMessages(channelArgument: ChannelArgument) {
        Log.e(this.javaClass.simpleName, "getMessages: $channelArgument")
        val channelModel = channels[channelArgument.sid]
        channelModel?.getChannel(object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel?) {
                messageClient = MessageClient.getInstance()
                messageClient?.setChannel(channel)
                messageClient?.setBasicChatClientCallback(this@BasicChatClient)
                messageClient?.addListener()
                messageClient?.getLastMessage()
            }
        })
    }

    fun getMessageItemList(): List<HashMap<String, Any?>> {
        val listHashMap = mutableListOf<HashMap<String, Any?>>()

        messageClient?.messageItemList?.let {
            for (messageItem in it) {
                listHashMap.add(messageItem.toMap())
            }
        }
        return listHashMap
    }

    fun removeChannelListener() {
        messageClient?.removeListener()
    }

    override fun getMessageCompleted() {
        listener?.refreshMessagesList()
    }

    fun sendMessage(message: String) {
        messageClient?.sendMessage(message)
    }

    fun joinChannel(channelArgument: ChannelArgument) {
        val channelModel = channels[channelArgument.sid]
        channelModel?.getChannel(object : CallbackListener<Channel>() {
            override fun onSuccess(channel: Channel?) {
                channel?.join(ChatStatusListener(success = {
                    Log.e(this@BasicChatClient.javaClass.simpleName, "join success")
                    listener?.joinChannelSuccess()
                }, fail = {
                    Log.e(this@BasicChatClient.javaClass.simpleName, "join error")
                    listener?.joinChannelError()
                }))
            }
        })
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

    fun createChannel(createChannelArgument: CreateChannelArgument) {
        val channelType = if (createChannelArgument.channelType == 0) {
            Channel.ChannelType.PUBLIC
        } else {
            Channel.ChannelType.PRIVATE
        }
        chatClient?.channels?.createChannel(createChannelArgument.channelName, channelType, ChatCallbackListener(
                success = {
                    Log.e(this.javaClass.simpleName, "createChannel success: $it")
                    listener?.createChannelResult(true)
                    channels[it.sid] = ChannelModel(it)
                    refreshChannelList()
                },
                fail = { errorInfo ->
                    Log.e(this.javaClass.simpleName, "createChannel failed: $errorInfo")
                    listener?.createChannelResult(errorInfo.message)
                }
        ))
    }

    fun inviteByIdentity(identity: String) {
        messageClient?.inviteByIdentity(identity)
    }
}

interface BasicChatClientCallback {
    fun getMessageCompleted()
    fun removeMessageSuccess(messageItemArgument: MessageItemArgument)
    fun updateMessageSuccess(messageItemArgument: MessageItemArgument)
}
