package com.example.test_twilio.video

import com.example.test_twilio.video.view.VideoCallViewFactory
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class HandleVideoMethodChannel {
    private val videoCallChannel = "com.example.demo_twilio/videoCallChannel"
    private var flutterResult: MethodChannel.Result? = null
    private var methodChannel: MethodChannel? = null

    companion object {
        private var instance: HandleVideoMethodChannel? = null
        fun getInstance(): HandleVideoMethodChannel {
            if (instance == null) {
                instance = HandleVideoMethodChannel()
            }
            return instance!!
        }
    }

    fun handle(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, videoCallChannel)
        methodChannel?.setMethodCallHandler { call, result ->
            flutterResult = result
            when (call.method) {
                MethodChannelVideo.connectToRoom -> {
                    VideoCallViewFactory.getInstance().connectToRoom(call.arguments as String)
                }
                MethodChannelVideo.disconnect -> {
                    VideoCallViewFactory.getInstance().disconnect()
                }
            }
        }
    }
}

class MethodChannelVideo {
    companion object {
        const val connectToRoom = "connectToRoom"
        const val disconnect = "disconnect"
    }
}