package com.iniyan.copypaste

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import java.io.Serializable

class OpenAppReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        val map: MutableMap<String, Boolean> = mutableMapOf(
            "inForeground" to false,
            "killBackground" to false,
            "killForeground" to true,
        )

        val killNotificationIntent = Intent(context, BackgroundService::class.java)
        killNotificationIntent.flags = Intent.FLAG_ACTIVITY_CLEAR_TASK
        killNotificationIntent.putExtra("map", map as Serializable)
        context.startService(killNotificationIntent)

        val launchIntent =
            Intent(context, MainActivity::class.java)
        launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(launchIntent)
    }
}