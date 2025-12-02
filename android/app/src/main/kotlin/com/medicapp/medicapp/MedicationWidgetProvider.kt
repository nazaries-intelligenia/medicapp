package com.medicapp.medicapp

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import java.io.File
import java.text.SimpleDateFormat
import java.util.*
import org.json.JSONObject

/**
 * Widget provider for MedicApp home screen widget.
 * Displays today's medication doses with their status.
 */
class MedicationWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "MedicationWidget"
        const val ACTION_UPDATE_WIDGET = "com.medicapp.medicapp.UPDATE_WIDGET"
        const val ACTION_OPEN_APP = "com.medicapp.medicapp.OPEN_APP"

        /**
         * Request widget update from Flutter or other components.
         */
        fun requestUpdate(context: Context) {
            val intent = Intent(context, MedicationWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            }
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val widgetIds = appWidgetManager.getAppWidgetIds(
                ComponentName(context, MedicationWidgetProvider::class.java)
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
                    ComponentName(context, MedicationWidgetProvider::class.java)
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
            val views = RemoteViews(context.packageName, R.layout.medication_widget_layout)

            // Set up click intent to open the app
            val openAppIntent = Intent(context, MedicationWidgetProvider::class.java).apply {
                action = ACTION_OPEN_APP
            }
            val openAppPendingIntent = PendingIntent.getBroadcast(
                context, 0, openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, openAppPendingIntent)

            // Set up the ListView adapter
            val serviceIntent = Intent(context, MedicationWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            views.setRemoteAdapter(R.id.widget_list, serviceIntent)
            views.setEmptyView(R.id.widget_list, R.id.widget_empty)

            // Get dose statistics
            val stats = getDoseStats(context)
            views.setTextViewText(R.id.widget_title, context.getString(R.string.widget_today))
            views.setTextViewText(R.id.widget_count, "${stats.taken}/${stats.total}")

            Log.d(TAG, "Widget stats: ${stats.taken}/${stats.total}")

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.widget_list)

            Log.d(TAG, "Widget $appWidgetId updated successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget: ${e.message}", e)
        }
    }

    private fun getDoseStats(context: Context): DoseStats {
        return try {
            val doses = getDosesFromDatabase(context)
            val taken = doses.count { it.isTaken }
            DoseStats(taken, doses.size)
        } catch (e: Exception) {
            Log.e(TAG, "Error getting dose stats: ${e.message}", e)
            DoseStats(0, 0)
        }
    }

    data class DoseStats(val taken: Int, val total: Int)
}

/**
 * Data class representing a dose item for the widget.
 */
data class DoseItem(
    val medicationId: String,
    val medicationName: String,
    val time: String,
    val isTaken: Boolean,
    val isSkipped: Boolean
)

/**
 * Helper function to get doses from the database.
 * Reads directly from the SQLite database file.
 */
