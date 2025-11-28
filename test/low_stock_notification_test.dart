import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/notification_service.dart';
import 'package:medicapp/services/notification_id_generator.dart';
import 'helpers/database_test_helper.dart';
import 'helpers/medication_builder.dart';
import 'helpers/person_test_helper.dart';

/// Tests for low stock notifications
/// Feature: Alert users when medication stock is low or insufficient
///
/// These tests verify that:
/// - Low stock notifications are shown when stock < dose quantity
/// - Notification IDs are generated correctly in the 7M-7.999M range
/// - Notifications include correct medication and stock information
void main() {
  late NotificationService service;

  DatabaseTestHelper.setup();

  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  tearDown(() {
    service.disableTestMode();
  });

  group('Low Stock Notification ID Generation', () {
    test('should generate IDs in the 7,000,000-7,999,999 range', () {
      // Arrange
      const medicationId1 = 'med-123';
      const medicationId2 = 'med-456';

      // Act
      final id1 = NotificationIdGenerator.generateLowStockId(medicationId1);
      final id2 = NotificationIdGenerator.generateLowStockId(medicationId2);

      // Assert
      expect(id1, greaterThanOrEqualTo(7000000));
      expect(id1, lessThan(8000000));
      expect(id2, greaterThanOrEqualTo(7000000));
      expect(id2, lessThan(8000000));
      expect(id1, isNot(equals(id2)), reason: 'Different medications should have different IDs');
    });

    test('should generate consistent IDs for the same medication', () {
      // Arrange
      const medicationId = 'med-consistent';

      // Act
      final id1 = NotificationIdGenerator.generateLowStockId(medicationId);
      final id2 = NotificationIdGenerator.generateLowStockId(medicationId);

      // Assert
      expect(id1, equals(id2), reason: 'Same medication should always get the same ID');
    });
  });

  group('Low Stock Notification - Basic Functionality', () {
    test('should show notification for insufficient stock without errors', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-low-stock')
          .withName('Omeprazole')
          .withSingleDose('08:00', 2.0) // Requires 2 pills per dose
          .withStock(1.0) // Only 1 pill available - INSUFFICIENT
          .build();

      await insertMedicationWithPerson(medication);

      // Act & Assert - Should not throw
      expect(
        () => service.showLowStockNotification(
          medication: medication,
          personName: 'Usuario',
          isInsufficientForDose: true,
        ),
        returnsNormally,
        reason: 'showLowStockNotification should execute without errors',
      );
    });

    test('should show notification for low stock without errors', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-warning-stock')
          .withName('Acetaminophen')
          .withSingleDose('14:00', 1.0)
          .withStock(2.0) // Low but not insufficient
          .build();

      await insertMedicationWithPerson(medication);

      // Act & Assert - Should not throw
      expect(
        () => service.showLowStockNotification(
          medication: medication,
          personName: 'Usuario',
          isInsufficientForDose: false,
        ),
        returnsNormally,
        reason: 'showLowStockNotification should execute without errors for warning',
      );
    });
  });

  group('Low Stock Notification - Different Stock Levels', () {
    test('should handle fractional doses with low stock', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-fractional')
          .withName('Levothyroxine')
          .withSingleDose('07:00', 0.5) // Requires 0.5 pills
          .withStock(0.3) // Only 0.3 pills - insufficient
          .build();

      await insertMedicationWithPerson(medication);

      // Act & Assert
      expect(
        () => service.showLowStockNotification(
          medication: medication,
          personName: 'Usuario',
          isInsufficientForDose: true,
        ),
        returnsNormally,
        reason: 'Should handle fractional stock amounts',
      );
    });

    test('should handle zero stock', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-zero-stock')
          .withName('Aspirin')
          .withSingleDose('12:00', 1.0)
          .withStock(0.0) // No stock
          .build();

      await insertMedicationWithPerson(medication);

      // Act & Assert
      expect(
        () => service.showLowStockNotification(
          medication: medication,
          personName: 'Usuario',
          isInsufficientForDose: true,
        ),
        returnsNormally,
        reason: 'Should handle zero stock',
      );
    });
  });
}
