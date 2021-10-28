package com.example.test_twilio.video

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class HandleVideoMethodChannel {
    private val chatChannel = "com.example.demo_twilio/videoChannel"
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
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, chatChannel)
        methodChannel?.setMethodCallHandler { call, result ->
            flutterResult = result
            when (call.method) {
                MethodChannelVideo.initVideo -> {

                }
            }
        }
    }
}

class MethodChannelVideo {
    companion object {
        const val initVideo = "initVideo"
    }
}