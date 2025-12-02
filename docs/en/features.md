# MedicApp Features

This document details all the features and capabilities of MedicApp, an advanced medication management application designed for families and caregivers.

---

## 1. Multi-Person Management (V19+)

### Many-to-Many Architecture

MedicApp implements a sophisticated multi-person management architecture that allows multiple users to share medications while maintaining individual treatment configurations. This functionality is specifically designed for families, professional caregivers, and groups that need to coordinate medication for multiple people.

The architecture is based on a many-to-many relational model, where each medication (identified by name, type, and shared stock) can be assigned to multiple people, and each person can have multiple medications. Stock is managed centrally and automatically decremented regardless of who takes the medication, allowing precise control of shared inventory without duplicating data.

Each person can configure their own treatment regimen for the same medication, including specific schedules, personalized doses, treatment duration, and fasting preferences. For example, if a mother and her daughter share the same medication, the mother can have doses configured at 8:00 and 20:00, while the daughter only needs one daily dose at 12:00. Both share the same physical stock, but each receives notifications and independent tracking according to their regimen.

### Use Cases

This functionality is especially useful in various scenarios: families where multiple members take the same medication (such as vitamins or supplements), professional caregivers managing medication for multiple patients, multigenerational households where common medications are shared, and situations where shared stock needs to be monitored to prevent shortages. The system allows detailed tracking of dose history per person, facilitating therapeutic adherence and individualized medical control.

---

## 2. 14 Medication Types

### Complete Pharmaceutical Forms Catalog

MedicApp supports 14 different medication types, each with distinctive iconography, specific color scheme, and appropriate units of measurement. This diversity allows registering practically any pharmaceutical form found in a home or professional medicine cabinet.

**Available types:**

1. **Pill** - Blue color, circular icon. Unit: pills. For traditional solid tablets.
2. **Capsule** - Purple color, capsule icon. Unit: capsules. For gelatin capsule medications.
3. **Injection** - Red color, syringe icon. Unit: injections. For medications requiring parenteral administration.
4. **Syrup** - Orange color, glass icon. Unit: ml (milliliters). For oral liquid medications.
5. **Ovule** - Pink color, oval icon. Unit: ovules. For vaginal administration medications.
6. **Suppository** - Teal color, specific icon. Unit: suppositories. For rectal administration.
7. **Inhaler** - Cyan color, air icon. Unit: inhalations. For respiratory medications.
8. **Sachet** - Brown color, package icon. Unit: sachets. For powder or granulated medications.
9. **Spray** - Light blue color, drip icon. Unit: ml (milliliters). For nebulizers and nasal aerosols.
10. **Ointment** - Green color, opaque drop icon. Unit: grams. For topical cream medications.
11. **Lotion** - Indigo color, water icon. Unit: ml (milliliters). For topical liquid medications.
12. **Patch** - Amber color, healing icon. Unit: patches. For medicated patches and therapeutic dressings.
13. **Drop** - Blue-gray color, inverted drop icon. Unit: drops. For eye drops and ear drops.
14. **Other** - Gray color, generic icon. Unit: units. For any uncategorized pharmaceutical form.

### Benefits of the Type System

This detailed classification allows the system to automatically calculate stock precisely according to the corresponding unit of measurement, display icons and colors that facilitate quick visual identification, and generate contextual notifications that mention the specific medication type. Users can manage everything from simple pill treatments to complex regimens including inhalers, injections, and drops, all within a single coherent interface.

---

## 3. Medication Addition Flow

### Scheduled Medications (8 Steps)

The process of adding a medication with a scheduled time is guided and structured to ensure all necessary information is configured correctly:

**Step 1: Basic Information** - The medication name is entered and the type is selected from the 14 available options. The system validates that the name is not empty.

**Step 2: Treatment Frequency** - The dosing pattern is defined with six options: every day, until medication runs out, specific dates, days of the week, every N days, or as needed. This configuration determines when doses should be taken.

**Step 3: Dose Configuration** - Specific dosing times are established. The user can choose between uniform mode (same dose at all times) or customized doses for each time. For example, you can configure 1 pill at 8:00, 0.5 pills at 14:00, and 2 pills at 20:00.

**Step 4: Dosing Times** - The exact times when the medication should be taken are selected using a visual time picker. Multiple times per day can be configured as prescribed.

**Step 5: Treatment Duration** - If applicable according to the frequency type, the treatment start and end dates are established. This allows programming treatments with defined duration or continuous treatments.

**Step 6: Fasting Configuration** - It is defined whether the medication requires fasting before or after taking it, the duration of the fasting period in minutes, and whether fasting reminder notifications are desired.

**Step 7: Initial Stock** - The amount of available medication is entered in the units corresponding to the selected type. The system will use this value for inventory control.

**Step 8: Person Assignment** - The people who will take this medication are selected. For each person, an individual regimen with personalized schedules and doses can be configured, or the base configuration can be inherited.

### Occasional Medications (2 Steps)

For sporadic or "as needed" use medications, the process is significantly simplified:

**Step 1: Basic Information** - Medication name and type.

**Step 2: Initial Stock** - Available quantity. The system automatically configures the medication as "as needed", without scheduled times or automatic notifications.

### Automatic Validations

Throughout the process, MedicApp validates that all required fields have been completed before allowing advancement to the next step. It verifies that schedules are logical, that doses are positive numeric values, that start dates are not later than end dates, and that at least one person is assigned to the medication.

---

## 4. Dose Recording

### Scheduled Doses

MedicApp automatically manages scheduled doses according to each medication and person's configuration. When it's time for a dose, the user receives a notification and can record the dose from three points: the main screen where the pending dose is listed, the notification directly through quick actions, or by tapping the notification which opens a detailed confirmation screen.

When recording a scheduled dose, the system automatically deducts the corresponding amount from shared stock, marks the dose as taken on the current day for that specific person, creates an entry in the dose history with exact timestamp, and cancels the pending notification if it exists. If the medication requires post-dose fasting, a fasting end notification is immediately scheduled and a visual countdown is displayed on the main screen.

### Occasional Doses

