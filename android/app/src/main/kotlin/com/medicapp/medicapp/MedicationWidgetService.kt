package com.medicapp.medicapp

import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService

/**
 * Service that provides the data for the widget's ListView.
 */
class MedicationWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        Log.d("MedicationWidget", "Creating widget factory")
        return MedicationWidgetFactory(applicationContext)
    }
}

/**
 * Factory that creates the RemoteViews for each item in the widget's ListView.
 */
class MedicationWidgetFactory(
    private val context: Context
) : RemoteViewsService.RemoteViewsFactory {

    private var doses: List<DoseItem> = emptyList()

    override fun onCreate() {
        Log.d("MedicationWidget", "Factory onCreate")
        loadData()
    }

    override fun onDataSetChanged() {
        Log.d("MedicationWidget", "Factory onDataSetChanged")
        loadData()
    }

    override fun onDestroy() {
        Log.d("MedicationWidget", "Factory onDestroy")
        doses = emptyList()
    }

    override fun getCount(): Int {
        Log.d("MedicationWidget", "getCount: ${doses.size}")
        return doses.size
    }

    override fun getViewAt(position: Int): RemoteViews {
        Log.d("MedicationWidget", "getViewAt: $position")
        val views = RemoteViews(context.packageName, R.layout.widget_item_layout)

        if (position < 0 || position >= doses.size) {
            Log.w("MedicationWidget", "Invalid position: $position")
            return views
        }

        try {
            val dose = doses[position]

            // Set the medication name
            views.setTextViewText(R.id.item_name, dose.medicationName)

            // Set the time
            views.setTextViewText(R.id.item_time, dose.time)

            // Set the status icon and text colors based on dose status
            when {
                dose.isTaken -> {
                    // Green filled circle with checkmark
                    views.setImageViewResource(R.id.item_status_icon, R.drawable.ic_dose_taken)
                    // Dimmed but visible text for taken doses (70% opacity)
                    views.setTextColor(R.id.item_name, 0xB3FFFFFF.toInt())
                    views.setTextColor(R.id.item_time, 0x99FFFFFF.toInt())
                }
                dose.isSkipped -> {
                    // Gray circle with X mark
                    views.setImageViewResource(R.id.item_status_icon, R.drawable.ic_dose_skipped)
                    // More dimmed for skipped doses (50% opacity)
                    views.setTextColor(R.id.item_name, 0x80FFFFFF.toInt())
                    views.setTextColor(R.id.item_time, 0x66FFFFFF.toInt())
                }
                else -> {
                    // Green empty circle (pending)
                    views.setImageViewResource(R.id.item_status_icon, R.drawable.ic_dose_pending)
                    // Full opacity for pending doses
                    views.setTextColor(R.id.item_name, 0xFFFFFFFF.toInt())
                    views.setTextColor(R.id.item_time, 0xB0FFFFFF.toInt())
                }
            }

            // Set fill-in intent for item click (opens app)
            val fillInIntent = Intent()
            views.setOnClickFillInIntent(R.id.widget_item_container, fillInIntent)

        } catch (e: Exception) {
            Log.e("MedicationWidget", "Error creating view at $position: ${e.message}", e)
        }

        return views
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = false

    private fun loadData() {
        try {
            doses = getDosesFromDatabase(context)
            Log.d("MedicationWidget", "Loaded ${doses.size} doses")
        } catch (e: Exception) {
            Log.e("MedicationWidget", "Error loading data: ${e.message}", e)
            doses = emptyList()
        }
    }
}
