import 'package:flutter/material.dart';
import '../services/snackbar_service.dart';

/// Mixin that provides a consistent pattern for executing medication-related
/// actions with standardized error handling and UI feedback.
///
/// This eliminates the repeated pattern of:
/// 1. Executing an async action
/// 2. Calling onMedicationUpdated callback
/// 3. Checking if (!mounted) return
/// 4. Showing success/error SnackBar
///
/// Usage:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with MedicationActionHandler {
///   void _someAction() async {
///     await executeMedicationAction(
///       action: () async {
///         // Your medication operation here
///         await SomeService.doSomething();
///       },
///       successMessage: 'Operation completed successfully',
///       onSuccess: widget.onMedicationUpdated,
///     );
///   }
/// }
/// ```
mixin MedicationActionHandler<T extends StatefulWidget> on State<T> {
  /// Execute a medication action with standard error handling and snackbar feedback.
  ///
  /// This method encapsulates the common pattern found across medication card widgets:
  /// - Executes the provided async action
  /// - Calls the onSuccess callback (typically widget.onMedicationUpdated)
  /// - Checks if widget is still mounted before showing UI feedback
  /// - Shows appropriate success or error SnackBar
  ///
  /// Parameters:
  /// - [action]: The async operation to execute (e.g., update medication, refill, etc.)
  /// - [successMessage]: Message to show on successful completion
  /// - [errorMessage]: Optional custom error message. If not provided, uses exception message
  /// - [onSuccess]: Optional callback to execute after successful action (e.g., onMedicationUpdated)
  ///
  /// Example:
  /// ```dart
  /// await executeMedicationAction(
  ///   action: () async {
  ///     await MedicationUpdateService.resumeMedication(
  ///       medication: widget.medication,
  ///     );
  ///   },
  ///   successMessage: l10n.medicineCabinetResumeSuccess(widget.medication.name),
  ///   onSuccess: widget.onMedicationUpdated,
  /// );
  /// ```
  Future<void> executeMedicationAction({
    required Future<void> Function() action,
    required String successMessage,
    String? errorMessage,
    VoidCallback? onSuccess,
  }) async {
    try {
      // Execute the medication action
      await action();

      // Call success callback (typically reloads medications)
      onSuccess?.call();

      // Check if widget is still mounted before showing UI
      if (!mounted) return;

      // Show success feedback
      SnackBarService.showSuccess(context, successMessage);
    } catch (e) {
      // Check if widget is still mounted before showing error
      if (!mounted) return;

      // Show error feedback with custom or exception message
      SnackBarService.showError(
        context,
        errorMessage ?? e.toString(),
      );
    }
  }
}
