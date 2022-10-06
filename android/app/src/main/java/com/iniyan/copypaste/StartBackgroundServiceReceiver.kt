package com.iniyan.copypaste

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import java.io.Serializable

class StartBackgroundServiceReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        val map: MutableMap<String, Any> = mutableMapOf(
            "inForeground" to false,
            "killBackground" to true,
            "killForeground" to false,
        )

        val killBackgroundServiceIntent = Intent(context, BackgroundService::class.java)
        killBackgroundServiceIntent.putExtra("map", map as Serializable)
        killBackgroundServiceIntent.flags = Intent.FLAG_ACTIVITY_CLEAR_TASK
        context.startService(killBackgroundServiceIntent)

        Handler(Looper.getMainLooper()).postDelayed({
            map.remove("killBackground")
            map.remove("inForeground")
            map["killBackground"] = false
            map["inForeground"] = true

            val launchIntent = Intent(context, BackgroundService::class.java)
            launchIntent.putExtra("map", map as Serializable)
            launchIntent.flags = Intent.FLAG_RECEIVER_FOREGROUND
            context.startForegroundService(launchIntent)
        }, 50)

    }
}