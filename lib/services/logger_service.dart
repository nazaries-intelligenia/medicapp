import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging service for the application.
///
/// Provides consistent logging across the app with different log levels:
/// - verbose: Detailed diagnostic information
/// - debug: Debug information useful during development
/// - info: Informational messages about app flow
/// - warning: Warnings that don't prevent app from working
/// - error: Errors that need attention but app can recover
/// - wtf: Serious errors that should never happen
///
/// Features:
/// - Pretty console output with colors in debug mode
/// - Automatic stack traces for errors
/// - Timestamps for all logs
/// - Conditional logging based on build mode (debug/release)
/// - Test mode support to reduce noise during testing
class LoggerService {
  // Private constructor to prevent instantiation
  LoggerService._();

  static Logger? _logger;
  static bool _isTestMode = false;

  /// Get the singleton logger instance
  static Logger get instance {
    _logger ??= _createLogger();
    return _logger!;
  }

  /// Create and configure the logger
  static Logger _createLogger() {
    return Logger(
      filter: _LogFilter(),
      printer: PrettyPrinter(
        methodCount: 0, // Number of method calls to display (0 = only current method)
        errorMethodCount: 5, // Number of method calls for errors
        lineLength: 80, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        dateTimeFormat: DateTimeFormat.onlyTime,
      ),
      output: ConsoleOutput(),
    );
  }

  /// Enable test mode to reduce log noise during testing
  static void enableTestMode() {
    _isTestMode = true;
  }

  /// Disable test mode
  static void disableTestMode() {
    _isTestMode = false;
  }

  /// Check if currently in test mode
  static bool get isTestMode => _isTestMode;

  // Convenience methods for different log levels

  /// Log verbose/trace message (most detailed)
  static void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.t(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log debug message (for development)
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log info message (general information)
  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log warning message (potential issues)
  static void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log error message (errors that need attention)
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log WTF message (serious errors that should never happen)
  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.f(message, error: error, stackTrace: stackTrace);
    }
  }
}

/// Custom log filter that respects build mode and test mode
class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // In test mode, don't log anything
    if (LoggerService.isTestMode) {
      return false;
    }

    // In release mode, only log warnings and errors
    if (kReleaseMode) {
      return event.level.index >= Level.warning.index;
    }

    // In debug/profile mode, log everything
    return true;
  }
}
