package com.example.test_twilio.video.view

import android.content.Context
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
        videoCallView?.switchCamera()
    }

    fun enableCamera() {
        videoCallView?.enableCamera()
    }

    fun onResume() {
        videoCallView?.onResume()
    }

    fun onPause() {
        videoCallView?.onPause()
    }

    fun onDestroy() {
        videoCallView?.onDestroy()
    }
}