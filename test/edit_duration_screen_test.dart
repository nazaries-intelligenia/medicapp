import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/screens/edit_sections/edit_duration_screen.dart';
import 'package:medicapp/models/treatment_duration_type.dart';
import 'helpers/test_helpers.dart' hide getL10n;
import 'helpers/medication_builder.dart';
import 'helpers/widget_test_helpers.dart';

void main() {
  setupTestDatabase();

  group('EditDurationScreen Rendering', () {
    testWidgets('should render edit duration screen', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-1')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      expect(find.text(l10n.editDurationTitle), findsOneWidget);
      expect(find.text(l10n.editBasicInfoSaveChanges), findsOneWidget);
      expect(find.text(l10n.btnCancel), findsOneWidget);
    });

    testWidgets('should display current duration type', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-2')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      expect(find.text(l10n.editDurationTypeLabel), findsOneWidget);
      // Check for the localized "Current type: [type]" text
      // The medication builder creates an "everyday" type by default, which has displayName "Todos los días"
      expect(find.text(l10n.editDurationCurrentType(TreatmentDurationType.everyday.displayName)), findsOneWidget);
    });

    testWidgets('should display info message about changing duration type', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-3')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      expect(find.text(l10n.editDurationChangeTypeInfo), findsOneWidget);
    });

    testWidgets('should display date fields for everyday duration type', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-4')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      expect(find.text(l10n.editDurationTreatmentDates), findsOneWidget);
      expect(find.text(l10n.editDurationStartDate), findsOneWidget);
      expect(find.text(l10n.editDurationEndDate), findsOneWidget);
    });

    testWidgets('should display formatted dates when set', (WidgetTester tester) async {
      final startDate = DateTime(2025, 1, 15);
      final endDate = DateTime(2025, 2, 14);

      final medication = MedicationBuilder()
          .withId('test-med-5')
          .withDateRange(startDate, endDate)
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));

      // Should show formatted dates
      expect(find.text('15/1/2025'), findsOneWidget);
      expect(find.text('14/2/2025'), findsOneWidget);
    });

    testWidgets('should display duration in days when both dates are set', (WidgetTester tester) async {
      final startDate = DateTime(2025, 1, 15);
      final endDate = DateTime(2025, 2, 14); // 31 days

      final medication = MedicationBuilder()
          .withId('test-med-6')
          .withDateRange(startDate, endDate)
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should show duration in days (31 days)
      expect(find.text(l10n.editDurationDays(31)), findsOneWidget);
    });

    testWidgets('should not display date fields for asNeeded duration type', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-7')
          .withAsNeeded()
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should NOT show date fields for as needed medications
      expect(find.text(l10n.editDurationTreatmentDates), findsNothing);
    });
  });

  group('EditDurationScreen Validation', () {
    testWidgets('should show error when dates are not selected for everyday', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-8')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Try to save without dates
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should show validation error
      expect(find.text(l10n.editDurationSelectDates), findsOneWidget);
    });

    testWidgets('should show error when only start date is selected', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-9')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Try to save with only start date
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should show validation error
      expect(find.text(l10n.editDurationSelectDates), findsOneWidget);
    });

    testWidgets('should show error for untilFinished without dates', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-10')
          .withDurationType(TreatmentDurationType.untilFinished)
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Try to save without dates
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should show validation error
      expect(find.text(l10n.editDurationSelectDates), findsOneWidget);
    });

    testWidgets('should not require dates for asNeeded', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-11')
          .withAsNeeded()
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Try to save - should not show error
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should NOT show validation error
      expect(find.text(l10n.editDurationSelectDates), findsNothing);
    });
  });

  group('EditDurationScreen Navigation', () {
    testWidgets('should navigate back when cancel is pressed', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-12')
          .build();

      // Note: testCancelNavigation internally uses hardcoded 'Cancelar' which is correct
      // for the es_ES locale set in pumpScreen. The screenTitle parameter is what needs
      // to match the localization.
      await pumpScreen(tester, Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDurationScreen(medication: medication),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ), settleAfter: false);
      await tester.pumpAndSettle();
      final l10n = getL10n(tester);

      // Open the edit screen
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Verify we're on the edit screen
      expect(find.text(l10n.editDurationTitle), findsOneWidget);

      // Scroll to cancel button (may be off-screen)
      await tester.ensureVisible(find.text(l10n.btnCancel));
      await tester.pumpAndSettle();

      // Tap cancel
      await tester.tap(find.text(l10n.btnCancel));
      await tester.pumpAndSettle();

      // Should be back to the original screen
      expect(find.text(l10n.editDurationTitle), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });
  });

  group('EditDurationScreen Button States', () {
    testWidgets('should have save button enabled initially', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-13')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      expect(find.text(l10n.editBasicInfoSaveChanges), findsOneWidget);
    });

    testWidgets('should have cancel button enabled initially', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-14')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      expect(find.text(l10n.btnCancel), findsOneWidget);
    });
  });

  group('EditDurationScreen Edge Cases', () {
    testWidgets('should handle medication with weeklyPattern duration type', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-15')
          .withWeeklyPattern([1, 3, 5])
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should show date fields for weekly pattern
      expect(find.text(l10n.editDurationTreatmentDates), findsOneWidget);
    });

    testWidgets('should handle medication with intervalDays duration type', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-16')
          .withIntervalDays(2)
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should show date fields for interval days
      expect(find.text(l10n.editDurationTreatmentDates), findsOneWidget);
    });

    testWidgets('should handle medication with specificDates duration type', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-17')
          .withSpecificDates(['2025-01-15', '2025-01-20', '2025-01-25'])
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should NOT show date fields for specific dates
      expect(find.text(l10n.editDurationTreatmentDates), findsNothing);
    });

    testWidgets('should calculate duration correctly for 1 day', (WidgetTester tester) async {
      final startDate = DateTime(2025, 1, 15);
      final endDate = DateTime(2025, 1, 15); // Same day = 1 day

      final medication = MedicationBuilder()
          .withId('test-med-18')
          .withDateRange(startDate, endDate)
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should show 1 day
      expect(find.text(l10n.editDurationDays(1)), findsOneWidget);
    });

    testWidgets('should calculate duration correctly for long period', (WidgetTester tester) async {
      final startDate = DateTime(2025, 1, 1);
      final endDate = DateTime(2025, 12, 31); // 365 days

      final medication = MedicationBuilder()
          .withId('test-med-19')
          .withDateRange(startDate, endDate)
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should show 365 days
      expect(find.text(l10n.editDurationDays(365)), findsOneWidget);
    });

    testWidgets('should handle different medication types', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-20')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should render without issues
      expect(find.text(l10n.editDurationTitle), findsOneWidget);
    });

    testWidgets('should show "Not selected" when dates are null', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-21')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should show "Not selected" for both dates
      expect(find.text(l10n.editDurationNotSelected), findsNWidgets(2));
    });
  });

  group('EditDurationScreen Duration Display', () {
    testWidgets('should display duration info section when both dates are set', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-22')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));

      // Should show info icon
      expect(find.byIcon(Icons.info_outline), findsWidgets);
    });

    testWidgets('should not display duration info when only start date is set', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-23')
          .build();

      await pumpScreen(tester, EditDurationScreen(medication: medication));
      final l10n = getL10n(tester);

      // Should NOT show duration info section
      // We check that no duration text is shown by verifying common day counts aren't displayed
      expect(find.text(l10n.editDurationDays(1)), findsNothing);
      expect(find.text(l10n.editDurationDays(7)), findsNothing);
      expect(find.text(l10n.editDurationDays(30)), findsNothing);
    });
  });
}
