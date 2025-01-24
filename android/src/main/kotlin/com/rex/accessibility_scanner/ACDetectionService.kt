package com.rex.accessibility_scanner

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.text.TextUtils
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent

class ACDetectionService : AccessibilityService() {
    private val bufferResultMap = mutableMapOf<Int, StringBuffer>()

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onAccessibilityEvent(arg0: AccessibilityEvent) {
        // 暂无处理
    }

    override fun onInterrupt() {
        // 暂无处理
    }

    override fun onKeyEvent(event: KeyEvent): Boolean {
        val keyCode = event.keyCode
        if ((event.device?.id ?: 0) > 0) {
            if (event.action == KeyEvent.ACTION_DOWN) {
                if (keyCode == KeyEvent.KEYCODE_ENTER) {
                    //若为回车键，直接返回
                    if (bufferResultMap[event.device.id] != null) {
                        val bf = bufferResultMap.remove(event.device.id)
                        if (!TextUtils.isEmpty(bf?.toString())) {
                            AccessibilityScannerPlugin.sendEvent(bf.toString())
                        }
                    }
                    return super.onKeyEvent(event)
                }
                val pressedKey = event.unicodeChar.toChar()
                if (pressedKey.code != 0) {
                    if (bufferResultMap[event.device.id] == null) {
                        bufferResultMap[event.device.id] = StringBuffer()
                    }
                    bufferResultMap[event.device.id]?.append(pressedKey)
                }
                return super.onKeyEvent(event)
            }
        }
        return super.onKeyEvent(event)
    }

    override fun onDestroy() {
        bufferResultMap.clear()
        super.onDestroy()
    }

}