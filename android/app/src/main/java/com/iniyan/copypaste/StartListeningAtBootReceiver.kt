package com.iniyan.copypaste

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import java.io.Serializable

class StartListeningAtBootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (Intent.ACTION_BOOT_COMPLETED == intent.action) {
            Toast.makeText(context, "Listening for Changes", Toast.LENGTH_SHORT)
                .show()

            val map: Map<String, Boolean> = mapOf(
                "inForeground" to true,
                "killBackground" to false,
                "killForeground" to false,
            )

            val launchIntent = Intent(context, BackgroundService::class.java)
            launchIntent.putExtra("map", map as Serializable)
            launchIntent.flags = Intent.FLAG_RECEIVER_FOREGROUND
            context.startForegroundService(launchIntent)
        }
    }
}