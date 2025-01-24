package com.rex.accessibility_scanner

import android.content.Context
import android.content.Intent
import android.provider.Settings
import androidx.annotation.NonNull
import cn.pindao.teascannerplugin.TeaScannerPlugin.AccessibilityUtil

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AccessibilityScannerPlugin */
class AccessibilityScannerPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    companion object {
        private var eventSink: EventChannel.EventSink? = null

        @JvmStatic
        fun sendEvent(data: String) {
            if (eventSink != null) {
                eventSink?.success(data)
            }
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "accessibility_scanner_method")
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "accessibility_scanner_event")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            ACConstant.METHOD_IS_ACCESSIBILITY_OPEN -> {
                //判断无障碍服务是否开启
                result.success(AccessibilityUtil.isAccessibilitySettingsOn(context))
            }

            ACConstant.METHOD_OPEN_ACCESSIBILITY_SETTING -> {
                //打开无障碍服务设置界面
                val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
                result.success("")
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
