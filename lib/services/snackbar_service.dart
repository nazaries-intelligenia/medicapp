import 'package:flutter/material.dart';

/// Centralized service for managing SnackBar messages throughout the app
///
/// This service provides a consistent way to show success, error, info, and warning
/// messages using SnackBars. It handles:
/// - Consistent styling for different message types
/// - Proper duration handling
/// - Optional actions
/// - Material Design 3 theming
///
/// Usage:
/// ```dart
/// SnackBarService.showSuccess(context, 'Operation completed successfully');
/// SnackBarService.showError(context, 'An error occurred');
/// ```
class SnackBarService {
  // Private constructor to prevent instantiation
  SnackBarService._();

  /// Default duration for success messages
  static const Duration _defaultSuccessDuration = Duration(seconds: 3);

  /// Default duration for error messages
  static const Duration _defaultErrorDuration = Duration(seconds: 3);

  /// Default duration for info messages
  static const Duration _defaultInfoDuration = Duration(seconds: 2);

  /// Default duration for warning messages
  static const Duration _defaultWarningDuration = Duration(seconds: 3);

  /// Show a success message (green)
  ///
  /// Used for confirmations like "Medication saved", "Dose registered", etc.
  ///
  /// Parameters:
  /// - [context]: BuildContext to show the SnackBar
  /// - [message]: The message text to display
  /// - [duration]: Optional custom duration (defaults to 3 seconds)
  /// - [action]: Optional SnackBarAction
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    if (!context.mounted) return;

    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: colorScheme.onPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: duration ?? _defaultSuccessDuration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show an error message (red)
  ///
  /// Used for errors like "Insufficient stock", "Failed to save", etc.
  ///
  /// Parameters:
  /// - [context]: BuildContext to show the SnackBar
  /// - [message]: The error message text to display
  /// - [duration]: Optional custom duration (defaults to 3 seconds)
  /// - [action]: Optional SnackBarAction
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    if (!context.mounted) return;

    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: colorScheme.onError,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onError),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.error,
        duration: duration ?? _defaultErrorDuration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show an info message (blue)
  ///
  /// Used for informational messages like "Loading...", "Processing...", etc.
  ///
  /// Parameters:
  /// - [context]: BuildContext to show the SnackBar
  /// - [message]: The info message text to display
  /// - [duration]: Optional custom duration (defaults to 2 seconds)
  /// - [action]: Optional SnackBarAction
  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    if (!context.mounted) return;

    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info,
              color: colorScheme.onPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        duration: duration ?? _defaultInfoDuration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show a warning message (orange)
  ///
  /// Used for warnings like "Low stock", "Approaching expiration", etc.
  ///
  /// Parameters:
  /// - [context]: BuildContext to show the SnackBar
  /// - [message]: The warning message text to display
  /// - [duration]: Optional custom duration (defaults to 3 seconds)
  /// - [action]: Optional SnackBarAction
  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    if (!context.mounted) return;

    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        duration: duration ?? _defaultWarningDuration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show a custom SnackBar with full control
  ///
  /// Use this when you need more control over the SnackBar appearance
  /// or when the message doesn't fit into the standard categories.
  ///
  /// Parameters:
  /// - [context]: BuildContext to show the SnackBar
  /// - [content]: The widget to display in the SnackBar
  /// - [duration]: Duration to show the SnackBar
  /// - [action]: Optional SnackBarAction
  /// - [backgroundColor]: Background color for the SnackBar
  static void showCustom(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Hide the currently displayed SnackBar
  ///
  /// Useful when you need to immediately dismiss a SnackBar,
  /// for example before showing a new one or when navigating away.
  static void hide(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Clear all SnackBars from the queue
  ///
  /// Removes all pending SnackBars from the queue.
  static void clearAll(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
