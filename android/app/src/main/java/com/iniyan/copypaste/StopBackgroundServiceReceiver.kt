package com.iniyan.copypaste

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import java.io.Serializable
import kotlin.system.exitProcess

class StopBackgroundServiceReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        val onlyKillForeground: Boolean = intent.getBooleanExtra("onlyKillForeground", false)

        val map: MutableMap<String, Boolean> = mutableMapOf(
            "inForeground" to false,
            "killBackground" to false,
            "killForeground" to true,
        )

        val killNotificationIntent = Intent(context, BackgroundService::class.java)
        killNotificationIntent.flags = Intent.FLAG_ACTIVITY_CLEAR_TASK
        killNotificationIntent.putExtra("map", map as Serializable)
        context.startService(killNotificationIntent)

        if (onlyKillForeground && MainActivity.isAppDestroyed) {
            Handler(Looper.getMainLooper()).postDelayed({
                exitProcess(0)
            }, 100)
        }

        if (!onlyKillForeground) {
            Handler(Looper.getMainLooper()).postDelayed({
                map.remove("killForeground")
                map["killForeground"] = false

                val launchIntent = Intent(context, BackgroundService::class.java)
                launchIntent.putExtra("map", map as Serializable)
                launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startService(launchIntent)
            }, 50)
        }

    }
}