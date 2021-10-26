package com.example.test_twilio

import android.app.Application
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.widget.Toast

class TwilioApplication : Application() {
    lateinit var basicClient: BasicChatClient
        private set

    override fun onCreate() {
        super.onCreate()
        instance = this
        basicClient = BasicChatClient(applicationContext)
    }

    @JvmOverloads fun showToast(text: String, duration: Int = Toast.LENGTH_SHORT) {
        Handler(Looper.getMainLooper()).post {
            val toast = Toast.makeText(applicationContext, text, duration)
            toast.setGravity(Gravity.CENTER_HORIZONTAL, 0, 0)
            toast.show()
        }
    }

    companion object {
        lateinit var instance: TwilioApplication
            private set
    }
}
