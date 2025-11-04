import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Centralized platform detection utility for the application.
///
/// This class provides static getters to check the current platform,
/// making platform-specific logic easier to maintain and test.
///
/// Example usage:
/// ```dart
/// if (PlatformHelper.isAndroid) {
///   // Android-specific code
/// }
///
/// if (PlatformHelper.isMobile) {
///   // Code for mobile platforms (Android/iOS)
/// }
/// ```
class PlatformHelper {
  // Private constructor to prevent instantiation
  PlatformHelper._();

  /// Returns true if the current platform is Android
  static bool get isAndroid => Platform.isAndroid;

  /// Returns true if the current platform is iOS
  static bool get isIOS => Platform.isIOS;

  /// Returns true if the current platform is Web
  static bool get isWeb => kIsWeb;

  /// Returns true if the current platform is mobile (Android or iOS)
  static bool get isMobile => isAndroid || isIOS;

  /// Returns true if the current platform is desktop (Windows, macOS, or Linux)
  static bool get isDesktop => !isMobile && !isWeb;

  /// Returns true if the current platform is Windows
  static bool get isWindows => Platform.isWindows;

  /// Returns true if the current platform is macOS
  static bool get isMacOS => Platform.isMacOS;

  /// Returns true if the current platform is Linux
  static bool get isLinux => Platform.isLinux;

  /// Returns true if the current platform is Fuchsia
  static bool get isFuchsia => Platform.isFuchsia;

  /// Returns the current operating system name (as reported by Platform)
  static String get operatingSystem => Platform.operatingSystem;

  /// Returns the current operating system version (as reported by Platform)
  static String get operatingSystemVersion => Platform.operatingSystemVersion;
}
