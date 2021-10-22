package com.example.test_twilio

import com.example.test_twilio.arguments.BasicChatClientArgument
import com.example.test_twilio.arguments.ChannelArgument
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@Suppress("UNCHECKED_CAST")
class MainActivity: FlutterActivity(), MainActivityCallback {
    private val chatChannel = "com.example.demo_twilio/chatChannel"
    private var flutterResult: MethodChannel.Result? = null
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, chatChannel)
        methodChannel?.setMethodCallHandler {
            call, result ->
            flutterResult = result;
            when (call.method) {
                MethodChannelChat.initBasicChatClient -> {
                    val basicChatClientArgument = BasicChatClientArgument.fromMap(call.arguments as HashMap<String, Any>)
                    TwilioApplication.instance.basicClient.setMainActivityCallback(this)
                    // Todo: change firebase token null to basicChatClientArgument.firebaseToken
                    TwilioApplication.instance.basicClient.createClient(basicChatClientArgument.accessToken, null)
                }
                MethodChannelChat.getChannels -> {
                    TwilioApplication.instance.basicClient.clearChannel()
                    TwilioApplication.instance.basicClient.getPublicChannelsList()
                    TwilioApplication.instance.basicClient.getUserChannelsList()
                }
                MethodChannelChat.getMessages -> {
                    TwilioApplication.instance.basicClient.getMessages(ChannelArgument.fromMap(call.arguments as HashMap<String, Any>))
                }
                MethodChannelChat.removeChannelListener -> {
                    TwilioApplication.instance.basicClient.removeChannelListener()
                }
                MethodChannelChat.sendMessage -> {
                    TwilioApplication.instance.basicClient.sendMessage(call.arguments as String)
                }
                MethodChannelChat.joinChannel -> {
                    TwilioApplication.instance.basicClient.joinChannel(ChannelArgument.fromMap(call.arguments as HashMap<String, Any>))
                }
                MethodChannelChat.generateNewAccessSuccess -> {
                    TwilioApplication.instance.basicClient.updateAccessToken(call.arguments as String)
                }
            }
        }
    }

    override fun onCreateBasicChatClientComplete() {
        flutterResult?.success(true);
    }

    override fun refreshChannelList() {
        methodChannel?.invokeMethod(MethodChannelChat.refreshChannelList, TwilioApplication.instance.basicClient.getChannel())
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
    }
}

interface MainActivityCallback {
   fun onCreateBasicChatClientComplete()
   fun refreshChannelList()
   fun refreshMessagesList()
   fun joinChannelSuccess()
   fun joinChannelError()
   fun generateNewAccessToken()
}