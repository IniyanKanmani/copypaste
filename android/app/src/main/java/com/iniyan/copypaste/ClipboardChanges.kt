package com.iniyan.copypaste

import android.content.ClipboardManager

class ClipboardChanges {
    companion object {
        private lateinit var clipboardPrimaryClipListener: ClipboardManager.OnPrimaryClipChangedListener


        fun destroy() {
            BackgroundService.clipboardManager.removePrimaryClipChangedListener(
                clipboardPrimaryClipListener
            )
        }
    }


    fun clipboardChanges() {
        clipboardPrimaryClipListener = ClipboardManager.OnPrimaryClipChangedListener {}
        BackgroundService.clipboardManager.addPrimaryClipChangedListener(
            clipboardPrimaryClipListener
        )
    }
}