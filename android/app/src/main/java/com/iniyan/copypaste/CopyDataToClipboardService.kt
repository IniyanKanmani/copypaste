package com.iniyan.copypaste

import android.app.Service
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.widget.Toast

class CopyDataToClipboardService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        super.onStartCommand(intent, flags, startId)

        val data: String =
            intent?.getStringExtra("data") as String

        val clipBoard: ClipboardManager =
            getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText("text", data)

        val overlayWindow = OverlayWindow()
        overlayWindow.createOverlayWindow(applicationContext)
        clipBoard.setPrimaryClip(clip)
        overlayWindow.destroyOverlayWindow()

        Toast.makeText(applicationContext, "Copied to Clipboard", Toast.LENGTH_SHORT).show()

        stopSelf()

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }
}