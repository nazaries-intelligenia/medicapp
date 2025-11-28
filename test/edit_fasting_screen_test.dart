import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/screens/edit_sections/edit_fasting_screen.dart';
import 'package:medicapp/models/medication_type.dart';
import 'helpers/test_helpers.dart' hide getL10n;
import 'helpers/medication_builder.dart';
import 'helpers/widget_test_helpers.dart';

void main() {
  setupTestDatabase();

  group('EditFastingScreen Rendering', () {
    testWidgets('should render edit fasting screen', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-1')
          .withFastingDisabled()
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      final l10n = getL10n(tester);
      expect(find.text(l10n.editFastingTitle), findsOneWidget);
      expectSaveButtonExists();
      expectCancelButtonExists();
    });

    testWidgets('should display fasting configuration form', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-2')
          .withFasting(type: 'before', duration: 60)
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // Should render the fasting configuration form
      final l10n = getL10n(tester);
      expect(find.text(l10n.requiresFastingQuestion), findsOneWidget);
    });

    testWidgets('should initialize with no fasting', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-3')
          .withFastingDisabled()
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // "No" button should be selected (has radio_button_checked icon)
      final l10n = getL10n(tester);
      expect(find.text(l10n.noText), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    });

    testWidgets('should initialize with existing fasting configuration', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-4')
          .withFasting(type: 'after', duration: 90) // 1 hour 30 minutes
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // "Yes" button should be selected
      final l10n = getL10n(tester);
      expect(find.text(l10n.yesText), findsOneWidget);

      // Should show duration fields with correct values (1 hour, 30 minutes)
      expect(find.text('1'), findsWidgets); // Hour field
      expect(find.text('30'), findsOneWidget); // Minutes field
    });
  });

  group('EditFastingScreen Validation', () {
    testWidgets('should allow saving when fasting is disabled', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-5')
          .withFastingDisabled()
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // Tap save - should not show validation errors
      final l10n = getL10n(tester);
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // No validation error should appear
      expect(find.text(l10n.editFastingSelectWhen), findsNothing);
      expect(find.text(l10n.editFastingMinDuration), findsNothing);
    });

    testWidgets('should show error when fasting type is not selected', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-6')
          .withFastingDisabled()
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      final l10n = getL10n(tester);
      // Enable fasting by tapping "Yes" button
      await tester.tap(find.text(l10n.yesText));
      await tester.pumpAndSettle();

      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Try to save without selecting fasting type
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should show validation error
      expect(find.text(l10n.editFastingSelectWhen), findsOneWidget);
    });

    testWidgets('should show error when duration is zero', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-7')
          .withFasting(type: 'before', duration: 0)
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      final l10n = getL10n(tester);
      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Try to save with zero duration
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should show validation error
      expect(find.text(l10n.editFastingMinDuration), findsOneWidget);
    });

    testWidgets('should show error when hours and minutes are both empty', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-8')
          .withFasting(type: 'after', duration: 60)
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      final l10n = getL10n(tester);
      // Clear hour and minute fields
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '0'); // Hours
      await tester.enterText(textFields.at(1), '0'); // Minutes
      await tester.pump();

      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Try to save
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should show validation error
      expect(find.text(l10n.editFastingMinDuration), findsOneWidget);
    });

    testWidgets('should accept minimum valid duration (1 minute)', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-9')
          .withFasting(type: 'before', duration: 60)
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      final l10n = getL10n(tester);
      // Set minimum duration (0 hours, 1 minute)
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '0'); // Hours
      await tester.enterText(textFields.at(1), '1'); // Minutes
      await tester.pump();

      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Try to save
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should NOT show validation error
      expect(find.text(l10n.editFastingMinDuration), findsNothing);
    });
  });

  group('EditFastingScreen Navigation', () {
    testWidgets('should navigate back when cancel is pressed', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-10')
          .withFastingDisabled()
          .build();

      // Need to pump the widget first to get l10n
      await pumpScreen(tester, EditFastingScreen(medication: medication));
      final l10n = getL10n(tester);

      // Now we can use the localized screen title
      await testCancelNavigation(
        tester,
        screenTitle: l10n.editFastingTitle,
        screenBuilder: (context) => EditFastingScreen(medication: medication),
      );
    });
  });

  group('EditFastingScreen Button States', () {
    testWidgets('should have save button enabled initially', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-11')
          .withFastingDisabled()
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      expectSaveButtonExists();
    });

    testWidgets('should have cancel button enabled initially', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-12')
          .withFastingDisabled()
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      expectCancelButtonExists();
    });
  });

  group('EditFastingScreen Edge Cases', () {
    testWidgets('should handle medication with long fasting duration', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-13')
          .withFasting(type: 'before', duration: 480) // 8 hours
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // Should display 8 hours, 0 minutes
      expect(find.text('8'), findsWidgets); // Hour field
      expect(find.text('0'), findsWidgets); // Minutes field
    });

    testWidgets('should handle medication with only minutes', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-14')
          .withFasting(type: 'after', duration: 45, notify: false) // 0 hours, 45 minutes
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // Should display 0 hours, 45 minutes
      expect(find.text('0'), findsWidgets); // Hour field
      expect(find.text('45'), findsOneWidget); // Minutes field
    });

    testWidgets('should handle different medication types', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-15')
          .withType(MedicationType.syrup)
          .withFasting(type: 'before', duration: 30)
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // Should render without issues
      final l10n = getL10n(tester);
      expect(find.text(l10n.editFastingTitle), findsOneWidget);
    });

    testWidgets('should handle null fasting configuration', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-16')
          .withFastingDisabled()
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // Should render with default values (0 hours, 0 minutes)
      final l10n = getL10n(tester);
      expect(find.text(l10n.editFastingTitle), findsOneWidget);
    });

    testWidgets('should handle complex time combinations', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-17')
          .withFasting(type: 'before', duration: 125) // 2 hours, 5 minutes
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      // Should display 2 hours, 5 minutes
      expect(find.text('2'), findsWidgets); // Hour field
      expect(find.text('5'), findsWidgets); // Minutes field
    });
  });

  group('EditFastingScreen State Management', () {
    testWidgets('should reset fasting configuration when switching off requiresFasting', (WidgetTester tester) async {
      final medication = MedicationBuilder()
          .withId('test-med-18')
          .withFasting(type: 'before', duration: 60)
          .build();

      await pumpScreen(tester, EditFastingScreen(medication: medication));

      final l10n = getL10n(tester);
      // "Yes" button should be selected initially
      expect(find.text(l10n.yesText), findsOneWidget);

      // Turn off fasting by tapping "No" button
      await tester.tap(find.text(l10n.noText));
      await tester.pumpAndSettle();

      // Scroll to save button
      await tester.ensureVisible(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pumpAndSettle();

      // Now try to save - should not require validation
      await tester.tap(find.text(l10n.editBasicInfoSaveChanges));
      await tester.pump();

      // Should NOT show validation errors
      expect(find.text(l10n.editFastingSelectWhen), findsNothing);
    });
  });
}