fun getDosesFromDatabase(context: Context): List<DoseItem> {
    val doses = mutableListOf<DoseItem>()

    try {
        val dbPath = context.getDatabasePath("medications.db")
        Log.d("MedicationWidget", "Database path: ${dbPath.absolutePath}")

        if (!dbPath.exists()) {
            Log.d("MedicationWidget", "Database does not exist yet")
            return emptyList()
        }

        val db = SQLiteDatabase.openDatabase(
            dbPath.absolutePath,
            null,
            SQLiteDatabase.OPEN_READONLY
        )

        val today = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
        Log.d("MedicationWidget", "Today: $today")

        // Get default person ID
        var defaultPersonId: String? = null
        val personCursor = db.rawQuery(
            "SELECT id FROM persons WHERE isDefault = 1 LIMIT 1",
            null
        )
        if (personCursor.moveToFirst()) {
            defaultPersonId = personCursor.getString(0)
        }
        personCursor.close()

        if (defaultPersonId == null) {
            Log.d("MedicationWidget", "No default person found")
            db.close()
            return emptyList()
        }

        Log.d("MedicationWidget", "Default person ID: $defaultPersonId")

        // Get medications for default person with their schedules
        val query = """
            SELECT
                m.id,
                m.name,
                m.stockQuantity,
                pm.doseSchedule,
                pm.takenDosesToday,
                pm.skippedDosesToday,
                pm.takenDosesDate,
                pm.durationType,
                pm.selectedDates,
                pm.weeklyDays,
                pm.dayInterval,
                pm.startDate,
                pm.endDate
            FROM medications m
            INNER JOIN person_medications pm ON m.id = pm.medicationId
            WHERE pm.personId = ?
            AND pm.isSuspended = 0
            AND pm.durationType != 'asNeeded'
        """.trimIndent()

        val cursor = db.rawQuery(query, arrayOf(defaultPersonId))
        Log.d("MedicationWidget", "Found ${cursor.count} medications")

        while (cursor.moveToNext()) {
            val medicationId = cursor.getString(0)
            val medicationName = cursor.getString(1)
            val stockQuantity = cursor.getDouble(2)
            val doseScheduleJson = cursor.getString(3) ?: "{}"
            val takenDosesTodayStr = cursor.getString(4) ?: ""
            val skippedDosesTodayStr = cursor.getString(5) ?: ""
            val takenDosesDate = cursor.getString(6)
            val durationType = cursor.getString(7) ?: "everyday"
            val selectedDatesStr = cursor.getString(8)
            val weeklyDaysStr = cursor.getString(9)
            val dayInterval = cursor.getInt(10)
            val startDateStr = cursor.getString(11)
            val endDateStr = cursor.getString(12)

            Log.d("MedicationWidget", "Processing medication: $medicationName")
            Log.d("MedicationWidget", "  - durationType: $durationType")
            Log.d("MedicationWidget", "  - doseSchedule: $doseScheduleJson")
            Log.d("MedicationWidget", "  - takenDosesToday: $takenDosesTodayStr")
            Log.d("MedicationWidget", "  - skippedDosesToday: $skippedDosesTodayStr")
            Log.d("MedicationWidget", "  - takenDosesDate: $takenDosesDate (today: $today)")

            // Check if medication should be taken today based on duration type
            val shouldTakeToday = shouldTakeMedicationToday(
                durationType = durationType,
                stockQuantity = stockQuantity,
                selectedDatesStr = selectedDatesStr,
                weeklyDaysStr = weeklyDaysStr,
                dayInterval = dayInterval,
                startDateStr = startDateStr,
                endDateStr = endDateStr,
                today = today
            )

            if (!shouldTakeToday) {
                Log.d("MedicationWidget", "  - Skipping: not scheduled for today")
                continue
            }

            // Parse dose schedule (Map<String, Double> as JSON)
            val doseSchedule = try {
                val json = JSONObject(doseScheduleJson)
                json.keys().asSequence().toList()
            } catch (e: Exception) {
                Log.e("MedicationWidget", "Error parsing dose schedule: ${e.message}")
                emptyList()
            }

            // Parse taken doses (only if from today)
            // Flutter saves as comma-separated string: "08:00,12:00,18:00"
            val takenDoses = if (takenDosesDate == today) {
                takenDosesTodayStr.split(",").filter { it.isNotEmpty() }
            } else {
                emptyList()
            }

            // Parse skipped doses (only if from today)
            // Flutter saves as comma-separated string: "08:00,12:00"
            val skippedDoses = if (takenDosesDate == today) {
                skippedDosesTodayStr.split(",").filter { it.isNotEmpty() }
            } else {
                emptyList()
            }

            Log.d("MedicationWidget", "  - Parsed schedule times: $doseSchedule")
            Log.d("MedicationWidget", "  - Parsed taken doses: $takenDoses")
            Log.d("MedicationWidget", "  - Parsed skipped doses: $skippedDoses")

            // Create dose items for each scheduled time
            for (time in doseSchedule) {
                val isTaken = takenDoses.contains(time)
                val isSkipped = skippedDoses.contains(time)

                doses.add(
                    DoseItem(
                        medicationId = medicationId,
                        medicationName = medicationName,
                        time = time,
                        isTaken = isTaken,
                        isSkipped = isSkipped
                    )
                )
            }
        }

        cursor.close()
        db.close()

        Log.d("MedicationWidget", "Total doses found: ${doses.size}")

    } catch (e: Exception) {
        Log.e("MedicationWidget", "Error reading database: ${e.message}", e)
    }

    // Sort by time, then by taken status (pending first)
    return doses.sortedWith(compareBy({ it.time }, { it.isTaken || it.isSkipped }))
}

/**
 * Check if medication should be taken today based on duration type.
 * Mirrors the logic from Flutter's Medication.shouldTakeToday().
 */
private fun shouldTakeMedicationToday(
    durationType: String,
    stockQuantity: Double,
    selectedDatesStr: String?,
    weeklyDaysStr: String?,
    dayInterval: Int,
    startDateStr: String?,
    endDateStr: String?,
    today: String
): Boolean {
    // Check if treatment has ended
    if (endDateStr != null && endDateStr.isNotEmpty()) {
        if (today > endDateStr) {
            Log.d("MedicationWidget", "    Treatment ended: $endDateStr")
            return false
        }
    }

    // Check if treatment hasn't started yet
    if (startDateStr != null && startDateStr.isNotEmpty()) {
        if (today < startDateStr) {
            Log.d("MedicationWidget", "    Treatment not started: $startDateStr")
            return false
        }
    }

    return when (durationType) {
        "everyday" -> true
        "untilFinished" -> stockQuantity > 0
        "specificDates" -> {
            val selectedDates = selectedDatesStr?.split(",")?.filter { it.isNotEmpty() } ?: emptyList()
            selectedDates.contains(today)
        }
        "weeklyPattern" -> {
            val calendar = Calendar.getInstance()
            val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            calendar.time = dateFormat.parse(today) ?: Date()
            // Calendar.DAY_OF_WEEK: Sunday=1, Monday=2, ... Saturday=7
            // Flutter weekday: Monday=1, ... Sunday=7
            val calendarDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK)
            val flutterWeekday = if (calendarDayOfWeek == Calendar.SUNDAY) 7 else calendarDayOfWeek - 1
            val weeklyDays = weeklyDaysStr?.split(",")
                ?.filter { it.isNotEmpty() }
                ?.map { it.toInt() } ?: emptyList()
            weeklyDays.contains(flutterWeekday)
        }
        "intervalDays" -> {
            if (startDateStr.isNullOrEmpty()) return true
            val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val startDate = dateFormat.parse(startDateStr) ?: return true
            val todayDate = dateFormat.parse(today) ?: return true
            val daysSinceStart = ((todayDate.time - startDate.time) / (1000 * 60 * 60 * 24)).toInt()
            val interval = if (dayInterval > 0) dayInterval else 2
            daysSinceStart % interval == 0
        }
        "asNeeded" -> false // Already filtered in SQL, but just in case
        else -> true
    }
}
