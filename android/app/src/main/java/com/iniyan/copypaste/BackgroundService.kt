package com.iniyan.copypaste

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.ClipboardManager
import android.content.Intent
import android.content.SharedPreferences
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase


class BackgroundService : Service() {
    companion object {
        private lateinit var receivedMap: Map<String, Boolean>
        private lateinit var foregroundNotificationManager: NotificationManager
        lateinit var clipboardManager: ClipboardManager
        private lateinit var sharedPreferences: SharedPreferences
        lateinit var userEmail: String
        lateinit var deviceName: String
        lateinit var copyTextNotificationManager: NotificationManager
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        super.onStartCommand(intent, flags, startId)

        receivedMap =
            intent?.getSerializableExtra("map") as Map<String, Boolean>

        if (receivedMap["killBackground"] == true) {

//            CloudChanges.destroy()

            stopSelf()
            return START_NOT_STICKY

        } else if (receivedMap["killForeground"] == true) {

            ClipboardChanges.destroy()

            CloudChanges.destroy()

            ReadLogs.destroy()

            this.stopForeground(true)
            foregroundNotificationManager.cancel(1)
            stopSelf()
            return START_NOT_STICKY

        } else if (receivedMap["inForeground"] == true) {

            val notificationChannel = NotificationChannel(
                "1",
                "Foreground Service to listen for changes",
                NotificationManager.IMPORTANCE_NONE
            )

            foregroundNotificationManager = getSystemService(NotificationManager::class.java)
            foregroundNotificationManager.createNotificationChannel(notificationChannel)

            val launchAppIntent =
                Intent(applicationContext, OpenAppReceiver::class.java)
            launchAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK

            val launchPendingIntent =
                PendingIntent.getBroadcast(
                    applicationContext,
                    0,
                    launchAppIntent,
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_CANCEL_CURRENT
                )

            val killNotificationIntent =
                Intent(applicationContext, StopBackgroundServiceReceiver::class.java)
            launchAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            killNotificationIntent.putExtra("onlyKillForeground", true)

            val killNotificationPendingIntent = PendingIntent.getBroadcast(
                applicationContext,
                0,
                killNotificationIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_CANCEL_CURRENT
            )

            val notification = NotificationCompat.Builder(applicationContext, "1")
                .setContentTitle("CopyPaste")
                .setContentText("Listening to clipboard and cloud changes")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setPriority(NotificationCompat.PRIORITY_MIN)
                .setContentIntent(launchPendingIntent)
                .setAutoCancel(true)
                .addAction(R.mipmap.ic_launcher, "Stop", killNotificationPendingIntent)
                .build()

            startForeground(1, notification)

            clipboardChanges()
            cloudChanges()
            logChanges()

        }

        return START_STICKY
    }


    override fun onTaskRemoved(rootIntent: Intent?) {

        stopSelf()

        super.onTaskRemoved(rootIntent)
    }


    private fun clipboardChanges() {

        clipboardManager =
            applicationContext.getSystemService(CLIPBOARD_SERVICE) as ClipboardManager

        val clipboardChanges = ClipboardChanges()

        clipboardChanges.clipboardChanges()

    }


    private fun cloudChanges() {

        sharedPreferences = getSharedPreferences("User", MODE_PRIVATE)
        userEmail = sharedPreferences.getString("userEmail", "").toString()
        deviceName = sharedPreferences.getString("deviceName", "").toString()

        val firestore = Firebase.firestore

        copyTextNotificationManager = getSystemService(NotificationManager::class.java)

        val cloudChanges = CloudChanges()

        cloudChanges.cloudChanges(
            applicationContext,
            firestore,
        )

    }


    private fun logChanges() {

        val readLogs = ReadLogs()
        readLogs.readLog(applicationContext)

    }


    override fun onBind(intent: Intent): IBinder? {
        return null
    }

}