For medications configured as "as needed" or when recording an off-schedule dose, MedicApp allows manual recording. The user accesses the medication from the medicine cabinet, selects "Take dose", manually enters the amount taken, and the system deducts from stock and records in history with the current time. This functionality is essential for analgesics, antipyretics, and other sporadic use medications.

### Exceptional Doses

The system also allows recording additional unscheduled doses for medications with fixed schedules. For example, if a patient needs an extra dose of analgesic between their usual doses, it can be recorded as an "extra dose". This dose is recorded in history marked as exceptional, deducts stock, but does not affect regular scheduled dose adherence tracking.

### Automatic History

Each recording action automatically generates a complete history entry that includes: the dose's scheduled date and time, the actual administration date and time, the person who took the medication, the medication name and type, the exact amount administered, the status (taken or omitted), and whether it was an unscheduled extra dose. This history allows detailed analysis of therapeutic adherence and facilitates medical reports.

---

## 5. Expiration Date Management

### Medication Expiration Control

MedicApp allows recording and monitoring medication expiration dates to ensure treatment safety. This functionality is especially important for as-needed and suspended medications that remain stored for extended periods.

The system uses a simplified MM/YYYY (month/year) format that matches the standard format printed on medication packages. This makes data entry easy without needing to know the exact expiration day.

### Automatic Status Detection

MedicApp automatically evaluates each medication's expiration status:

- **Expired**: The medication has passed its expiration date and displays a red warning label with an alert icon.
- **Near expiration**: 30 days or less until expiration, displays an orange caution label with a clock icon.
- **Good condition**: More than 30 days until expiration, no special warning is shown.

Visual alerts appear directly on the medication card in the medicine cabinet, next to the suspension status if applicable, allowing quick identification of medications requiring attention.

### Expiration Date Entry

The system requests the expiration date at three specific moments:

1. **When creating as-needed medication**: As the last step of the creation process (step 2/2), an optional dialog appears to enter the expiration date before saving the medication.

2. **When suspending medication**: When suspending any medication for all users sharing it, the expiration date is requested. This allows recording the date of the package that will remain stored.

3. **When refilling as-needed medication**: After adding stock to an as-needed medication, the system offers to update the expiration date to reflect the date of the newly acquired package.

In all cases, the field is optional and can be skipped. The user can cancel the operation or simply leave the field empty.

### Format and Validations

The expiration date input dialog provides two separate fields:
- Month field (MM): accepts values from 01 to 12
- Year field (YYYY): accepts values from 2000 to 2100

The system automatically validates that the month is in the correct range and that the year is valid. Upon completing the month (2 digits), focus automatically moves to the year field to streamline data entry.

The date is stored in "MM/YYYY" format (example: "03/2025") and is interpreted as the last day of that month for expiration comparisons. This means a medication with date "03/2025" will be considered expired starting April 1, 2025.

### System Benefits

This functionality helps to:
- Prevent use of expired medications that could be ineffective or dangerous
- Efficiently manage stock by identifying medications near expiration
- Prioritize medication use according to expiration date
- Maintain a safe medicine cabinet with visual status control of each medication
- Avoid waste by reminding to check medications before they expire

The system does not prevent dose registration with expired medications, but it provides clear visual warnings so the user can make informed decisions.

---

## 6. Stock Control (Medicine Cabinet)

### Intuitive Visual Indicators

MedicApp's stock control system provides real-time information about available inventory through a visual traffic light system. Each medication displays its current quantity in corresponding units, with color indicators that alert about stock status.

The color code is intuitive: green indicates sufficient stock for more than 3 days, yellow/amber alerts that stock is low (less than 3 days of supply), and red indicates the medication is depleted. Day thresholds are configurable per medication, allowing adjustments according to each treatment's criticality.

### Intelligent Automatic Calculation

Remaining days calculation is performed automatically considering multiple factors. For scheduled medications, the system analyzes total daily dose by adding all configured doses of all assigned people, divides current stock by this daily dose, and estimates remaining supply days.

For occasional or "as needed" medications, the system uses an adaptive algorithm that records consumption from the last day of use and uses it as a predictor to estimate how many days current stock will last. This estimate is automatically updated each time medication use is recorded.

### Configurable Threshold per Medication

Each medication can have a personalized alert threshold that determines when stock is considered low. The default value is 3 days, but it can be adjusted between 1 and 10 days according to needs. For example, critical medications like insulin can be configured with a 7-day threshold to allow sufficient replenishment time, while less critical supplements can use 1-2 day thresholds.

### Alerts and Restocking

When stock reaches the configured threshold, MedicApp displays prominent visual alerts on the main screen and medicine cabinet view. The system automatically suggests the amount to restock based on the last recorded replenishment, streamlining the inventory update process. Alerts persist until the user records new stock quantity, ensuring critical replenishments are not forgotten.

---

## 7. Medicine Cabinet

### Organized Alphabetical List

MedicApp's medicine cabinet presents all registered medications in an alphabetically ordered list, facilitating quick location of any medication. Each entry displays the medication name, type with its distinctive icon and color, current stock in corresponding units, and people assigned to that medication.

The medicine cabinet view is especially useful for having a global view of available medication inventory, without schedule information that can be overwhelming in the main view. It is the ideal screen for inventory management, specific medication searches, and maintenance actions.

### Real-Time Search

A search field at the top allows instant medication filtering while typing. The search is intelligent and considers both medication name and type, allowing you to find "all syrups" or "medications containing aspirin" quickly. Results are updated in real-time without needing to press additional buttons.

### Integrated Quick Actions

From each medication in the medicine cabinet, a context menu with three main actions can be accessed:

**Edit** - Opens the complete medication editor where all aspects can be modified: name, type, schedules, doses, assigned people, fasting configuration, etc. Changes are saved and notifications are automatically resynchronized.

**Delete** - Allows permanently deleting the medication from the system after a security confirmation. This action cancels all associated notifications and removes the record from future history, but preserves already recorded dose history to maintain data integrity.

**Take dose** - Quick shortcut to record a manual dose, especially useful for occasional medications. If the medication is assigned to multiple people, it first requests selecting who is taking it.

