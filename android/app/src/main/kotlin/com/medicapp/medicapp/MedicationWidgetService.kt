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

            // Set the status icon
            when {
                dose.isTaken -> {
                    views.setImageViewResource(R.id.item_status_icon, R.drawable.ic_dose_taken)
                    // Dim the text for taken doses
                    views.setTextColor(R.id.item_name, 0x80FFFFFF.toInt())
                    views.setTextColor(R.id.item_time, 0x60FFFFFF.toInt())
                }
                dose.isSkipped -> {
                    views.setImageViewResource(R.id.item_status_icon, R.drawable.ic_dose_pending)
                    // Dim the text for skipped doses
                    views.setTextColor(R.id.item_name, 0x50FFFFFF.toInt())
                    views.setTextColor(R.id.item_time, 0x40FFFFFF.toInt())
                }
                else -> {
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
