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

## 5. Stock Control (Medicine Cabinet)

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

## 6. Medicine Cabinet

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

## 7. Temporal Navigation

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

## 8. Smart Notifications

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

---

## 9. Fasting Configuration

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

## 10. Dose History

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

## 11. Localization and Internationalization

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

## 12. Accessible and Usable Interface

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

## Integration of Functionalities

All these features don't work in isolation, but are deeply integrated to create a cohesive experience. For example:

- A medication added in the 8-step flow is automatically assigned to people, generates notifications according to its frequency type, appears in the alphabetically ordered medicine cabinet, records its doses in history, and updates adherence statistics.

- Notifications respect fasting configuration, automatically updating visual countdown when a dose with post-fasting is recorded.

- Multi-person stock control correctly calculates remaining days considering doses of all assigned people, and alerts when threshold is reached regardless of who takes the medication.

- Language change instantly updates all pending notifications, visible screens, and system messages, maintaining total consistency.

This deep integration is what converts MedicApp from a simple medication list into a complete family therapeutic management system.

---

## References to Additional Documentation

For more detailed information on specific aspects:

- **Multi-Person Architecture**: See database documentation (tables `persons`, `medications`, `person_medications`)
- **Notification System**: See source code in `lib/services/notification_service.dart`
- **Data Model**: See models in `lib/models/` (especially `medication.dart`, `person.dart`, `person_medication.dart`)
- **Localization**: See `.arb` files in `lib/l10n/` for each language
- **Tests**: See test suite in `test/` with 432+ tests validating all these functionalities

---

This documentation reflects the current state of MedicApp in its version 1.0.0, a mature and complete application for family medication management with over 75% test coverage and full support for 8 languages.
