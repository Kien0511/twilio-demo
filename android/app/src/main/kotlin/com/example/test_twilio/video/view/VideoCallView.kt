package com.example.test_twilio.video.view

import android.app.Activity
import android.content.Context
import android.content.res.Resources
import android.graphics.Color
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.twilio.audioswitch.AudioSwitch
import com.twilio.video.*
import io.flutter.plugin.platform.PlatformView
import tvi.webrtc.VideoSink

class VideoCallView(val context: Context) : PlatformView {
    private val frameLayout: FrameLayout = FrameLayout(context)
    private val thumbnailVideoView: VideoView = VideoView(context)
    private val primaryVideoView = VideoView(context)

    private val LOCAL_AUDIO_TRACK_NAME = "mic"
    private val LOCAL_VIDEO_TRACK_NAME = "camera"

    private var audioCodec: AudioCodec? = null
    private var videoCodec: VideoCodec? = null

    private var encodingParameters: EncodingParameters? = null

    private var cameraCapturerCompat: CameraCapturerCompat? = null
    private var localAudioTrack: LocalAudioTrack? = null
    private var localVideoTrack: LocalVideoTrack? = null

    private var audioSwitch: AudioSwitch? = null
    private var localVideoView: VideoSink? = null

    init {
        frameLayout.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        frameLayout.setBackgroundColor(Color.rgb(123 , 123, 221))
        initAudioSwitch(context)
        initPrimaryVideoView()
        initThumbnailView()
        createAudioAndVideoTracks(context)
        frameLayout.addView(primaryVideoView)
        frameLayout.addView(thumbnailVideoView)
    }

    private fun initAudioSwitch(context: Context) {
        audioSwitch = AudioSwitch(context)
    }

    private fun createAudioAndVideoTracks(context: Context) {
        // Share your microphone
        localAudioTrack = LocalAudioTrack.create(
            context,
            true,
            LOCAL_AUDIO_TRACK_NAME
        )

        // Share your camera
        cameraCapturerCompat = CameraCapturerCompat(context, CameraCapturerCompat.Source.FRONT_CAMERA)
        localVideoTrack = LocalVideoTrack.create(
            context,
            true,
            cameraCapturerCompat!!,
            LOCAL_VIDEO_TRACK_NAME
        )
        primaryVideoView.mirror = true
        localVideoTrack!!.addSink(primaryVideoView)
        localVideoView = primaryVideoView

        localVideoTrack!!.addSink(thumbnailVideoView)
    }

    private fun initThumbnailView() {
        thumbnailVideoView.layoutParams = ViewGroup.LayoutParams(dpToPx(96), dpToPx(146))
        thumbnailVideoView.mirror = true
        thumbnailVideoView.applyZOrder(true)
        thumbnailVideoView.setOnClickListener {
            enableCamera()
        }
    }

    private  fun initPrimaryVideoView() {
        primaryVideoView.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
    }

    fun switchCamera() {
        val cameraSource: CameraCapturerCompat.Source = cameraCapturerCompat!!.cameraSource
        cameraCapturerCompat!!.switchCamera()
        thumbnailVideoView.mirror = cameraSource == CameraCapturerCompat.Source.BACK_CAMERA
        primaryVideoView.mirror = cameraSource == CameraCapturerCompat.Source.BACK_CAMERA
    }

    fun enableCamera() {
        if (localVideoTrack != null) {
            val enable = !localVideoTrack!!.isEnabled
            localVideoTrack!!.enable(enable)
        }
    }

    override fun getView(): View {
        return frameLayout
    }

    override fun dispose() {
    }

    fun pxToDp(px: Int): Int {
        return (px / Resources.getSystem().displayMetrics.density).toInt()
    }

    fun dpToPx(dp: Int): Int {
        return (dp * Resources.getSystem().displayMetrics.density).toInt()
    }

    fun onResume() {
        if (localVideoTrack == null) {
            localVideoTrack = LocalVideoTrack.create(
                context,
                true,
                cameraCapturerCompat!!,
                LOCAL_VIDEO_TRACK_NAME
            )
            localVideoTrack!!.addSink(localVideoView!!)

            localVideoTrack!!.addSink(thumbnailVideoView)
        }
    }

    fun onPause() {
        if (localVideoTrack != null) {
            localVideoTrack!!.release()
            localVideoTrack = null
        }
    }

    fun onDestroy() {
        audioSwitch!!.stop()

        if (localAudioTrack != null) {
            localAudioTrack!!.release()
            localAudioTrack = null
        }

        if (localVideoTrack != null) {
            localVideoTrack!!.release()
            localVideoTrack = null
        }

    }
}