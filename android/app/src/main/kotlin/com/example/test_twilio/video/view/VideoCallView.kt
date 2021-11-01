package com.example.test_twilio.video.view

import android.content.Context
import android.content.res.Resources
import android.graphics.Color
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.annotation.NonNull
import com.twilio.audioswitch.AudioSwitch
import com.twilio.video.*
import io.flutter.plugin.platform.PlatformView
import tvi.webrtc.VideoSink

class VideoCallView(private val context: Context) : PlatformView {
    private val frameLayout: FrameLayout = FrameLayout(context)
    private val thumbnailVideoView: VideoView = VideoView(context)
    private val primaryVideoView = VideoView(context)

    private val localAudioTrackName = "mic"
    private val localVideoTrackName = "camera"

    private var audioCodec: AudioCodec? = null
    private var videoCodec: VideoCodec? = null

    private var encodingParameters: EncodingParameters? = null

    private var cameraCapturerCompat: CameraCapturerCompat? = null
    private var localAudioTrack: LocalAudioTrack? = null
    private var localVideoTrack: LocalVideoTrack? = null

    private var audioSwitch: AudioSwitch? = null
    private var localVideoView: VideoSink? = null

    private var room: Room? = null
    private var localParticipant: LocalParticipant? = null
    private var remoteParticipantIdentity: String? = null
    private var disconnectedFromOnDestroy = false

    init {
        initialize()
    }

    private fun initialize() {
        frameLayout.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        frameLayout.setBackgroundColor(Color.rgb(123 , 123, 221))
        initAudioSwitch(context)
        initPrimaryVideoView()
        initThumbnailView()
        createAudioAndVideoTracks(context)
        frameLayout.addView(primaryVideoView)
        frameLayout.addView(thumbnailVideoView)
        disconnectedFromOnDestroy = false
    }

    private fun initAudioSwitch(context: Context) {
        audioSwitch = AudioSwitch(context)
//        audioSwitch?.start(object : AudioDeviceChangeListener{
//            override fun invoke(
//                audioDevices: List<AudioDevice>,
//                selectedAudioDevice: AudioDevice?
//            ) {
//                Log.e(this@VideoCallView.javaClass.simpleName, "audioSwitchStart: $audioDevices")
//            }
//        })
    }