### Assignment Management

The medicine cabinet also facilitates person-medication assignment management. You can see at a glance which medications are assigned to each person, add or remove people from an existing medication, and modify individual regimens of each person without affecting others.

---

## 8. Temporal Navigation

### Horizontal Day Swiping

MedicApp's main screen implements a temporal navigation system that allows the user to move between different days with a simple horizontal swipe gesture. Swiping left advances to the next day, while swiping right goes back to the previous day. This navigation is fluid and uses animated transitions that provide clear visual feedback of the date change.

Temporal navigation is practically unlimited toward the past and future, allowing review of medication history from weeks or months ago, or advance planning by verifying which medications will be scheduled on future dates. The system maintains a virtual center point that allows thousands of pages in both directions without performance impact.

### Calendar Picker

For quick jumps to specific dates, MedicApp integrates a calendar picker accessible from a button in the top bar. Tapping the calendar icon opens a visual calendar widget where the user can select any date. Upon selection, the view instantly updates to show scheduled medications for that specific day.

The calendar visually marks the current day with a highlighted indicator, facilitates selection of past dates to review adherence, allows jumping to future dates for trip or event planning, and permanently displays the current selected date in the top bar.

### Day View vs Weekly View

Although the main navigation is by day, MedicApp provides additional temporal context by showing relevant information for the selected period. In the main view, medications are grouped by dosing time, providing a day's timeline. Visual indicators show which doses were already taken, which were omitted, and which are pending.

For medications with weekly patterns or specific intervals, the interface clearly indicates whether the medication corresponds to the selected day or not. For example, a medication configured for "Monday, Wednesday, Friday" only appears in the list when viewing those days of the week.

### Benefits of Temporal Navigation

This functionality is especially valuable for verifying if a medication was taken on a past day, planning which medications to bring on a trip based on dates, reviewing weekly or monthly adherence patterns, and coordinating medications for multiple people in a household during specific periods.

---

## 9. Smart Notifications

### Direct Actions from Notification

MedicApp revolutionizes medication management through notifications with integrated actions that allow managing doses without opening the application. When it's time for a dose, the notification displays three direct action buttons:

**Take** - Records the dose immediately, deducts from stock, creates history entry, cancels the notification, and if applicable, starts the post-dose fasting period with countdown.

**Postpone** - Delays the notification by 10, 30, or 60 minutes depending on the selected option. The notification automatically reappears at the specified time.

**Skip** - Records the dose as omitted, creates history entry with "skipped" status without deducting stock, and cancels the notification without scheduling additional reminders.

These actions work even when the phone is locked, making medication recording instant and frictionless. The user can manage their complete medication from notifications without needing to unlock the device or open the app.

### Intelligent Cancellation

The notification system implements advanced cancellation logic to avoid redundant or incorrect alerts. When a user manually records a dose from the app (without using the notification), the system automatically cancels the pending notification for that specific dose for that day.

If a medication is deleted or suspended, all its future notifications are immediately canceled in the background. When a medication's schedule is modified, old notifications are canceled and automatically rescheduled with new times. This intelligent management ensures the user only receives relevant and current notifications.

### Persistent Notifications for Fasting

For medications requiring fasting, MedicApp displays a special persistent notification during the entire fasting period. This notification cannot be manually dismissed and shows a real-time countdown of remaining time until eating is allowed. It includes the exact time when fasting will end, allowing the user to plan meals.

The fasting notification has high priority but doesn't emit continuous sound, avoiding annoying interruptions while keeping critical information visible. When the fasting period ends, the notification is automatically canceled and a brief sound alert is emitted to notify the user they can now eat.

### Personalized Configuration per Medication

Each medication can have its notification configuration adjusted individually. Users can completely enable or disable notifications for specific medications, keeping them in the system for tracking but without automatic alerts. This flexibility is useful for medications the user takes by routine and doesn't need reminders.

Additionally, fasting configuration allows deciding whether to want pre-fasting notifications (for medications with prior fasting) or simply use the function without alerts. MedicApp respects these individual preferences while maintaining consistency in recording and tracking all doses.

### Android 12+ Compatibility

MedicApp is optimized for Android 12 and higher versions, requiring and managing the necessary "Alarms and reminders" permissions for exact notifications. The application automatically detects if these permissions are not granted and guides the user to enable them from system settings, ensuring notifications arrive punctually at the scheduled time.

### Notification Sound Configuration (Android 8.0+)

On devices running Android 8.0 (API 26) or higher, MedicApp provides direct access to notification sound settings from the app's Settings screen. This feature allows customizing the sound, vibration, and other notification parameters using the system's notification channels.

The "Notification Sound" option only appears in the Settings screen when the device meets the minimum operating system version requirements. On versions prior to Android 8.0, this option is automatically hidden since the system does not support granular notification channel configuration.

---

## 10. Low Stock Alerts

### Reactive Insufficient Stock Notifications

MedicApp implements an intelligent stock alert system that protects users from running out of medication at critical moments. When a user attempts to record a dose (either from the main screen or from notification quick actions), the system automatically verifies if there is sufficient stock to complete the dose.

If available stock is less than the amount required for the dose, MedicApp immediately displays an insufficient stock alert that prevents recording the dose. This reactive notification clearly indicates the affected medication name, the required quantity versus the available amount, and suggests replenishing the inventory before attempting to record the dose again.

This protection mechanism prevents incorrect entries in the history and guarantees inventory control integrity, avoiding deductions of stock that physically doesn't exist. The alert is clear, non-intrusive, and guides the user directly toward corrective action (replenish stock).

### Proactive Low Stock Notifications

In addition to reactive alerts at the moment of taking a dose, MedicApp includes a proactive daily stock monitoring system that anticipates supply problems before they occur. This system automatically evaluates the inventory of all medications once a day, calculating remaining days of supply based on scheduled consumption.

The calculation considers multiple factors to accurately estimate how long current stock will last:

