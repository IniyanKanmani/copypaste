package com.iniyan.copypaste

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.google.firebase.Timestamp
import java.io.BufferedReader
import java.io.InputStreamReader

class ReadLogs {
    companion object {
        private var readLogsThread: Thread? = null
        private var handler: Handler? = null
        private var process: Process? = null
        private var inputStreamReader: InputStreamReader? = null
        private lateinit var bufferedReader: BufferedReader
        private var exit: Boolean = false

        fun destroy() {
            try {
                exit = true
                process?.destroy()
                inputStreamReader?.close()
                bufferedReader.close()
                handler?.removeCallbacksAndMessages(null)
                readLogsThread?.interrupt()
            } catch (_: Exception) {
            }
        }
    }


    fun readLog(context: Context) {
        try {
            exit = false
            handler = Handler(Looper.getMainLooper())
            readLogsThread = Thread {
                try {
                    Runtime.getRuntime().exec("logcat -c")

                    process = Runtime.getRuntime().exec("logcat ClipboardService:E *:S")
                    inputStreamReader = InputStreamReader(process?.inputStream)
                    bufferedReader = BufferedReader(inputStreamReader)
                    var line: String

                    while (!exit) {
                        line = bufferedReader.readLine()
                        if (line.contains("copypaste")) {
                            getClipboardMessage(context)
                            process?.destroy()
                            inputStreamReader?.close()
                            bufferedReader.close()
                            inputStreamReader = null
                            process = null
                            Runtime.getRuntime().exec("logcat -c")
                            process = Runtime.getRuntime().exec("logcat ClipboardService:E *:S")
                            inputStreamReader = InputStreamReader(process?.inputStream)
                            bufferedReader = BufferedReader(inputStreamReader)
                        }
                    }

                } catch (_: Exception) {
                }
            }
            readLogsThread?.start()

        } catch (_: Exception) {
        }
    }


    private fun getClipboardMessage(context: Context) {
        handler?.post {

            val overlay = OverlayWindow()
            overlay.createOverlayWindow(context)
            val data: String =
                BackgroundService.clipboardManager.primaryClip?.getItemAt(0)?.text.toString()
            overlay.destroyOverlayWindow()

            val time: Timestamp = Timestamp.now()

            val cloudChanges = CloudChanges()
            cloudChanges.sendData(data, time)

        }
    }

}