    private fun createAudioAndVideoTracks(context: Context) {
        // Share your microphone
        localAudioTrack = LocalAudioTrack.create(
            context,
            true,
            localAudioTrackName
        )

        // Share your camera
        cameraCapturerCompat = CameraCapturerCompat(context, CameraCapturerCompat.Source.FRONT_CAMERA)
        localVideoTrack = LocalVideoTrack.create(
            context,
            true,
            cameraCapturerCompat!!,
            localVideoTrackName
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
        thumbnailVideoView.visibility = View.GONE
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

    private fun dpToPx(dp: Int): Int {
        return (dp * Resources.getSystem().displayMetrics.density).toInt()
    }

    fun onResume() {

        audioCodec = OpusCodec()
        videoCodec = Vp8Codec()

        if (localVideoTrack == null) {
            localVideoTrack = LocalVideoTrack.create(
                context,
                true,
                cameraCapturerCompat!!,
                localVideoTrackName
            )
            localVideoTrack!!.addSink(localVideoView!!)

            localParticipant?.publishTrack(localVideoTrack!!)
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


        if (room != null && room!!.state != Room.State.DISCONNECTED) {
            room!!.disconnect()
            disconnectedFromOnDestroy = true
        }

        if (localAudioTrack != null) {
            localAudioTrack!!.release()
            localAudioTrack = null
        }

        if (localVideoTrack != null) {
            localVideoTrack!!.release()
            localVideoTrack = null
        }

        localVideoView = null
        frameLayout.removeAllViews()
    }

    fun connectToRoom(accessToken: String) {
        audioCodec = OpusCodec()
        videoCodec = Vp8Codec()
//        audioSwitch?.activate()
        val connectOptionsBuilder = ConnectOptions.Builder(accessToken).roomName("testRoom")

        if (localAudioTrack != null) {
            connectOptionsBuilder.audioTracks(listOf(localAudioTrack))
        }


        if (localVideoTrack != null) {
            connectOptionsBuilder.videoTracks(listOf(localVideoTrack))
        }


        connectOptionsBuilder.preferAudioCodecs(listOf(audioCodec))
        connectOptionsBuilder.preferVideoCodecs(listOf(videoCodec))


//        connectOptionsBuilder.encodingParameters(encodingParameters!!)

        room = Video.connect(context, connectOptionsBuilder.build(), roomListener())
    }

    private fun roomListener(): Room.Listener {
        return object : Room.Listener {
            override fun onConnected(room: Room) {
                Log.e(this@VideoCallView.javaClass.simpleName, "onConnected: $room")
                localParticipant = room.localParticipant

                for (remoteParticipant in room.remoteParticipants) {
                    addRemoteParticipant(remoteParticipant)
                    break
                }
            }

            override fun onReconnecting(
                @NonNull room: Room, @NonNull twilioException: TwilioException
            ) {
                Log.e(this@VideoCallView.javaClass.simpleName, "onReconnecting: $room")
            }

            override fun onReconnected(@NonNull room: Room) {
                Log.e(this@VideoCallView.javaClass.simpleName, "onReconnected: $room")
            }

            override fun onConnectFailure(room: Room, e: TwilioException) {
                audioSwitch?.deactivate()
                Log.e(this@VideoCallView.javaClass.simpleName, "onConnectFailure: $room")
            }

            override fun onDisconnected(room: Room, e: TwilioException?) {
                Log.e(this@VideoCallView.javaClass.simpleName, "onDisconnected: $room")
                localParticipant = null
                this@VideoCallView.room = null
                // Only reinitialize the UI if disconnect was not called from onDestroy()
                // Only reinitialize the UI if disconnect was not called from onDestroy()
                if (!disconnectedFromOnDestroy) {
                    audioSwitch!!.deactivate()
                    moveLocalVideoToPrimaryView()
                }
            }

            override fun onParticipantConnected(room: Room, remoteParticipant: RemoteParticipant) {
                Log.e(this@VideoCallView.javaClass.simpleName, "onParticipantConnected: $room")
                addRemoteParticipant(remoteParticipant)
            }

            override fun onParticipantDisconnected(
                room: Room,
                remoteParticipant: RemoteParticipant
            ) {
                Log.e(this@VideoCallView.javaClass.simpleName, "onParticipantDisconnected: $room")
                removeRemoteParticipant(remoteParticipant)
            }

            override fun onRecordingStarted(room: Room) {
                Log.e(this@VideoCallView.javaClass.simpleName, "onRecordingStarted: $room")
            }

            override fun onRecordingStopped(room: Room) {
                Log.e(this@VideoCallView.javaClass.simpleName, "onRecordingStopped: $room")
            }
        }
    }

    fun disconnect() {
        onDestroy()
    }

    private fun addRemoteParticipant(remoteParticipant: RemoteParticipant) {
        remoteParticipantIdentity = remoteParticipant.identity

        if (remoteParticipant.remoteVideoTracks.size > 0) {
            val remoteVideoTrackPublication = remoteParticipant.remoteVideoTracks[0]

            if (remoteVideoTrackPublication.isTrackSubscribed) {
                remoteVideoTrackPublication.remoteVideoTrack?.let {
                    addRemoteParticipantVideo(it)
                }
            }
        }

        remoteParticipant.setListener(remoteParticipantListener())
    }

    private fun addRemoteParticipantVideo(videoTrack: VideoTrack) {
        moveLocalVideoToThumbnailView()
        primaryVideoView.mirror = false
        videoTrack.addSink(primaryVideoView)
    }

    private fun moveLocalVideoToThumbnailView() {
        if (thumbnailVideoView.visibility == View.GONE) {
            thumbnailVideoView.visibility = View.VISIBLE
            localVideoTrack!!.removeSink(primaryVideoView)
            localVideoTrack!!.addSink(thumbnailVideoView)
            localVideoView = thumbnailVideoView
            thumbnailVideoView.mirror = (
                    cameraCapturerCompat?.cameraSource == CameraCapturerCompat.Source.FRONT_CAMERA)
        }
    }

    private fun remoteParticipantListener(): RemoteParticipant.Listener {
        return object : RemoteParticipant.Listener {
            override fun onAudioTrackPublished(
                remoteParticipant: RemoteParticipant,
                remoteAudioTrackPublication: RemoteAudioTrackPublication
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        "onAudioTrackPublished: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteAudioTrackPublication: sid=%s, enabled=%b, "
                                + "subscribed=%b, name=%s]",
                        remoteParticipant.identity,
                        remoteAudioTrackPublication.trackSid,
                        remoteAudioTrackPublication.isTrackEnabled,
                        remoteAudioTrackPublication.isTrackSubscribed,
                        remoteAudioTrackPublication.trackName
                    )
                )
            }

            override fun onAudioTrackUnpublished(
                remoteParticipant: RemoteParticipant,
                remoteAudioTrackPublication: RemoteAudioTrackPublication
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onAudioTrackUnpublished: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteAudioTrackPublication: sid=%s, enabled=%b, "
                                + "subscribed=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteAudioTrackPublication.trackSid,
                        remoteAudioTrackPublication.isTrackEnabled,
                        remoteAudioTrackPublication.isTrackSubscribed,
                        remoteAudioTrackPublication.trackName
                    )
                )
            }

            override fun onDataTrackPublished(
                remoteParticipant: RemoteParticipant,
                remoteDataTrackPublication: RemoteDataTrackPublication
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onDataTrackPublished: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteDataTrackPublication: sid=%s, enabled=%b, "
                                + "subscribed=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteDataTrackPublication.trackSid,
                        remoteDataTrackPublication.isTrackEnabled,
                        remoteDataTrackPublication.isTrackSubscribed,
                        remoteDataTrackPublication.trackName
                    )
                )
            }

            override fun onDataTrackUnpublished(
                remoteParticipant: RemoteParticipant,
                remoteDataTrackPublication: RemoteDataTrackPublication
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onDataTrackUnpublished: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteDataTrackPublication: sid=%s, enabled=%b, "
                                + "subscribed=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteDataTrackPublication.trackSid,
                        remoteDataTrackPublication.isTrackEnabled,
                        remoteDataTrackPublication.isTrackSubscribed,
                        remoteDataTrackPublication.trackName
                    )
                )
            }

            override fun onVideoTrackPublished(
                remoteParticipant: RemoteParticipant,
                remoteVideoTrackPublication: RemoteVideoTrackPublication
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onVideoTrackPublished: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteVideoTrackPublication: sid=%s, enabled=%b, "
                                + "subscribed=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteVideoTrackPublication.trackSid,
                        remoteVideoTrackPublication.isTrackEnabled,
                        remoteVideoTrackPublication.isTrackSubscribed,
                        remoteVideoTrackPublication.trackName
                    )
                )
            }

            override fun onVideoTrackUnpublished(
                remoteParticipant: RemoteParticipant,
                remoteVideoTrackPublication: RemoteVideoTrackPublication
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onVideoTrackUnpublished: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteVideoTrackPublication: sid=%s, enabled=%b, "
                                + "subscribed=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteVideoTrackPublication.trackSid,
                        remoteVideoTrackPublication.isTrackEnabled,
                        remoteVideoTrackPublication.isTrackSubscribed,
                        remoteVideoTrackPublication.trackName
                    )
                )
            }

            override fun onAudioTrackSubscribed(
                remoteParticipant: RemoteParticipant,
                remoteAudioTrackPublication: RemoteAudioTrackPublication,
                remoteAudioTrack: RemoteAudioTrack
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onAudioTrackSubscribed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteAudioTrack: enabled=%b, playbackEnabled=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteAudioTrack.isEnabled,
                        remoteAudioTrack.isPlaybackEnabled,
                        remoteAudioTrack.name
                    )
                )
            }

            override fun onAudioTrackUnsubscribed(
                remoteParticipant: RemoteParticipant,
                remoteAudioTrackPublication: RemoteAudioTrackPublication,
                remoteAudioTrack: RemoteAudioTrack
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onAudioTrackUnsubscribed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteAudioTrack: enabled=%b, playbackEnabled=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteAudioTrack.isEnabled,
                        remoteAudioTrack.isPlaybackEnabled,
                        remoteAudioTrack.name
                    )
                )
            }

            override fun onAudioTrackSubscriptionFailed(
                remoteParticipant: RemoteParticipant,
                remoteAudioTrackPublication: RemoteAudioTrackPublication,
                twilioException: TwilioException
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onAudioTrackSubscriptionFailed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteAudioTrackPublication: sid=%b, name=%s]"
                                + "[TwilioException: code=%d, message=%s]"),
                        remoteParticipant.identity,
                        remoteAudioTrackPublication.trackSid,
                        remoteAudioTrackPublication.trackName,
                        twilioException.code,
                        twilioException.message
                    )
                )
            }

            override fun onDataTrackSubscribed(
                remoteParticipant: RemoteParticipant,
                remoteDataTrackPublication: RemoteDataTrackPublication,
                remoteDataTrack: RemoteDataTrack
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onDataTrackSubscribed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteDataTrack: enabled=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteDataTrack.isEnabled,
                        remoteDataTrack.name
                    )
                )
            }

            override fun onDataTrackUnsubscribed(
                remoteParticipant: RemoteParticipant,
                remoteDataTrackPublication: RemoteDataTrackPublication,
                remoteDataTrack: RemoteDataTrack
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onDataTrackUnsubscribed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteDataTrack: enabled=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteDataTrack.isEnabled,
                        remoteDataTrack.name
                    )
                )
            }

            override fun onDataTrackSubscriptionFailed(
                remoteParticipant: RemoteParticipant,
                remoteDataTrackPublication: RemoteDataTrackPublication,
                twilioException: TwilioException
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onDataTrackSubscriptionFailed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteDataTrackPublication: sid=%b, name=%s]"
                                + "[TwilioException: code=%d, message=%s]"),
                        remoteParticipant.identity,
                        remoteDataTrackPublication.trackSid,
                        remoteDataTrackPublication.trackName,
                        twilioException.code,
                        twilioException.message
                    )
                )
            }

            override fun onVideoTrackSubscribed(
                remoteParticipant: RemoteParticipant,
                remoteVideoTrackPublication: RemoteVideoTrackPublication,
                remoteVideoTrack: RemoteVideoTrack
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onVideoTrackSubscribed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteVideoTrack: enabled=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteVideoTrack.isEnabled,
                        remoteVideoTrack.name
                    )
                )
                addRemoteParticipantVideo(remoteVideoTrack)
            }

            override fun onVideoTrackUnsubscribed(
                remoteParticipant: RemoteParticipant,
                remoteVideoTrackPublication: RemoteVideoTrackPublication,
                remoteVideoTrack: RemoteVideoTrack
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onVideoTrackUnsubscribed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteVideoTrack: enabled=%b, name=%s]"),
                        remoteParticipant.identity,
                        remoteVideoTrack.isEnabled,
                        remoteVideoTrack.name
                    )
                )
                removeParticipantVideo(remoteVideoTrack)
            }

            override fun onVideoTrackSubscriptionFailed(
                remoteParticipant: RemoteParticipant,
                remoteVideoTrackPublication: RemoteVideoTrackPublication,
                twilioException: TwilioException
            ) {
                Log.e(
                    this@VideoCallView.javaClass.simpleName, String.format(
                        ("onVideoTrackSubscriptionFailed: "
                                + "[RemoteParticipant: identity=%s], "
                                + "[RemoteVideoTrackPublication: sid=%b, name=%s]"
                                + "[TwilioException: code=%d, message=%s]"),
                        remoteParticipant.identity,
                        remoteVideoTrackPublication.trackSid,
                        remoteVideoTrackPublication.trackName,
                        twilioException.code,
                        twilioException.message
                    )
                )
            }

            override fun onAudioTrackEnabled(
                remoteParticipant: RemoteParticipant,
                remoteAudioTrackPublication: RemoteAudioTrackPublication
            ) {
            }

            override fun onAudioTrackDisabled(
                remoteParticipant: RemoteParticipant,
                remoteAudioTrackPublication: RemoteAudioTrackPublication
            ) {
            }

            override fun onVideoTrackEnabled(
                remoteParticipant: RemoteParticipant,
                remoteVideoTrackPublication: RemoteVideoTrackPublication
            ) {
            }

            override fun onVideoTrackDisabled(
                remoteParticipant: RemoteParticipant,
                remoteVideoTrackPublication: RemoteVideoTrackPublication
            ) {
            }
        }
    }


    private fun removeParticipantVideo(videoTrack: VideoTrack) {
        videoTrack.removeSink(primaryVideoView)
    }

    private fun removeRemoteParticipant(remoteParticipant: RemoteParticipant) {
        if (remoteParticipant.identity != remoteParticipantIdentity) {
            return
        }

        if (remoteParticipant.remoteVideoTracks.isNotEmpty()) {
            val remoteVideoTrackPublication = remoteParticipant.remoteVideoTracks[0]

            if (remoteVideoTrackPublication.isTrackSubscribed) {
                removeParticipantVideo(remoteVideoTrackPublication.remoteVideoTrack!!)
            }
        }
        moveLocalVideoToPrimaryView()
    }

    private fun moveLocalVideoToPrimaryView() {
        if (thumbnailVideoView.visibility == View.VISIBLE) {
            thumbnailVideoView.visibility = View.GONE
            if (localVideoTrack != null) {
                localVideoTrack!!.removeSink(thumbnailVideoView)
                localVideoTrack!!.addSink(primaryVideoView)
            }
            localVideoView = primaryVideoView
            primaryVideoView.mirror = (
                    cameraCapturerCompat?.cameraSource == CameraCapturerCompat.Source.FRONT_CAMERA)
        }
    }
}