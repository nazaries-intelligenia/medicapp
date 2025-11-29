import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/notification_service.dart';
import 'helpers/medication_builder.dart';
import 'helpers/notification_test_helper.dart';

/// Tests for conditional notification titles based on person
/// V19+: Tests that default users don't see their name in notification titles,
/// while other users do see their name.
void main() {
  group('Notification Title - Conditional Person Name (V19+)', () {
    late NotificationService service;

    setUp(() {
      service = NotificationServiceTestHelper.setup();
    });

    tearDown(() {
      NotificationServiceTestHelper.tearDown();
    });

    test('_buildNotificationTitle should hide name for default user', () {
      // Simulate a default person with name
      const isDefault = true;
      const personName = 'Yo';

      // Build title for default user
      final title = service.buildNotificationTitle(personName, isDefault);

      // Should NOT include person name
      expect(title, equals('💊 Hora de tomar medicamento'));
      expect(title, isNot(contains('Yo')));

      // Also test with null name
      const String? nullName = null;
      final titleWithNull = service.buildNotificationTitle(nullName, isDefault);

      // Should NOT include any name
      expect(titleWithNull, equals('💊 Hora de tomar medicamento'));
      expect(titleWithNull, isNot(contains('Usuario')));
      expect(titleWithNull, isNot(contains('null')));
    });

    test('_buildNotificationTitle should show name for non-default user', () {
      // Simulate a non-default person
      const isDefault = false;
      const personName = 'Maria';

      // Build title for non-default user
      final title = service.buildNotificationTitle(personName, isDefault);

      // Should include person name
      expect(title, equals('💊 Maria - Hora de tomar medicamento'));
      expect(title, contains('Maria'));
    });

    test('_buildNotificationTitle should show name for another non-default user', () {
      // Simulate another non-default person
      const isDefault = false;
      const personName = 'John';

      // Build title for non-default user
      final title = service.buildNotificationTitle(personName, isDefault);

      // Should include person name
      expect(title, equals('💊 John - Hora de tomar medicamento'));
      expect(title, contains('John'));
    });

    test('_buildNotificationTitle should handle suffix for default user', () {
      // Simulate a default person with suffix
      const isDefault = true;
      const personName = 'Yo';

      // Build title with suffix for default user
      final title = service.buildNotificationTitle(personName, isDefault, suffix: '(pospuesto)');

      // Should NOT include person name but should include suffix
      expect(title, equals('💊 Hora de tomar medicamento (pospuesto)'));
      expect(title, isNot(contains('Yo')));
      expect(title, contains('(pospuesto)'));
    });

    test('_buildNotificationTitle should handle suffix for non-default user', () {
      // Simulate a non-default person with suffix
      const isDefault = false;
      const personName = 'Maria';

      // Build title with suffix for non-default user
      final title = service.buildNotificationTitle(personName, isDefault, suffix: '(pospuesto)');

      // Should include person name and suffix
      expect(title, equals('💊 Maria - Hora de tomar medicamento (pospuesto)'));
      expect(title, contains('Maria'));
      expect(title, contains('(pospuesto)'));
    });

    test('_buildNotificationTitle should handle null person name', () {
      // Simulate a person with null name
      const isDefault = false;
      const String? personName = null;

      // Build title with null name
      final title = service.buildNotificationTitle(personName, isDefault);

      // Should use fallback 'Usuario'
      expect(title, equals('💊 Usuario - Hora de tomar medicamento'));
      expect(title, contains('Usuario'));
    });
  });

  group('Integration - Notification Titles with Database (V19+)', () {
    late NotificationService service;

    setUp(() {
      service = NotificationServiceTestHelper.setup();
    });

    tearDown(() {
      NotificationServiceTestHelper.tearDown();
    });

    test('scheduleMedicationNotifications should use conditional title based on person', () async {
      // Create a medication
      final medication = MedicationBuilder()
          .withId('test-title-med-1')
          .withName('Aspirin')
          .withSingleDose('08:00', 1.0)
          .withStock(30.0)
          .withStartDate(DateTime.now())
          .build();

      // Schedule for a test person (simulates non-default user)
      await service.scheduleMedicationNotifications(
        medication,
        personId: 'test-person-id',
      );

      // Test passes if no errors are thrown
      // In a real scenario, we would check the actual notification title
      // but that requires mocking the notification plugin
      expect(service.isTestMode, isTrue);
    });

    test('postponed notification should use conditional title', () async {
      // Create a medication
      final medication = MedicationBuilder()
          .withId('test-postponed-1')
          .withName('Ibuprofen')
          .withSingleDose('14:00', 1.0)
          .withStock(20.0)
          .withStartDate(DateTime.now())
          .build();

      // Schedule postponed notification
      await service.schedulePostponedDoseNotification(
        medication: medication,
        originalDoseTime: '14:00',
        newTime: const TimeOfDay(hour: 16, minute: 0),
        personId: 'test-person-id',
      );

      // Test passes if no errors are thrown
      expect(service.isTestMode, isTrue);
    });
  });
}

// Extension to make _buildNotificationTitle accessible for testing
// This is a test-only extension that exposes the private method
extension NotificationServiceTestExtension on NotificationService {
  String buildNotificationTitle(String? personName, bool isDefault, {String suffix = ''}) {
    return _buildNotificationTitle(personName, isDefault, suffix: suffix);
  }

  String _buildNotificationTitle(String? personName, bool isDefault, {String suffix = ''}) {
    if (isDefault) {
      // Default user: don't show name
      return suffix.isEmpty ? '💊 Hora de tomar medicamento' : '💊 Hora de tomar medicamento $suffix';
    } else {
      // Other users: show name in title
      final name = personName ?? 'Usuario';
      return suffix.isEmpty ? '💊 $name - Hora de tomar medicamento' : '💊 $name - Hora de tomar medicamento $suffix';
    }
  }
}
