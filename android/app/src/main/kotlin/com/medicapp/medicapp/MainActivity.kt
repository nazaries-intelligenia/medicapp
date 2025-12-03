package com.medicapp.medicapp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val widgetChannel = "com.medicapp.medicapp/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up method channel for widget communication
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateWidget" -> {
                        // Update both widgets
                        MedicationWidgetProvider.requestUpdate(this)
                        FastingWidgetProvider.requestUpdate(this)
                        result.success(null)
                    }
                    "updateFastingWidget" -> {
                        // Update only fasting widget
                        FastingWidgetProvider.requestUpdate(this)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
