package com.example.test_twilio

import com.example.test_twilio.video.HandleVideoMethodChannel
import com.example.test_twilio.video.view.VideoCallViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory("AndroidCameraView", VideoCallViewFactory.getInstance())
        HandleChatMethodChannel.getInstance().handle(flutterEngine)
        HandleVideoMethodChannel.getInstance().handle(flutterEngine)
    }

    override fun onResume() {
        super.onResume()
        VideoCallViewFactory.getInstance().onResume()
    }

    override fun onPause() {
        VideoCallViewFactory.getInstance().onPause()
        super.onPause()
    }

    override fun onDestroy() {
        VideoCallViewFactory.getInstance().onDestroy()
        super.onDestroy()
    }
}