package com.medicapp.medicapp

import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

/**
 * Service that provides the data for the fasting widget's ListView.
 */
class FastingWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        Log.d("FastingWidget", "Creating widget factory")
        return FastingWidgetFactory(applicationContext)
    }
}

/**
 * Factory that creates the RemoteViews for each item in the fasting widget's ListView.
 */
class FastingWidgetFactory(
    private val context: Context
) : RemoteViewsService.RemoteViewsFactory {

    private var fastingItems: List<FastingItem> = emptyList()

    override fun onCreate() {
        Log.d("FastingWidget", "Factory onCreate")
        loadData()
    }

    override fun onDataSetChanged() {
        Log.d("FastingWidget", "Factory onDataSetChanged")
        loadData()
    }

    override fun onDestroy() {
        Log.d("FastingWidget", "Factory onDestroy")
        fastingItems = emptyList()
    }

    override fun getCount(): Int {
        Log.d("FastingWidget", "getCount: ${fastingItems.size}")
        return fastingItems.size
    }

    override fun getViewAt(position: Int): RemoteViews {
        Log.d("FastingWidget", "getViewAt: $position")
        val views = RemoteViews(context.packageName, R.layout.fasting_widget_item_layout)

        if (position < 0 || position >= fastingItems.size) {
            Log.w("FastingWidget", "Invalid position: $position")
            return views
        }

        try {
            val item = fastingItems[position]

            // Set the medication name
            views.setTextViewText(R.id.fasting_item_name, item.medicationName)

            // Set the fasting type
            views.setTextViewText(R.id.fasting_item_type, item.fastingTypeDisplay)

            // Set the countdown or completed status
            if (item.isComplete) {
                views.setTextViewText(R.id.fasting_item_countdown, context.getString(R.string.fasting_complete))
                views.setTextColor(R.id.fasting_item_countdown, 0xFF4CAF50.toInt()) // Green
                views.setImageViewResource(R.id.fasting_item_icon, R.drawable.ic_fasting_complete)
                views.setTextViewText(R.id.fasting_item_end_time, "")
            } else {
                views.setTextViewText(R.id.fasting_item_countdown, item.countdownDisplay)
                views.setTextColor(R.id.fasting_item_countdown, 0xFFFF9800.toInt()) // Amber
                views.setImageViewResource(R.id.fasting_item_icon, R.drawable.ic_fasting_active)
                views.setTextViewText(R.id.fasting_item_end_time,
                    context.getString(R.string.fasting_until, item.endTime))
            }

            // Set fill-in intent for item click (opens app)
            val fillInIntent = Intent()
            views.setOnClickFillInIntent(R.id.fasting_item_container, fillInIntent)

        } catch (e: Exception) {
            Log.e("FastingWidget", "Error creating view at $position: ${e.message}", e)
        }

        return views
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = false

    private fun loadData() {
        try {
            fastingItems = getActiveFastingItems(context)
            Log.d("FastingWidget", "Loaded ${fastingItems.size} fasting items")
        } catch (e: Exception) {
            Log.e("FastingWidget", "Error loading data: ${e.message}", e)
            fastingItems = emptyList()
        }
    }
}

/**
 * Data class representing a fasting countdown item for the widget.
 */
data class FastingItem(
    val medicationId: String,
    val medicationName: String,
    val fastingType: String,
    val fastingDurationMinutes: Int,
    val doseTime: String,
    val fastingStartTime: Long, // Timestamp when fasting started
    val fastingEndTime: Long    // Timestamp when fasting ends
) {
    val isComplete: Boolean
        get() = System.currentTimeMillis() >= fastingEndTime

    val remainingMillis: Long
        get() = maxOf(0, fastingEndTime - System.currentTimeMillis())

    val countdownDisplay: String
        get() {
            val remaining = remainingMillis
            val hours = (remaining / (1000 * 60 * 60)).toInt()
            val minutes = ((remaining / (1000 * 60)) % 60).toInt()
            val seconds = ((remaining / 1000) % 60).toInt()
            return String.format("%02d:%02d:%02d", hours, minutes, seconds)
        }

    val endTime: String
        get() {
            val sdf = SimpleDateFormat("HH:mm", Locale.getDefault())
            return sdf.format(Date(fastingEndTime))
        }

    val fastingTypeDisplay: String
        get() = when (fastingType) {
            "complete" -> "Ayuno completo"
            "food" -> "Sin alimentos"
            "liquids" -> "Sin líquidos"
            else -> "Ayuno"
        }
}

/**
 * Helper function to get active fasting items from the database.
 * Returns medications that require fasting and have an upcoming dose today.
 */
fun getActiveFastingItems(context: Context): List<FastingItem> {
    val items = mutableListOf<FastingItem>()

    try {
        val dbPath = context.getDatabasePath("medications.db")
        Log.d("FastingWidget", "Database path: ${dbPath.absolutePath}")

        if (!dbPath.exists()) {
            Log.d("FastingWidget", "Database does not exist yet")
            return emptyList()
        }

        val db = SQLiteDatabase.openDatabase(
            dbPath.absolutePath,
            null,
            SQLiteDatabase.OPEN_READONLY
        )

        val today = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
        val now = System.currentTimeMillis()
        val currentTimeStr = SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date())
        Log.d("FastingWidget", "Today: $today, Current time: $currentTimeStr")

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
            Log.d("FastingWidget", "No default person found")
            db.close()
            return emptyList()
        }

        Log.d("FastingWidget", "Default person ID: $defaultPersonId")

        // Get medications that require fasting
        val query = """
            SELECT
                m.id,
                m.name,
                pm.doseSchedule,
                pm.takenDosesToday,
                pm.takenDosesDate,
                pm.requiresFasting,
                pm.fastingType,
                pm.fastingDurationMinutes,
                pm.durationType,
                pm.startDate,
                pm.endDate
            FROM medications m
            INNER JOIN person_medications pm ON m.id = pm.medicationId
            WHERE pm.personId = ?
            AND pm.isSuspended = 0
            AND pm.requiresFasting = 1
            AND pm.durationType != 'asNeeded'
        """.trimIndent()

        val cursor = db.rawQuery(query, arrayOf(defaultPersonId))
        Log.d("FastingWidget", "Found ${cursor.count} medications with fasting")

        while (cursor.moveToNext()) {
            val medicationId = cursor.getString(0)
            val medicationName = cursor.getString(1)
            val doseScheduleJson = cursor.getString(2) ?: "{}"
            val takenDosesTodayStr = cursor.getString(3) ?: ""
            val takenDosesDate = cursor.getString(4)
            val requiresFasting = cursor.getInt(5) == 1
            val fastingType = cursor.getString(6) ?: "complete"
            val fastingDurationMinutes = cursor.getInt(7).takeIf { it > 0 } ?: 30
            val durationType = cursor.getString(8) ?: "everyday"
            val startDateStr = cursor.getString(9)
            val endDateStr = cursor.getString(10)

            if (!requiresFasting) continue

            Log.d("FastingWidget", "Processing medication: $medicationName")
            Log.d("FastingWidget", "  - fastingType: $fastingType, duration: $fastingDurationMinutes min")

            // Check if medication should be taken today
            val shouldTakeToday = shouldTakeMedicationToday(
                durationType = durationType,
                stockQuantity = 1.0, // Not relevant for fasting check
                selectedDatesStr = null,
                weeklyDaysStr = null,
                dayInterval = 0,
                startDateStr = startDateStr,
                endDateStr = endDateStr,
                today = today
            )

            if (!shouldTakeToday) {
                Log.d("FastingWidget", "  - Skipping: not scheduled for today")
                continue
            }

            // Parse dose schedule
            val doseTimes = try {
                val json = JSONObject(doseScheduleJson)
                json.keys().asSequence().toList().sorted()
            } catch (e: Exception) {
                Log.e("FastingWidget", "Error parsing dose schedule: ${e.message}")
                emptyList()
            }

            // Parse taken doses (only if from today)
            val takenDoses = if (takenDosesDate == today) {
                takenDosesTodayStr.split(",").filter { it.isNotEmpty() }
            } else {
                emptyList()
            }

            // Find the next dose that requires fasting
            for (doseTime in doseTimes) {
                // Skip already taken doses
                if (takenDoses.contains(doseTime)) continue

                // Calculate fasting window
                val todayDateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
                val doseDateTime = todayDateFormat.parse("$today $doseTime") ?: continue
                val doseTimestamp = doseDateTime.time

                // Fasting starts fastingDurationMinutes before the dose
                val fastingStartTime = doseTimestamp - (fastingDurationMinutes * 60 * 1000L)
                val fastingEndTime = doseTimestamp

                // Only show if we're currently in the fasting window or it's upcoming soon (within 2 hours)
                val twoHoursFromNow = now + (2 * 60 * 60 * 1000)

                if (now >= fastingStartTime && now < fastingEndTime) {
                    // Currently in fasting window
                    items.add(
                        FastingItem(
                            medicationId = medicationId,
                            medicationName = medicationName,
                            fastingType = fastingType,
                            fastingDurationMinutes = fastingDurationMinutes,
                            doseTime = doseTime,
                            fastingStartTime = fastingStartTime,
                            fastingEndTime = fastingEndTime
                        )
                    )
                    Log.d("FastingWidget", "  - Added fasting item for $doseTime (active)")
                    break // Only show one fasting per medication
                } else if (now < fastingStartTime && fastingStartTime < twoHoursFromNow) {
                    // Upcoming fasting within 2 hours - show as preview
                    items.add(
                        FastingItem(
                            medicationId = medicationId,
                            medicationName = medicationName,
                            fastingType = fastingType,
                            fastingDurationMinutes = fastingDurationMinutes,
                            doseTime = doseTime,
                            fastingStartTime = fastingStartTime,
                            fastingEndTime = fastingEndTime
                        )
                    )
                    Log.d("FastingWidget", "  - Added fasting item for $doseTime (upcoming)")
                    break
                }
            }
        }

        cursor.close()
        db.close()

        Log.d("FastingWidget", "Total fasting items: ${items.size}")

    } catch (e: Exception) {
        Log.e("FastingWidget", "Error reading database: ${e.message}", e)
    }

    // Sort by end time (most urgent first)
    return items.sortedBy { it.fastingEndTime }
}
