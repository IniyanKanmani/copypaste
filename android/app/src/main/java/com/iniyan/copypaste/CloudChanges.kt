package com.iniyan.copypaste

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ClipData
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import com.google.firebase.Timestamp
import com.google.firebase.firestore.*

class CloudChanges {
    companion object {
        private lateinit var collectionReference: CollectionReference
        private lateinit var snapShopListener: ListenerRegistration


        fun destroy() {
            snapShopListener.remove()
        }
    }

    private val currentTime: Timestamp = Timestamp.now()


    fun cloudChanges(
        context: Context,
        firestore: FirebaseFirestore,
    ) {

        collectionReference =
            firestore.collection("users")
                .document(BackgroundService.userEmail)
                .collection("text")

        snapShopListener =
            collectionReference
                .orderBy("time", Query.Direction.DESCENDING)
                .addSnapshotListener(
                    object : EventListener<QuerySnapshot?> {
                        override fun onEvent(
                            snapshot: QuerySnapshot?,
                            error: FirebaseFirestoreException?
                        ) {

                            if (error != null) {
                                return
                            }

                            if (snapshot != null && !snapshot.isEmpty) {

                                val documents =
                                    snapshot.documents.map { e -> CopiedData.fromJson(e.data as Map<String, Any>) }

                                val docMap: Map<String, Any> = documents.first().toJson()

                                if ((docMap["device"] == BackgroundService.deviceName)
                                    || (currentTime > (docMap["time"] as Timestamp))
                                ) {
                                    return
                                }


                                val data: String = docMap["data"] as String

//                                val overlayWindow = OverlayWindow()
//
//                                overlayWindow.createOverlayWindow(context)
//
//                                val clip = ClipData.newPlainText("text", data)
//                                BackgroundService.clipboardManager.setPrimaryClip(clip)
//
//                                overlayWindow.destroyOverlayWindow()

                                val notificationChannel = NotificationChannel(
                                    "2",
                                    "New Data From Cloud Notification",
                                    NotificationManager.IMPORTANCE_HIGH
                                )

                                BackgroundService.copyTextNotificationManager.createNotificationChannel(
                                    notificationChannel
                                )

                                val copyIntent =
                                    Intent(
                                        context,
                                        CopyDataToClipboardService::class.java
                                    )
                                copyIntent.putExtra("data", data)
                                copyIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                val copyPendingIntent =
                                    PendingIntent.getService(
                                        context,
                                        0,
                                        copyIntent,
                                        PendingIntent.FLAG_MUTABLE
                                                or PendingIntent.FLAG_UPDATE_CURRENT
                                                or PendingIntent.FLAG_ONE_SHOT
                                                or PendingIntent.FLAG_CANCEL_CURRENT
                                    )

                                val notification =
                                    NotificationCompat.Builder(context, "2")
                                        .setContentTitle("CopyPaste")
                                        .setContentText(
                                            "New text from ${
                                                docMap["device"]
                                            }"
                                        )
                                        .setSmallIcon(R.mipmap.ic_launcher)
                                        .setPriority(NotificationCompat.PRIORITY_MAX)
                                        .setContentIntent(copyPendingIntent)
                                        .setAutoCancel(true)

                                BackgroundService.copyTextNotificationManager.notify(
                                    2,
                                    notification.build()
                                )

                            }
                        }
                    }
                )
    }


    fun sendData(data: String, time: Timestamp) {
        collectionReference.add(
            mapOf(
                "data" to data,
                "device" to BackgroundService.deviceName,
                "time" to time
            )
        )
    }

}