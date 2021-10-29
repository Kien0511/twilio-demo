package com.example.test_twilio

import com.example.test_twilio.arguments.*
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@Suppress("UNCHECKED_CAST")
class HandleChatMethodChannel: ChatCallback {
    private val chatChannel = "com.example.demo_twilio/chatChannel"
    private var flutterResult: MethodChannel.Result? = null
    private var methodChannel: MethodChannel? = null

    companion object {
        private var instance: HandleChatMethodChannel? = null

        fun getInstance(): HandleChatMethodChannel {
            if (instance == null) {
                instance = HandleChatMethodChannel()
            }
            return instance!!
        }
    }

    fun handle(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, chatChannel)
        methodChannel?.setMethodCallHandler {
                call, result ->
            flutterResult = result
            when (call.method) {
                MethodChannelChat.initBasicChatClient -> {
                    val basicChatClientArgument = BasicChatClientArgument.fromMap(call.arguments as HashMap<String, Any>)
                    TwilioApplication.instance.basicClient.setMainActivityCallback(this)
                    // Todo: change firebase token null to basicChatClientArgument.firebaseToken
                    TwilioApplication.instance.basicClient.createClient(basicChatClientArgument.accessToken, null)
                }
                MethodChannelChat.getChannels -> {
                    TwilioApplication.instance.basicClient.clearChannel()
                    TwilioApplication.instance.basicClient.getListConversation()
                }
                MethodChannelChat.getMessages -> {
                    TwilioApplication.instance.basicClient.getMessages(ConversationArgument.fromMap(call.arguments as HashMap<String, Any>))
                }
                MethodChannelChat.removeChannelListener -> {
                    TwilioApplication.instance.basicClient.removeConversationListener()
                }
                MethodChannelChat.sendMessage -> {
                    TwilioApplication.instance.basicClient.sendMessage(SendMessageArgument.fromMap(call.arguments as HashMap<String, Any?>))
                }
                MethodChannelChat.joinChannel -> {
                    TwilioApplication.instance.basicClient.joinConversation(ConversationArgument.fromMap(call.arguments as HashMap<String, Any>))
                }
                MethodChannelChat.generateNewAccessSuccess -> {
                    TwilioApplication.instance.basicClient.updateAccessToken(call.arguments as String)
                }
                MethodChannelChat.deleteMessage -> {
                    TwilioApplication.instance.basicClient.deleteMessage(call.arguments as String)
                }
                MethodChannelChat.updateMessage -> {
                    TwilioApplication.instance.basicClient.updateMessage(UpdateMessageArgument.fromMap(call.arguments as HashMap<String, Any>))
                }
                MethodChannelChat.createChannel -> {
                    TwilioApplication.instance.basicClient.createConversation(call.arguments as String)
                }
                MethodChannelChat.inviteByIdentity -> {
                    TwilioApplication.instance.basicClient.inviteByIdentity(call.arguments as String)
                }
                MethodChannelChat.typing -> {
                    TwilioApplication.instance.basicClient.typing()
                }
                MethodChannelChat.getMessageBefore -> {
                    TwilioApplication.instance.basicClient.getMessageBefore()
                }
                MethodChannelChat.sendFile -> {
                    TwilioApplication.instance.basicClient.sendFile(SendMessageArgument.fromMap(call.arguments as HashMap<String, Any?>))
                }
            }
        }
    }

    override fun onCreateBasicChatClientComplete() {
        flutterResult?.success(true)
    }

    override fun refreshChannelList() {
        methodChannel?.invokeMethod(MethodChannelChat.refreshChannelList, TwilioApplication.instance.basicClient.getConservations())
    }

    override fun refreshMessagesList() {
        methodChannel?.invokeMethod(MethodChannelChat.refreshMessagesList, TwilioApplication.instance.basicClient.getMessageItemList())
    }

    override fun joinChannelSuccess() {
        flutterResult?.success(true)
    }

    override fun joinChannelError() {
        flutterResult?.success(false)
    }

    override fun generateNewAccessToken() {
        methodChannel?.invokeMethod(MethodChannelChat.generateNewAccessToken, null)
    }

    override fun removeMessageSuccess(messageItemArgument: MessageItemArgument) {
        methodChannel?.invokeMethod(MethodChannelChat.deleteMessageSuccess, messageItemArgument.toMap(this))
    }

    override fun updateMessageSuccess(messageItemArgument: MessageItemArgument) {
        methodChannel?.invokeMethod(MethodChannelChat.updateMessageSuccess, messageItemArgument.toMap(this))
    }

    override fun createChannelResult(result: Any) {
        flutterResult?.success(result)
    }

    override fun onTypingStarted(description: String) {
        methodChannel?.invokeMethod(MethodChannelChat.onTypingStarted, description)
    }

    override fun onTypingEnded(description: String) {
        methodChannel?.invokeMethod(MethodChannelChat.onTypingEnded, description)
    }

    override fun loadMoreMessageComplete(list: MutableList<MessageItemArgument>) {
        flutterResult?.success(MessageItemArgument.toMapList(list, this))
    }

    override fun getMediaPathComplete(mediaFilePathArgument: MediaFilePathArgument) {
        methodChannel?.invokeMethod(MethodChannelChat.getMediaPathComplete, mediaFilePathArgument.toMap())
    }

    override fun addMessageSuccess(messageItemArgument: MessageItemArgument) {
        methodChannel?.invokeMethod(MethodChannelChat.addMessageSuccess, messageItemArgument.toMap(this))
    }
}

class MethodChannelChat {
    companion object {
        const val initBasicChatClient = "initBasicChatClient"
        const val refreshChannelList = "refreshChannelList"
        const val getChannels = "getChannels"
        const val getMessages = "getMessages"
        const val refreshMessagesList = "refreshMessagesList"
        const val removeChannelListener = "removeChannelListener"
        const val sendMessage = "sendMessage"
        const val joinChannel = "joinChannel"
        const val generateNewAccessToken = "generateNewAccessToken"
        const val generateNewAccessSuccess = "generateNewAccessSuccess"
        const val deleteMessage = "deleteMessage"
        const val deleteMessageSuccess = "deleteMessageSuccess"
        const val updateMessage = "updateMessage"
        const val updateMessageSuccess = "updateMessageSuccess"
        const val createChannel = "createChannel"
        const val inviteByIdentity = "inviteByIdentity"
        const val typing = "typing"
        const val onTypingStarted = "onTypingStarted"
        const val onTypingEnded = "onTypingEnded"
        const val getMessageBefore = "getMessageBefore"
        const val sendFile = "sendFile"
        const val getMediaPathComplete = "getMediaPathComplete"
        const val addMessageSuccess = "addMessageSuccess"
    }
}

interface ChatCallback {
    fun onCreateBasicChatClientComplete()
    fun refreshChannelList()
    fun refreshMessagesList()
    fun joinChannelSuccess()
    fun joinChannelError()
    fun generateNewAccessToken()
    fun removeMessageSuccess(messageItemArgument: MessageItemArgument)
    fun updateMessageSuccess(messageItemArgument: MessageItemArgument)
    fun addMessageSuccess(messageItemArgument: MessageItemArgument)
    fun createChannelResult(result: Any)
    fun onTypingStarted(description: String)
    fun onTypingEnded(description: String)
    fun loadMoreMessageComplete(list: MutableList<MessageItemArgument>)
    fun getMediaPathComplete(mediaFilePathArgument: MediaFilePathArgument)
}