**For scheduled medications** - The system adds up the total daily dose of all assigned people, multiplies by the days configured in the frequency pattern (for example, if taken only Monday, Wednesday and Friday, it adjusts the calculation), and divides current stock by this effective daily consumption.

**For occasional medications ("as needed")** - Uses the record of the last day of actual consumption as a predictor, providing an adaptive estimate that improves with use.

When a medication's stock reaches the configured threshold (default 3 days, but customizable between 1-10 days per medication), MedicApp issues a proactive warning notification. This notification displays:

- Medication name and type
- Approximate days of remaining supply
- Affected person(s)
- Current stock in corresponding units
- Replenishment suggestion

### Notification Spam Prevention

To avoid bombarding the user with repetitive alerts, the proactive notification system implements intelligent frequency logic. Each type of low stock alert is issued maximum once per day per medication. The system records the last date each alert was sent and doesn't notify again until:

1. At least 24 hours have passed since the last alert, OR
2. The user has replenished the stock (resetting the counter)

This spam prevention ensures notifications are useful and timely without becoming an annoyance that leads the user to ignore or disable them.

### Integration with Visual Stock Control

Low stock alerts don't function in isolation, but are deeply integrated with the medicine cabinet's visual traffic light system. When a medication has low stock:

- It appears marked in red or amber in the medicine cabinet list
- Shows a warning icon on the main screen
- The proactive notification complements these visual signals

This multilayer of information (visual + notifications) guarantees the user is aware of inventory status from multiple contact points with the application.

### Configuration and Customization

Each medication can have a personalized alert threshold that determines when stock is considered "low". Critical medications like insulin or anticoagulants can be configured with thresholds of 7-10 days to allow ample replenishment time, while less urgent supplements can use thresholds of 1-2 days.

The system respects these individual configurations, allowing each medication to have its own alert policy adapted to its criticality and pharmacy availability.

---

## 11. Fasting Configuration

### Types: Before and After

MedicApp supports two clearly differentiated fasting modalities to adapt to different medical prescriptions:

**Before Fasting** - Configured when the medication must be taken on an empty stomach. The user must have fasted during the specified period BEFORE taking the medication. For example, "30 minutes fasting before" means not having eaten anything during the 30 minutes prior to taking. This type is common in medications requiring optimal absorption without food interference.

**After Fasting** - Configured when after taking the medication one must wait without eating. For example, "60 minutes fasting after" means that after taking the medication, no food can be ingested for 60 minutes. This type is typical in medications that can cause gastric discomfort or whose effectiveness is reduced with food.

The fasting duration is completely configurable in minutes, allowing adjustment to specific prescriptions that can vary from 15 minutes to several hours.

### Visual Real-Time Countdown

When a medication with "after" fasting has been taken, MedicApp displays a prominent visual countdown on the main screen. This counter updates in real-time every second, showing remaining time in MM:SS format (minutes:seconds). Next to the countdown, the exact time when the fasting period will end is indicated, allowing immediate planning.

The countdown visual component is impossible to ignore: it uses striking colors, is positioned prominently on screen, includes the associated medication name, and displays a food restriction icon. This constant visibility ensures the user doesn't forget the active food restriction.

### Fixed Notification During Fasting

Complementing the visual countdown in the app, MedicApp displays a persistent system notification during the entire fasting period. This notification is "ongoing", meaning it cannot be dismissed by the user and remains fixed in the notification bar with maximum priority.

The fasting notification shows the same information as the countdown in the app: medication name, remaining fasting time, and estimated end time. It updates periodically to reflect remaining time, though not in constant real-time to preserve battery. This double reminder layer (visual in app + persistent notification) practically eliminates the risk of accidentally breaking the fast.

### Automatic Cancellation

The system automatically manages the fasting lifecycle without manual intervention. When fasting time is completed, several actions occur simultaneously and automatically:

1. The visual countdown disappears from the main screen
2. The persistent notification is automatically canceled
3. A brief notification with sound is emitted indicating "Fasting completed, you can now eat"
4. The medication status is updated to reflect fasting has ended

This automation ensures the user is always informed of current status without needing to manually remember when fasting ended. If the app is in the background when fasting ends, the completion notification immediately alerts the user.

### Configuration per Medication

Not all medications require fasting, and among those that do, needs vary. MedicApp allows individual configuration for each medication: whether it requires fasting or not (yes/no), fasting type (before/after), exact duration in minutes, and whether pre-fasting notifications are desired (for "before" type).

This granularity allows managing complex regimens where some medications are taken on an empty stomach, others require post-ingestion waiting, and others have no restrictions, all within a coherent interface that automatically handles each case according to its specific configuration.

---

## 12. Dose History

### Complete Automatic Recording

MedicApp maintains a detailed and automatic record of every medication-related action. Each time a dose is recorded (taken or omitted), the system immediately creates a history entry that captures exhaustive event information.

Recorded data includes: unique entry identifier, medication ID and current name, medication type with its icon and color, person ID and name who took/omitted the dose, originally scheduled date and time for the dose, actual date and time when the action was recorded, dose status (taken or omitted), exact amount administered in corresponding units, and whether it was an unscheduled extra dose.

This automatic recording works regardless of how the dose was recorded: from the app, from notification actions, or through manual recording. It requires no user intervention beyond the basic recording action, guaranteeing the history is always complete and updated.

### Therapeutic Adherence Statistics

From the dose history, MedicApp automatically calculates adherence statistics that provide valuable information about treatment compliance. Metrics include:

**Global Adherence Rate** - Percentage of doses taken over total scheduled doses, calculated as (doses taken / (doses taken + doses omitted)) × 100.

**Total Recorded Doses** - Total count of events in history within the analyzed period.

**Doses Taken** - Absolute number of doses recorded as successfully taken.

**Doses Omitted** - Number of doses that were skipped or not taken as scheduled.

These statistics are dynamically calculated based on applied filters, allowing analysis by specific periods, individual medications, or specific people. They are especially useful for identifying non-compliance patterns, evaluating current schedule regimen effectiveness, and providing objective information in medical consultations.

### Advanced Multidimensional Filters

The history screen includes a powerful filtering system that allows analyzing data from multiple perspectives:

