import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:medicapp/main.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/services/notification_service.dart';
import '../helpers/widget_test_helpers.dart';
import '../helpers/database_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DatabaseTestHelper.setupAll();

  // Clean up database before each test to ensure test isolation
  setUp(() async {
    // Set larger window size for accessibility tests (larger fonts and buttons)
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.implicitView!.physicalSize = const Size(1200, 1800);
    binding.platformDispatcher.implicitView!.devicePixelRatio = 1.0;

    // Mock SharedPreferences to avoid plugin errors in tests
    SharedPreferences.setMockInitialValues({});

    // Close and reset the database to get a fresh in-memory instance
    await DatabaseHelper.resetDatabase();
    // Enable in-memory mode for this test
    DatabaseHelper.setInMemoryDatabase(true);
    // Enable test mode for notifications (disables actual notifications)
    NotificationService.instance.enableTestMode();
    // Ensure default person exists (V19+ requirement) BEFORE starting the app
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  // Clean up after each test
  tearDown(() {
    // Reset window size to default
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.implicitView!.resetPhysicalSize();
    binding.platformDispatcher.implicitView!.resetDevicePixelRatio();
  });

  testWidgets('Should open modal when tapping a medication', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MedicApp());
    await waitForDatabase(tester);

    // Add a medication first
    await addMedicationWithDuration(tester, 'Aspirin');
    await waitForDatabase(tester);

    // Tap on the medication card
    await tester.tap(find.text('Aspirin'));
    await tester.pumpAndSettle();

    // Verify modal is shown
    expect(find.text(getL10n(tester).medicineCabinetDeleteMedication), findsWidgets);
    expect(find.text(getL10n(tester).medicineCabinetEditMedication), findsWidgets);
    expect(find.text(getL10n(tester).btnCancel), findsWidgets);
    // The medication name should appear twice: once in the list and once in the modal
    expect(find.text('Aspirin'), findsNWidgets(2));
  });

  testWidgets('Modal should display treatment duration', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MedicApp());
    await waitForDatabase(tester);

    // Add a medication with "Until finished" duration
    await addMedicationWithDuration(
      tester,
      'Vitamin C',
      durationType: getL10n(tester).durationUntilEmptyTitle,
    );
    await waitForDatabase(tester);

    // Tap on the medication to open modal
    await tester.tap(find.text('Vitamin C'));
    await tester.pumpAndSettle();

    // Verify duration is displayed in modal (short version "Until finished")
    expect(find.text(getL10n(tester).editFrequencyUntilFinished), findsWidgets);
  });
}
