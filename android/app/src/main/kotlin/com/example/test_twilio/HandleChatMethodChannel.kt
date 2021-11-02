package com.example.test_twilio

import ConversationDataItem
import MessageDataItem
import com.example.test_twilio.common.extensions.toMap
import com.example.test_twilio.message.BasicConversationsClient
import com.twilio.conversations.ErrorInfo
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@Suppress("UNCHECKED_CAST")
class HandleChatMethodChannel: HandleMethodChatListener {
    private val chatChannel = "com.example.demo_twilio/conversationChannel"
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
                MethodChannelConversation.createConversationsClient -> {
                    BasicConversationsClient.getInstance().create(call.arguments as String)
                    BasicConversationsClient.getInstance().setMethodChatListener(this)
                }
                MethodChannelConversation.setFirebaseToken -> {
                    BasicConversationsClient.getInstance().setFirebaseToken(call.arguments as String)
                }
                MethodChannelConversation.getConversations -> {
                    BasicConversationsClient.getInstance().getConversations()
                }
                MethodChannelConversation.fetchMessages -> {
                    BasicConversationsClient.getInstance().fetchMessages(call.arguments as String, count = 10)
                }
                MethodChannelConversation.getMessages -> {
                    BasicConversationsClient.getInstance().fetchMessages(call.arguments as String, count = 50)
                }
                MethodChannelConversation.sendTextMessage -> {
                    BasicConversationsClient.getInstance().sendTextMessage(MessageDataItem.fromMap(call.arguments as HashMap<String, Any?>))
                }
                MethodChannelConversation.removeMessage -> {
                    BasicConversationsClient.getInstance().removeMessage(MessageDataItem.fromMap(call.arguments as HashMap<String, Any?>))
                }
                MethodChannelConversation.reactionMessage -> {
                    BasicConversationsClient.getInstance().reactionMessage(MessageDataItem.fromMap(call.arguments as HashMap<String, Any?>))
                }
                MethodChannelConversation.sendMediaFile -> {
                    BasicConversationsClient.getInstance().sendMediaFile(MessageDataItem.fromMap(call.arguments as HashMap<String, Any?>))
                }
            }
        }
    }

    override fun createConversationsClientSuccess() {
        flutterResult?.success(true)
    }

    override fun createConversationsClientError(errorInfo: ErrorInfo) {
        flutterResult?.success(errorInfo.toMap())
    }

    override fun insertConversation(conversationDataItem: ConversationDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.insertConversation, conversationDataItem.toMap())
    }

    override fun updateConversation(conversationDataItem: ConversationDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.updateConversation, conversationDataItem.toMap())
    }

    override fun updateParticipantCount(conversationDataItem: ConversationDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.updateParticipantCount, conversationDataItem.toMap())
    }

    override fun updateMessageCount(conversationDataItem: ConversationDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.updateMessageCount, conversationDataItem.toMap())
    }

    override fun updateUnreadMessagesCount(conversationDataItem: ConversationDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.updateUnreadMessagesCount, conversationDataItem.toMap())
    }

    override fun updateConversationLastMessage(conversationSid: String) {
        methodChannel?.invokeMethod(MethodChannelConversation.updateConversationLastMessage, conversationSid)
    }

    override fun getConversationsComplete(conversations: List<ConversationDataItem>?) {
        flutterResult?.success(conversations?.toMap())
    }

    override fun deleteGoneUserConversations(conversations: List<ConversationDataItem>?) {
        methodChannel?.invokeMethod(MethodChannelConversation.deleteGoneUserConversations, conversations?.toMap())
    }

    override fun insertListMessage(listMessageDataItem: List<MessageDataItem>) {
        flutterResult?.success(listMessageDataItem.toMap())
    }

    override fun insertMessage(message: MessageDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.insertMessage, message.toMap())
    }

    override fun updateMessageByUuid(message: MessageDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.updateMessageByUuid, message.toMap())
    }

    override fun deleteMessage(message: MessageDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.deleteMessage, message.toMap())
    }

    override fun removeMessageSuccess() {
        flutterResult?.success(true)
    }

    override fun removeMessageFailed() {
        flutterResult?.success(false)
    }

    override fun updateMessage(message: MessageDataItem) {
        methodChannel?.invokeMethod(MethodChannelConversation.updateMessage, message.toMap())
    }

    override fun reactionSuccess() {
        flutterResult?.success(true)
    }

    override fun reactionFailed() {
        flutterResult?.success(false)
    }
}

class MethodChannelConversation {
    companion object {
        const val createConversationsClient = "createConversationsClient"
        const val insertConversation = "insertConversation"
        const val updateConversation = "updateConversation"
        const val updateParticipantCount = "updateParticipantCount"
        const val updateMessageCount = "updateMessageCount"
        const val updateUnreadMessagesCount = "updateUnreadMessagesCount"
        const val updateConversationLastMessage = "updateConversationLastMessage"
        const val deleteGoneUserConversations = "deleteGoneUserConversations"

        const val setFirebaseToken = "setFirebaseToken"
        const val getConversations = "getConversations"
        const val fetchMessages = "fetchMessages"
        const val getMessages = "getMessages"
        const val sendTextMessage = "sendTextMessage"
        const val insertMessage = "insertMessage"
        const val updateMessageByUuid = "updateMessageByUuid"
        const val deleteMessage = "deleteMessage"
        const val removeMessage = "removeMessage"
        const val updateMessage = "updateMessage"
        const val reactionMessage = "reactionMessage"
        const val sendMediaFile = "sendMediaFile"
    }
}

interface HandleMethodChatListener {
    fun createConversationsClientSuccess()
    fun createConversationsClientError(errorInfo: ErrorInfo)
    fun insertConversation(conversationDataItem: ConversationDataItem)
    fun updateConversation(conversationDataItem: ConversationDataItem)
    fun updateParticipantCount(conversationDataItem: ConversationDataItem)
    fun updateMessageCount(conversationDataItem: ConversationDataItem)
    fun updateUnreadMessagesCount(conversationDataItem: ConversationDataItem)
    fun updateConversationLastMessage(conversationSid: String)
    fun getConversationsComplete(conversations: List<ConversationDataItem>?)
    fun deleteGoneUserConversations(conversations: List<ConversationDataItem>?)
    fun insertListMessage(listMessageDataItem: List<MessageDataItem>)
    fun insertMessage(message: MessageDataItem)
    fun updateMessageByUuid(message: MessageDataItem)
    fun deleteMessage(message: MessageDataItem)
    fun removeMessageSuccess()
    fun removeMessageFailed()
    fun updateMessage(message: MessageDataItem)
    fun reactionSuccess()
    fun reactionFailed()
}