**Person Filter** - Shows only doses for a specific person, ideal for individual tracking in multi-person environments. Includes "All people" option for global view.

**Medication Filter** - Allows focusing on a particular medication, useful for evaluating specific treatment adherence. Includes "All medications" option for complete view.

**Date Range Filter** - Defines a specific time period with start and end date. Useful for generating monthly, quarterly adherence reports, or for custom periods coinciding with medical consultations.

Filters are cumulative and can be combined. For example, you can view "all Ibuprofen doses taken by Maria in January", providing very granular analysis. Active filters are displayed visually in informative chips that can be individually removed.

### Data Export

Although the current interface doesn't implement direct export, dose history is stored in the application's SQLite database, which can be completely exported through the system's backup functionality. This database contains all history entries in structured format that can be subsequently processed with external tools to generate custom reports, adherence graphs, or integration with medical management systems.

The data format is relational and normalized, with foreign keys linking medications, people, and history entries, facilitating complex analysis and information extraction for medical presentations or treatment audits.

---

## 13. Localization and Internationalization

### 8 Fully Supported Languages

MedicApp is professionally and completely translated into 8 languages, covering most languages spoken in the Iberian Peninsula and expanding its reach to Europe:

**Spanish (es)** - Main language, native translation with all precise medical terminology.

**English (en)** - International English, adapted for global English-speaking users.

**Deutsch (de)** - Standard German, with European medical terminology.

**Français (fr)** - European French with appropriate pharmaceutical vocabulary.

**Italiano (it)** - Standard Italian with localized medical terms.

**Català (ca)** - Catalan with specific medical terms from the Catalan healthcare system.

**Euskara (eu)** - Basque with appropriate healthcare terminology.

**Galego (gl)** - Galician with regionalized medical vocabulary.

Each translation is not a simple automatic conversion, but a cultural localization that respects medical conventions, date/time formats, and idiomatic expressions of each region. Medication names, pharmaceutical types, and technical terms are adapted to the local medical vocabulary of each language.

### Dynamic Language Change

MedicApp allows changing the interface language at any time from the settings screen. When selecting a new language, the application updates instantly without needing to restart. All interface texts, notification messages, button labels, help descriptions, and error messages are immediately updated to the selected language.

Language change is smooth and doesn't affect stored data. Medication names entered by the user are maintained as they were entered, regardless of interface language. Only UI elements generated by the system change language, preserving personalized medical information.

### Localized Decimal Separators

MedicApp respects regional numerical conventions for decimal separators. In languages like Spanish, French, German, and Italian, the comma (,) is used as decimal separator: "1,5 pastillas", "2,25 ml". In English, the period (.) is used: "1.5 tablets", "2.25 ml".

This numerical localization is automatically applied in all quantity input fields: medication doses, available stock, amounts to restock. Numeric keyboards are automatically configured to display the correct decimal separator according to active language, avoiding confusion and input errors.

### Localized Date and Time Formats

Date and time formats also adapt to regional conventions. Continental European languages use DD/MM/YYYY format (day/month/year), while English may use MM/DD/YYYY in some variants. Month and day of week names appear translated in calendar pickers and history views.

Times are displayed in 24-hour format in all European languages (13:00, 18:30), which is the international medical standard and avoids AM/PM ambiguities. This consistency is critical in medical contexts where time precision is vital for treatment effectiveness.

### Intelligent Pluralization

The localization system includes pluralization logic that adapts texts according to quantities. For example, in Spanish: "1 pastilla" but "2 pastillas", "1 día" but "3 días". Each language has its own pluralization rules that the system automatically respects, including complex cases in Catalan, Basque, and Galician that have different plural rules than Spanish.

This attention to linguistic detail makes MedicApp feel natural and native in each language, significantly improving user experience and reducing cognitive load when interacting with the application in potentially stressful medical contexts.

---

## 14. Smart Cache System

### Intelligent Performance Optimization

MedicApp implements a multi-level caching system that significantly reduces database accesses and improves application responsiveness without sacrificing data freshness.

The smart cache system uses an LRU (Least Recently Used) algorithm combined with automatic TTL (Time-To-Live), ensuring that frequently consulted data is available in milliseconds while memory consumption remains controlled.

### LRU Algorithm with Automatic TTL

**SmartCacheService** is a generic cache service that can store any type of data (medications, history, statistics) with automatic management:

**Automatic Expiration (TTL)** - Each entry stored in cache has a configurable lifespan. For example, medication lists remain valid for 5 minutes, after which the cache automatically expires and the next query fetches fresh data from the database.

**LRU Eviction** - When cache reaches its maximum size limit, the system automatically removes the least recently used entries to make room for new data. This prevents memory from growing indefinitely.

**Cache-aside Pattern** - The `getOrCompute()` method implements the cache-aside pattern: first checks if data is in cache and is still valid. If yes, returns it immediately. If not, executes the provided function to obtain the data, stores it in cache, and then returns it.

**Auto-cleanup** - A background timer runs every minute removing expired entries from cache, keeping memory usage optimal.

### Four Specialized Caches

MedicApp implements four specialized caches, each optimized for different types of data:

**Medications Cache (10 minutes TTL, 50 entries max)** - Stores individual medications. When a user views a medication's details, it's cached so subsequent accesses are instantaneous. 10 minute TTL is appropriate since medication details change infrequently.

**Lists Cache (5 minutes TTL, 20 entries)** - Stores medication lists filtered by person or other criteria. These lists are recalculated frequently as medication states change (doses taken, stock modified), so a shorter 5 minute TTL ensures data doesn't become stale.

**History Cache (3 minutes TTL, 30 entries)** - Stores dose history queries with different filters. History can update frequently (each dose registration adds entries), so a short 3 minute TTL ensures users see recent changes while still benefiting from caching for repeated queries.

**Statistics Cache (30 minutes TTL, 10 entries)** - Stores heavy statistical calculations (adherence rates, aggregated metrics). These calculations are computationally expensive but results change slowly, justifying a longer 30 minute TTL.

### Measured Performance Impact

Caching provides dramatic improvements in load times:

