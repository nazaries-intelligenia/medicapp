package com.medicapp.medicapp

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import android.util.Log

/**
 * Widget provider for MedicApp fasting countdown widget.
 * Displays active fasting countdowns for medications that require fasting.
 */
class FastingWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "FastingWidget"
        const val ACTION_UPDATE_WIDGET = "com.medicapp.medicapp.UPDATE_FASTING_WIDGET"
        const val ACTION_OPEN_APP = "com.medicapp.medicapp.OPEN_APP_FROM_FASTING"

        /**
         * Request widget update from Flutter or other components.
         */
        fun requestUpdate(context: Context) {
            val intent = Intent(context, FastingWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            }
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val widgetIds = appWidgetManager.getAppWidgetIds(
                ComponentName(context, FastingWidgetProvider::class.java)
            )
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
            context.sendBroadcast(intent)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "onUpdate called with ${appWidgetIds.size} widgets")
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        when (intent.action) {
            ACTION_UPDATE_WIDGET -> {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val widgetIds = appWidgetManager.getAppWidgetIds(
                    ComponentName(context, FastingWidgetProvider::class.java)
                )
                onUpdate(context, appWidgetManager, widgetIds)
            }
            ACTION_OPEN_APP -> {
                val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                launchIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(launchIntent)
            }
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        try {
            Log.d(TAG, "Updating widget $appWidgetId")
            val views = RemoteViews(context.packageName, R.layout.fasting_widget_layout)

            // Set up click intent to open the app
            val openAppIntent = Intent(context, FastingWidgetProvider::class.java).apply {
                action = ACTION_OPEN_APP
            }
            val openAppPendingIntent = PendingIntent.getBroadcast(
                context, 0, openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            // Set click handlers for all widget areas
            views.setOnClickPendingIntent(R.id.fasting_widget_clickable_bg, openAppPendingIntent)
            views.setOnClickPendingIntent(R.id.fasting_widget_header, openAppPendingIntent)

            // Set up the ListView adapter
            val serviceIntent = Intent(context, FastingWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            views.setRemoteAdapter(R.id.fasting_widget_list, serviceIntent)
            views.setEmptyView(R.id.fasting_widget_list, R.id.fasting_widget_empty)

            // Set up click template for list items to open the app
            val itemClickIntent = Intent(context, FastingWidgetProvider::class.java).apply {
                action = ACTION_OPEN_APP
            }
            val itemClickPendingIntent = PendingIntent.getBroadcast(
                context, 1, itemClickIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setPendingIntentTemplate(R.id.fasting_widget_list, itemClickPendingIntent)

            // Set click on empty view
            views.setOnClickPendingIntent(R.id.fasting_widget_empty, openAppPendingIntent)

            // Get fasting count
            val fastingItems = getActiveFastingItems(context)
            views.setTextViewText(R.id.fasting_widget_count, fastingItems.size.toString())

            Log.d(TAG, "Active fasting items: ${fastingItems.size}")

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.fasting_widget_list)

            Log.d(TAG, "Widget $appWidgetId updated successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget: ${e.message}", e)
        }
    }
}
