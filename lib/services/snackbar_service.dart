import 'package:flutter/material.dart';
import '../utils/widget_extensions.dart';

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
/// Internal enum for SnackBar types
enum _SnackBarType {
  success,
  error,
  info,
  warning;

  IconData get icon => switch (this) {
        .success => Icons.check_circle,
        .error => Icons.error,
        .info => Icons.info,
        .warning => Icons.warning,
      };

  Duration get defaultDuration => switch (this) {
        .success => const Duration(seconds: 3),
        .error => const Duration(seconds: 3),
        .info => const Duration(seconds: 2),
        .warning => const Duration(seconds: 3),
      };

  Color backgroundColor(ColorScheme colorScheme) => switch (this) {
        .success => Colors.green.shade700,
        .error => colorScheme.error,
        .info => Colors.blue.shade700,
        .warning => Colors.orange.shade600,
      };

  Color contentColor(ColorScheme colorScheme) => switch (this) {
        .success => colorScheme.onPrimary,
        .error => colorScheme.onError,
        .info => colorScheme.onPrimary,
        .warning => Colors.black87,
      };
}

class SnackBarService {
  // Private constructor to prevent instantiation
  SnackBarService._();

  /// Internal method to show a SnackBar with consistent styling
  static void _show(
    BuildContext context,
    String message,
    _SnackBarType type, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    if (!context.mounted) return;

    final colorScheme = Theme.of(context).colorScheme;
    final contentColor = type.contentColor(colorScheme);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              type.icon,
              color: contentColor,
              size: 20,
            ),
            AppSpacing.horizontalMd,
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: contentColor),
              ),
            ),
          ],
        ),
        backgroundColor: type.backgroundColor(colorScheme),
        duration: duration ?? type.defaultDuration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: 8.roundedShape,
      ),
    );
  }

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
  }) =>
      _show(context, message, .success, duration: duration, action: action);

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
  }) =>
      _show(context, message, .error, duration: duration, action: action);

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
  }) =>
      _show(context, message, .info, duration: duration, action: action);

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
  }) =>
      _show(context, message, .warning, duration: duration, action: action);

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
        shape: 8.roundedShape,
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
