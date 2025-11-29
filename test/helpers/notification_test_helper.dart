import 'package:medicapp/services/notification_service.dart';

/// Helper class to manage NotificationService test setup and teardown.
///
/// This eliminates duplicated code across 10+ notification test files.
///
/// Usage:
/// ```dart
/// late NotificationService service;
///
/// setUp(() {
///   service = NotificationServiceTestHelper.setup();
/// });
///
/// tearDown(() {
///   NotificationServiceTestHelper.tearDown();
/// });
/// ```
class NotificationServiceTestHelper {
  /// Sets up the NotificationService for testing.
  ///
  /// Enables test mode to prevent actual notification scheduling
  /// during unit tests.
  ///
  /// Returns the singleton NotificationService instance.
  static NotificationService setup() {
    final service = NotificationService.instance;
    service.enableTestMode();
    return service;
  }

  /// Tears down the NotificationService after tests.
  ///
  /// Disables test mode to restore normal behavior.
  static void tearDown() {
    NotificationService.instance.disableTestMode();
  }
}