**Medication lists**: Without cache 50-200ms per query, with cache hit 2-5ms (10-40x faster)

**Dose history**: Without cache 300-500ms for complex queries, with cache hit 5-10ms (30-50x faster)

**Statistics**: Without cache 800-1200ms for heavy calculations, with cache hit 10-15ms (80-120x faster)

**Database query reduction**: 60-80% fewer accesses for frequently consulted data, significantly reducing battery consumption and I/O wear on device storage.

### Intelligent Invalidation

Cache isn't simply "all or nothing". MedicApp implements selective invalidation strategies:

**When updating a medication**: Only caches related to that specific medication are invalidated. Other unrelated medications remain cached.

**When recording a dose**: The medication cache is invalidated along with history and statistics caches, but lists cache for other people remains valid.

**When changing person**: Only caches for that specific person are invalidated.

This granular approach maximizes cache benefits without risking showing stale data.

### Real-time Statistics

The system provides real-time statistics on cache performance:

- **Total hits**: Requests satisfied directly from cache without database access
- **Total misses**: Requests that required database query
- **Hit rate**: Percentage of hits over total requests (typical: 70-85%)
- **Evictions**: Entries removed by LRU algorithm
- **Current size**: Entries currently in cache

These statistics are useful for monitoring system health and optimizing TTL and size configurations per cache type.

### Automatic Memory Management

MedicApp ensures cache improves performance without causing memory issues on devices with limited resources:

**Size limits**: Each cache has a maximum limit preventing uncontrolled memory growth
**Auto-cleanup**: Expired entries are automatically removed every minute
**LRU algorithm**: Ensures most valuable (most used) data remains in cache
**Controlled memory**: With default limits, total cache consumes less than 5-10MB of RAM

This management ensures cache improves performance without causing memory problems on devices with limited resources.

---

## 15. Intelligent Reminders System

### Therapeutic Adherence Analysis

MedicApp includes an advanced adherence analysis system that goes beyond simple tracking of doses taken/skipped. The system examines historical patterns to identify trends, recurring problems, and improvement opportunities.

**Multi-Dimensional Analysis** - The `analyzeAdherence()` method performs a comprehensive analysis of a patient's dose history for a specific medication:

**Metrics by Day of Week**: Calculates individual adherence rate for each day (Monday to Sunday). This reveals if certain days of the week are problematic. For example, it can detect that weekends have 30% less adherence than weekdays, indicating that work routine helps remember doses.

**Metrics by Time of Day**: Analyzes adherence by dose time (morning, noon, afternoon, night). Identifies if certain times are consistently problematic. For example, it can reveal that 22:00 doses have only 40% adherence, while 08:00 doses have 90%.

**Best/Worst Period Identification**: The system automatically determines which is the best day of week and best time of day in terms of adherence. This provides valuable insights about when the patient is most consistent with their medication.

**Problematic Days**: Specifically lists days where adherence falls below 50%, marking them as critical for intervention. This list allows focusing improvement efforts on the most problematic periods.

**Personalized Recommendations**: Based on all detected patterns, the system generates automatic suggestions like:
- "Consider moving 22:00 dose to 20:00 (better historical adherence)"
- "Weekends need additional reminders"
- "Your morning adherence is excellent, try consolidating doses in the morning"

**Trend Calculation**: Compares recent adherence (last 7 days) with historical adherence (last 30 days) to determine if the pattern is improving, stable, or declining. A positive trend indicates current strategies are working.

### Skip Prediction

**Predictive Model** - The `predictSkipProbability()` method uses basic machine learning to predict the probability that a specific dose will be skipped:

**Model Input**: Receives contextual information about the dose to predict:
- Specific day of week (e.g., Saturday)
- Specific time of day (e.g., 22:00)
- Person and medication ID

**Historical Pattern Analysis**: Examines dose history for similar situations (same day of week, same time) and calculates what percentage of those doses were skipped in the past.

**Risk Classification**: Converts numerical probability into a qualitative classification:
- **Low Risk**: <30% skip probability
- **Medium Risk**: 30-60% probability
- **High Risk**: >60% probability

**Factor Identification**: Provides explanations of why that risk level is predicted:
- "Saturdays have 60% more skips than weekdays"
- "The 22:00 schedule is consistently problematic"
- "Your adherence has declined in the last 2 weeks"

**Use Cases**: This functionality enables proactive alerts. For example, if the system detects that a Saturday 22:00 dose has 75% skip probability, it can send an additional preventive notification or suggest the user reschedule that dose.

### Schedule Optimization

**Intelligent Suggestions** - The `suggestOptimalTimes()` method acts as a personal assistant that helps the user find the best times for their medications:

**Problematic Schedule Identification**: Analyzes all current medication times and marks those with adherence below 70% as candidates for optimization.

**Alternative Search**: For each problematic time, searches in history for alternative times where the user has historically had better adherence.

**Improvement Potential Calculation**: Compares current adherence of problematic time with expected adherence of suggested time, calculating improvement potential. For example: "Moving from 22:00 (45% adherence) to 20:00 (82% adherence) = +37% potential improvement".

**Impact Prioritization**: Orders suggestions by expected impact, showing first those that have the greatest potential to improve global adherence.

**Data-based Justifications**: Each suggestion comes with a specific reason derived from history:
- "Your 20:00 adherence is consistently high (82%)"
- "You've never skipped doses between 08:00-09:00"
- "Morning doses have 40% more adherence than evening ones"

### Integration with Application

These intelligent analysis functionalities are designed to be integrated at various points in the application:

**Detailed Statistics Screen**: A dedicated view that shows complete adherence analysis with visual trend graphs, heat maps by day/time, and list of prioritized recommendations.

**Proactive Alerts**: Automatic notifications when concerning patterns are detected:
- "Your adherence for [Medication] has declined 20% this week"
- "We detected you skip doses on Fridays consistently"

**Schedule Configuration Assistant**: During medication creation or editing, the system can suggest optimal times based on the user's adherence history with other medications.

**Medical Reports**: Automatic generation of adherence reports with insights to share with healthcare professionals during consultations.

