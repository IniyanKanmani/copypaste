package com.iniyan.copypaste

import com.google.firebase.Timestamp

class CopiedData constructor(
    private val data: String,
    private val device: String,
    private val time: Timestamp
) {
    companion object {
        fun fromJson(map: Map<String, Any>): CopiedData {
            return CopiedData(
                data = map["data"] as String,
                device = map["device"] as String,
                time = map["time"] as Timestamp
            )
        }
    }


    fun toJson(): Map<String, Any> {
        return mapOf<String, Any>(
            "data" to data,
            "device" to device,
            "time" to time
        )
    }
}