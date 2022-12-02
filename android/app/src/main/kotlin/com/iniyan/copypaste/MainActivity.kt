package com.iniyan.copypaste

import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.Serializable

class MainActivity : FlutterActivity() {
    companion object {
        var isAppDestroyed: Boolean = false
        var askForScreenOverlay: Boolean = false
    }
    private lateinit var backgroundIntent: Intent

    private val backgroundChannelName = "background_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            backgroundChannelName
        ).setMethodCallHandler { call, result ->
            run {

                if (!Settings.canDrawOverlays(this) && !askForScreenOverlay) {
                    askForScreenOverlay = true
                    val intent = Intent(
                        Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse(
                            "package:$packageName"
                        )
                    )
                    startActivityForResult(intent, 0)
                }

                if (call.method.equals("backgroundService")) {

                    val callArgs: Map<String, String> =
                        call.arguments<Map<String, String>>() as Map<String, String>

                    checkUserCredentialsSharedPreferences("userEmail", callArgs["userEmail"] as String)
                    checkUserCredentialsSharedPreferences("deviceName", callArgs["deviceName"] as String)

                    backgroundIntent =
                        Intent(applicationContext, BackgroundService::class.java)
                    val map: Map<String, Boolean> = mapOf(
                        "inForeground" to false,
                        "killBackground" to false,
                        "killForeground" to false,
                    )
                    backgroundIntent.putExtra("map", map as Serializable)
                    context.startService(backgroundIntent)

                    result.success("Success: Listening for Clipboard and Cloud changes in Background.")

                } else if (call.method.equals("stopBackgroundService")) {

                    val stopBackgroundIntent =
                        Intent(applicationContext, StopBackgroundServiceReceiver::class.java)
                    stopBackgroundIntent.putExtra("onlyKillForeground", false)
                    context.sendBroadcast(stopBackgroundIntent)

                    result.success("Success: Stopped Listening for Clipboard and Cloud changes in Foreground.")

                } else if (call.method.equals("resumeBackgroundService")) {

                    val startBackgroundIntent =
                        Intent(applicationContext, StartBackgroundServiceReceiver::class.java)
                    context.sendBroadcast(startBackgroundIntent)

                    result.success("Success: Listening for Clipboard and Cloud changes in Foreground.")

                } else if (call.method.equals("setNewDataAsNotification")) {

                    val callArgs: Map<String, Boolean> = call.arguments<Map<String, Boolean>>() as Map<String, Boolean>

                    checkNewDataAsNotificationSharedPreferences("asNotification", callArgs["asNotification"] as Boolean)

                    CloudChanges.asNotification = callArgs["asNotification"] == true
                }

            }
        }
    }

    private fun checkUserCredentialsSharedPreferences(key: String, value: String) {
        val sharedPreferences: SharedPreferences = getSharedPreferences("User", MODE_PRIVATE)

        if (sharedPreferences.contains(key)) {
            val data = sharedPreferences.getString(key, "")
            if (data != value && data != "") {
                val editor: SharedPreferences.Editor = sharedPreferences.edit()
                editor.remove(key)
                editor.putString(key, value)
                editor.apply()
                return
            }
        } else {
            val editor: SharedPreferences.Editor = sharedPreferences.edit()
            editor.putString(key, value)
            editor.apply()
            return
        }
        return
    }

    private fun checkNewDataAsNotificationSharedPreferences(key: String = "asNotifications", value: Boolean) {
        val sharedPreferences: SharedPreferences = getSharedPreferences("User", MODE_PRIVATE)

        if (sharedPreferences.contains(key)) {
            val editor: SharedPreferences.Editor = sharedPreferences.edit()
            editor.remove(key)
            editor.putBoolean(key, value)
            editor.apply()
        } else {
            val editor: SharedPreferences.Editor = sharedPreferences.edit()
            editor.putBoolean(key, value)
            editor.apply()
        }
        return
    }

    override fun onDestroy() {
        isAppDestroyed = true
        val startBackgroundIntent =
            Intent(applicationContext, StartBackgroundServiceReceiver::class.java)
        context.sendBroadcast(startBackgroundIntent)
        super.onDestroy()
    }

}