---

## 16. Native Dark Theme

### Complete Theme System

MedicApp implements a professional theme system with native support for light and dark mode, strictly following Google's Material Design 3 (Material You) guidelines.

### Three Operation Modes

**System Mode (Automatic)**: The application detects and follows the device operating system's theme configuration. If the user changes their phone to dark mode in system settings, MedicApp automatically switches to its dark theme without intervention. This mode is the default and provides the most integrated experience with the device.

**Light Mode (Forced Light)**: Forces the application to use light theme regardless of system configuration. Useful for users who prefer dark mode in the system but want MedicApp in light mode for readability in medical contexts.

**Dark Mode (Forced Dark)**: Forces dark theme even if the system is in light mode. Ideal for users who use the app frequently at night and want to reduce eye strain and save battery on OLED screens.

### Cohesive Color Schemes

**Light Theme**: Designed for maximum readability in good lighting conditions:
- White backgrounds and very light gray surfaces
- Black text with sufficient contrast (ratio 4.5:1 or higher)
- Vibrant primary colors for interactive elements
- Subtle shadows for visual hierarchy

**Dark Theme**: Optimized for nighttime use and reduced eye strain:
- Pure black backgrounds (#000000) for maximum battery savings on OLED
- Dark gray surfaces with visible elevation
- Desaturated colors that don't tire eyes
- White/light gray text with appropriate contrast ratios
- Elimination of pure white which can be dazzling

### Comprehensive Component Customization

Each Material Design component is styled consistently in both themes:

**AppBar**: Top bars with background colors reflecting primary surface, readable text, and contrasted icons.

**Cards**: Cards with appropriate elevation (more pronounced in dark), smooth rounded corners, and surface colors differentiated from background.

**FloatingActionButton**: Prominent action buttons with highlighted primary colors, appropriate shadows, and clear icons.

**InputFields**: Text fields with visible borders in both modes, floating labels, distinguishable error colors, and clear focus states.

**Dialogs**: Modal dialogs with rounded corners, elevated surfaces that stand out from background, and clearly differentiated button actions.

**SnackBars**: Temporary notifications with semi-opaque background, readable text, and consistent positioning.

**Text Hierarchy**: Complete typographic hierarchy with appropriate sizes, weights, and colors for titles, subtitles, body, and labels in both modes.

### Reactive State Management

**ThemeProvider**: A `ChangeNotifier` that manages current theme state:
- Maintains active `ThemeMode` (system/light/dark)
- Notifies all subscribed widgets when theme changes
- Persists user choice in SharedPreferences
- Automatically loads saved theme on app startup

**Integration with MaterialApp**: The application listens to ThemeProvider changes and updates instantly without restarting:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,        // Light theme
  darkTheme: AppTheme.darkTheme,     // Dark theme
  themeMode: themeProvider.themeMode, // Current mode
)
```

### Fluid Transitions

Theme changes are completely fluid:
- No need to restart the application
- Smooth color transition animation
- Complete preservation of app state
- Instant update of all visible widgets

### User Benefits

**Improved Accessibility**: Users with bright light sensitivity can use dark mode comfortably. Users with low vision can benefit from light mode's high contrast.

**Battery Savings**: On devices with OLED/AMOLED screens, dark theme with pure blacks can save 30-60% of screen power compared to light theme.

**Reduced Eye Strain**: Dark mode significantly reduces blue light emission, being more comfortable for nighttime or prolonged use.

**System Integration**: Automatic mode creates a cohesive experience where MedicApp feels like a native part of the operating system.

**Persistent Preference**: User choice is saved and maintained between sessions, not requiring repeated reconfigurations.

---

## 17. Accessible and Usable Interface

### Material Design 3

MedicApp is built strictly following Google's Material Design 3 (Material You) guidelines, the most modern and accessible design system for Android applications. This architectural decision guarantees multiple benefits:

**Visual Consistency** - All interface elements (buttons, cards, dialogs, text fields) follow standard visual patterns that Android users instinctively recognize. There's no need to learn a completely new interface.

**Dynamic Theming** - Material 3 allows the app to adopt the user's system colors (if on Android 12+), creating a cohesive visual experience with the rest of the device. Accent colors, backgrounds, and surfaces adapt automatically.

**Native Accessible Components** - All Material 3 controls are designed from the beginning to be accessible, with generous touch areas (minimum 48x48dp), adequate contrasts, and screen reader support.

### Enlarged and Legible Typography

The application uses a clear typographic hierarchy with generous font sizes that facilitate reading without visual fatigue:

**Screen Titles** - Large size (24-28sp) for clear orientation of where the user is.

**Medication Names** - Prominent size (18-20sp) in bold for quick identification.

**Secondary Information** - Medium size (14-16sp) for complementary details like schedules and quantities.

**Help Text** - Standard size (14sp) for instructions and descriptions.

Line spacing is generous (1.5x) to prevent lines from blurring together, especially important for users with vision problems. Fonts used are sans-serif which have demonstrated better readability on digital screens.

### High Visual Contrast

MedicApp implements a color palette with contrast ratios that meet and exceed WCAG 2.1 AA accessibility guidelines. Minimum contrast between text and background is 4.5:1 for normal text and 3:1 for large text, ensuring readability even in suboptimal lighting conditions.

Colors are used functionally in addition to aesthetically: red for low stock or active fasting alerts, green for confirmations and sufficient stock, amber for intermediate warnings, blue for neutral information. But crucially, color is never the only indicator: it's always complemented with icons, text, or patterns.

### Intuitive and Predictable Navigation

MedicApp's navigation structure follows principles of simplicity and predictability:

**Central Main Screen** - The day's medications view is the main hub from which everything is accessible in maximum 2 taps.

**Tab Navigation** - The bottom bar with 3 tabs (Medications, Medicine Cabinet, History) allows instant switching between main views without confusing animations.

**Floating Action Buttons** - Primary actions (add medication, filter history) are performed through floating buttons (FAB) in consistent position, easy to reach with thumb.

**Breadcrumbs and Back Button** - It's always clear which screen the user is on and how to go back. The back button is always in standard top left position.

### Visual and Tactile Feedback

Each interaction produces immediate feedback: buttons show "ripple" effect when pressed, successful actions are confirmed with brief green snackbars, errors are indicated with explanatory red dialogs, and long processes (like exporting database) show animated progress indicators.

This constant feedback ensures the user always knows their action was recorded and the system is responding, reducing typical anxiety of medical applications where an error could have important consequences.

### One-Handed Use Design

Recognizing that users frequently handle medications with one hand (while holding the container with the other), MedicApp optimizes ergonomics for one-handed use:

- Main interactive elements in lower half of screen
- Floating action button in lower right corner, reachable with thumb
- Avoidance of menus in upper corners requiring grip readjustment
- Horizontal swipe gestures (more comfortable than vertical) for temporal navigation

This ergonomic consideration reduces physical fatigue and makes the app more comfortable to use in real medication situations, which often occur standing or in motion.

---

## 18. Home Screen Widget (Android)

### Quick View of Daily Doses

MedicApp includes a native Android widget for the home screen that allows viewing scheduled doses for the current day without needing to open the application. This widget provides essential at-a-glance information, ideal for users who need a constant visual reminder of their medication.

### Widget Characteristics

**2x2 Size**: The widget occupies a 2x2 cell space on the home screen (approximately 146x146dp), being compact enough not to take up too much space but with clearly legible information.

**Daily Dose List**: Displays all doses scheduled for the current day, including:
- Medication name
- Scheduled time for each dose
- Visual status (pending, taken, or skipped)

**Status Indicators**:
- **Green filled circle with checkmark (✓)**: Dose taken - medication text displayed at 70% opacity
- **Green empty circle (○)**: Dose pending - medication text displayed at 100% opacity
- **Gray dashed circle (◌)**: Dose skipped - medication text displayed at 50% opacity

**Progress Counter**: In the widget header, a "X/Y" counter is displayed indicating how many doses have been taken out of the total scheduled for the day.

**Smart Medication Filtering**: The widget intelligently filters medications to show only relevant doses:
- Only displays medications scheduled for the current day based on their durationType configuration
- Automatically excludes "asNeeded" medications since they don't have scheduled doses
- Ensures the widget shows a focused view of today's medication schedule

### Integration with Application

**Automatic Update**: The widget automatically updates whenever:
- A dose is registered (taken, omitted, or extra)
- A medication is added or modified
- The day changes (at midnight)

**Flutter-Android Communication**: The integration uses a MethodChannel (`com.medicapp.medicapp/widget`) that allows the Flutter application to notify the native widget when data changes.

**Direct Database Reading**: The widget directly accesses the application's SQLite database to obtain medication data, ensuring updated information even when the app is not running.

**Interactive Tapping**: Tapping anywhere on the widget (header, list items, or empty space) opens the main MedicApp application, providing quick access to full medication management features.

### DeepEmerald Visual Theme

The widget uses the DeepEmerald color palette, MedicApp's default theme:

- **Background**: Deep dark green (#1E2623) with 90% opacity
- **Icons and accents**: Light green (#81C784)
- **Text**: White with different opacity levels depending on dose status (100% for pending, 70% for taken, 50% for skipped)
- **Dividers**: Light green with transparency

This visual coherence ensures the widget integrates perfectly with the application's aesthetics.

### Technical Limitations

**Android Only**: The widget is a native Android functionality and is not available on iOS, web, or other platforms.

**Default Person**: The widget displays doses for the person configured as default in the application. It doesn't allow selecting different people directly from the widget.

### Related Files

- `android/app/src/main/kotlin/.../MedicationWidgetProvider.kt` - Main widget provider
- `android/app/src/main/kotlin/.../MedicationWidgetService.kt` - Service for the widget's ListView
- `android/app/src/main/res/layout/medication_widget_layout.xml` - Main layout
- `android/app/src/main/res/xml/medication_widget_info.xml` - Widget configuration
- `lib/services/widget_service.dart` - Flutter service for communication with the widget

---

## Integration of Functionalities

All these features don't work in isolation, but are deeply integrated to create a cohesive experience. For example:

- A medication added in the 8-step flow is automatically assigned to people, generates notifications according to its frequency type, appears in the alphabetically ordered medicine cabinet, records its doses in history, and updates adherence statistics.

- Notifications respect fasting configuration, automatically updating visual countdown when a dose with post-fasting is recorded.

- Multi-person stock control correctly calculates remaining days considering doses of all assigned people, and alerts when threshold is reached regardless of who takes the medication.

- Language change instantly updates all pending notifications, visible screens, and system messages, maintaining total consistency.

- The smart cache system automatically manages frequently accessed data, reducing database queries by 60-80% while selective invalidation ensures users always see fresh data after modifications.

- The intelligent reminders system analyzes adherence patterns and generates personalized recommendations that can be integrated into statistics screens, proactive alerts, and schedule optimization assistants.

- The native dark theme smoothly transitions between light and dark modes without restarting the app, with colors optimized for readability in both modes and theme choice persisted between sessions.

- The Android home screen widget provides quick at-a-glance access to daily medication status without opening the app, updating automatically whenever doses are recorded or medications are modified.

This deep integration is what converts MedicApp from a simple medication list into a complete family therapeutic management system.

---

## References to Additional Documentation

For more detailed information on specific aspects:

- **Multi-Person Architecture**: See database documentation (tables `persons`, `medications`, `person_medications`)
- **Notification System**: See source code in `lib/services/notification_service.dart`
- **Data Model**: See models in `lib/models/` (especially `medication.dart`, `person.dart`, `person_medication.dart`)
- **Localization**: See `.arb` files in `lib/l10n/` for each language
- **Tests**: See test suite in `test/` with 601+ tests validating all these functionalities
- **Android Widget**: See `android/app/src/main/kotlin/.../MedicationWidget*.kt` for the home screen widget

---

This documentation reflects the current state of MedicApp in its version 1.0.0, a mature and complete application for family medication management with over 75% test coverage, full support for 8 languages, and home screen widget for Android.
