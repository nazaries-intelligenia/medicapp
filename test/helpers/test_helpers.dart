import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import 'package:medicapp/l10n/app_localizations_es.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/models/medication_type.dart';
import 'package:medicapp/models/treatment_duration_type.dart';
import 'package:medicapp/services/localization_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Common setup to initialize SQLite and LocalizationService in tests
void setupTestDatabase() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // Initialize LocalizationService with Spanish for tests
    await LocalizationService.instance.setLocale(const Locale('es'));
  });
}

/// Factory to create test medications with default values
/// @deprecated Use MedicationBuilder instead
@Deprecated('Usar MedicationBuilder en su lugar')
Medication createTestMedication({
  String? id,
  String? name,
  MedicationType? type,
  int? dosageIntervalHours,
  TreatmentDurationType? durationType,
  Map<String, double>? doseSchedule,
  double? stockQuantity,
  int? lowStockThresholdDays,
  DateTime? startDate,
  DateTime? endDate,
  List<String>? selectedDates,
  List<int>? weeklyDays,
  int? dayInterval,
  bool? requiresFasting,
  String? fastingType,
  int? fastingDurationMinutes,
  bool? notifyFasting,
}) {
  return Medication(
    id: id ?? 'test-med-${DateTime.now().millisecondsSinceEpoch}',
    name: name ?? 'Test Medicine',
    type: type ?? MedicationType.pill,
    dosageIntervalHours: dosageIntervalHours ?? 8,
    durationType: durationType ?? TreatmentDurationType.everyday,
    doseSchedule: doseSchedule ?? {'08:00': 1.0},
    stockQuantity: stockQuantity ?? 20.0,
    lowStockThresholdDays: lowStockThresholdDays ?? 3,
    startDate: startDate, // No default - tests must pass startDate explicitly if needed
    endDate: endDate,
    selectedDates: selectedDates,
    weeklyDays: weeklyDays,
    dayInterval: dayInterval,
    requiresFasting: requiresFasting ?? false,
    fastingType: fastingType,
    fastingDurationMinutes: fastingDurationMinutes,
    notifyFasting: notifyFasting ?? false,
  );
}

// ============================================================================
// DATE HELPERS
// ============================================================================

/// Gets today's date in 'YYYY-MM-DD' format.
String getTodayString() {
  final now = DateTime.now();
  return formatDate(now);
}

/// Gets yesterday's date in 'YYYY-MM-DD' format.
String getYesterdayString() {
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return formatDate(yesterday);
}

/// Gets tomorrow's date in 'YYYY-MM-DD' format.
String getTomorrowString() {
  final tomorrow = DateTime.now().add(const Duration(days: 1));
  return formatDate(tomorrow);
}

/// Formats a date to string in 'YYYY-MM-DD' format.
String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Creates a date for today at a specific time.
DateTime todayAt(int hour, int minute) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, hour, minute);
}

/// Checks if two dates are the same day.
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

/// Checks if a date is today.
bool isToday(DateTime date) {
  return isSameDay(date, DateTime.now());
}

/// Creates a date X days in the past.
DateTime daysAgo(int days) {
  return DateTime.now().subtract(Duration(days: days));
}

/// Creates a date X days in the future.
DateTime daysFromNow(int days) {
  return DateTime.now().add(Duration(days: days));
}

// ============================================================================
// NOTIFICATION HELPERS
// ============================================================================

/// Generates a unique ID for notifications (simulates service logic).
int generateNotificationId(String medicationId, int doseIndex) {
  final medicationHash = medicationId.hashCode.abs();
  return (medicationHash % 1000000) * 100 + doseIndex;
}

/// Generates a notification ID for a specific date.
int generateSpecificDateNotificationId(String medicationId, String dateString, int doseIndex) {
  final combinedString = '$medicationId-$dateString-$doseIndex';
  final hash = combinedString.hashCode.abs();
  return 3000000 + (hash % 1000000);
}

/// Generates a notification ID for weekly pattern.
int generateWeeklyNotificationId(String medicationId, int weekday, int doseIndex) {
  final combinedString = '$medicationId-weekday$weekday-$doseIndex';
  final hash = combinedString.hashCode.abs();
  return 4000000 + (hash % 1000000);
}

/// Generates a postponed notification ID.
int generatePostponedNotificationId(String medicationId, String doseTime) {
  final combinedString = '$medicationId-$doseTime';
  final hash = combinedString.hashCode.abs();
  return 2000000 + (hash % 1000000);
}

// ============================================================================
// TIME FORMATTING HELPERS
// ============================================================================

/// Formats a time in 'HH:MM' format.
String formatTime(int hour, [int minute = 0]) {
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Calculates a relative hour (e.g. 2 hours ago, 3 hours ahead).
/// Returns the value in 24-hour format (0-23).
/// Correctly handles negative values and midnight crossings.
int calculateRelativeHour(int currentHour, int delta) {
  int result = (currentHour + delta) % 24;
  // In Dart, the modulo of negative numbers returns negative values
  // E.g. -1 % 24 = -1, not 23. We need to correct this.
  if (result < 0) {
    result += 24;
  }
  return result;
}

/// Combined helper: calculates relative hour and formats it.
String formatRelativeTime(int currentHour, int hoursDelta, [int minute = 0]) {
  final hour = calculateRelativeHour(currentHour, hoursDelta);
  return formatTime(hour, minute);
}

// ============================================================================
// UI/WIDGET HELPERS
// ============================================================================

/// Helper to wrap a widget in MaterialApp and pump it
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  bool settleAfter = true,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es', 'ES'),
      home: screen,
    ),
  );

  if (settleAfter) {
    await tester.pumpAndSettle();
  }
}

/// Helper to test navigation with cancel button
///
/// This helper verifies:
/// 1. That the screen can be opened from a button
/// 2. That the screen title is correct
/// 3. That the cancel button navigates back
Future<void> testCancelNavigation(
  WidgetTester tester, {
  required String screenTitle,
  required Widget Function(BuildContext) screenBuilder,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es', 'ES'),
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: screenBuilder,
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ),
  );

  // Open the edit screen
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();

  // Verify we're on the edit screen
  expect(find.text(screenTitle), findsOneWidget);

  // Scroll to cancel button (may be off-screen)
  final l10n = getL10n();
  await tester.ensureVisible(find.text(l10n.btnCancel));
  await tester.pumpAndSettle();

  // Tap cancel
  await tester.tap(find.text(l10n.btnCancel));
  await tester.pumpAndSettle();

  // Should be back to the original screen
  expect(find.text(screenTitle), findsNothing);
  expect(find.text('Open'), findsOneWidget);
}

/// Helper to verify that the save button exists
void expectSaveButtonExists() {
  final l10n = getL10n();
  expect(find.text(l10n.editBasicInfoSaveChanges), findsOneWidget);
}

/// Helper to verify that the cancel button exists
void expectCancelButtonExists() {
  final l10n = getL10n();
  expect(find.text(l10n.btnCancel), findsOneWidget);
}

/// Helper to scroll to an element and tap it
Future<void> scrollAndTap(
  WidgetTester tester,
  Finder finder, {
  bool settle = true,
}) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);

  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Helper to verify that a validation error is shown
void expectValidationError(String errorMessage) {
  expect(find.text(errorMessage), findsOneWidget);
}

/// Helper to verify that a validation error is NOT shown
void expectNoValidationError(String errorMessage) {
  expect(find.text(errorMessage), findsNothing);
}

/// Helper to get localized strings for tests
/// Returns Spanish localization (es_ES) used in tests
AppLocalizations getL10n() {
  return AppLocalizationsEs();
}
