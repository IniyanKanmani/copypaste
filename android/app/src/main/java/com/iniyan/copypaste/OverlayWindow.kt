package com.iniyan.copypaste

import android.app.Service
import android.content.Context
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager

class OverlayWindow {
    private lateinit var layoutParams: WindowManager.LayoutParams
    private lateinit var layoutInflater: LayoutInflater
    private lateinit var overlayView: View
    private lateinit var windowManager: WindowManager

    fun createOverlayWindow(context: Context) {
        layoutParams = WindowManager.LayoutParams(
            1, 1,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM,
            PixelFormat.TRANSPARENT
        )

        layoutInflater =
            context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater

        overlayView = layoutInflater.inflate(R.layout.popup_window, null)

        layoutParams.gravity = Gravity.TOP

        windowManager =
            context.getSystemService(Service.WINDOW_SERVICE) as WindowManager

        windowManager.addView(overlayView, layoutParams)

    }

    fun destroyOverlayWindow() {
        windowManager.removeView(overlayView)

        overlayView.invalidate()
    }
}