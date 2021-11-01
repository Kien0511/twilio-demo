package com.example.test_twilio.video.view

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class VideoCallViewFactory: PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private var videoCallView: VideoCallView? = null
    companion object {
        private var instance: VideoCallViewFactory? = null
        fun getInstance(): VideoCallViewFactory {
            if (instance == null) {
                instance = VideoCallViewFactory()
            }
            return instance!!
        }
    }
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        videoCallView = VideoCallView(context!!)
        return videoCallView!!
    }

    fun switchCamera() {
        executeFunctionAfter(
            {
                videoCallView?.switchCamera()
            }
        )
    }

    fun enableCamera() {
        executeFunctionAfter(
            {
                videoCallView?.enableCamera()
            }
        )
    }

    fun onResume() {
        executeFunctionAfter(
            {
                videoCallView?.onResume()
            }
        )
    }

    fun onPause() {
        executeFunctionAfter(
            {
                videoCallView?.onPause()
            }
        )
    }

    fun onDestroy() {
        executeFunctionAfter(
            {
                videoCallView?.onDestroy()
            }
        )
    }

    fun connectToRoom(accessToken: String) {
        executeFunctionAfter(
            {
                videoCallView?.connectToRoom(accessToken)
            }
        )
    }

    fun disconnect() {
        executeFunctionAfter(
            {
                videoCallView?.disconnect()
            }
        )
    }

    private fun executeFunctionAfter(callback: () -> Unit, delay: Long = 1000) {
//        if (videoCallView != null) {
//            callback.invoke()
//        } else {
            Handler(Looper.getMainLooper()).postDelayed({
                callback.invoke()
            }, delay)
//        }
    }
}