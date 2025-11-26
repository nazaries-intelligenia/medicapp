import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user preferences
class PreferencesService {
  static const String _keyShowActualTime = 'show_actual_time_for_taken_doses';
  static const String _keyShowFastingCountdown = 'show_fasting_countdown';
  static const String _keyShowFastingNotification = 'show_fasting_notification';
  static const String _keyShowPersonTabs = 'show_person_tabs';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyColorPalette = 'color_palette';
  static const String _keyNotificationSound = 'notification_sound';

  /// Get the preference for showing actual time for taken doses
  /// Returns true if the user wants to see the actual time when a dose was taken
  /// Returns false (default) to show the scheduled time
  static Future<bool> getShowActualTimeForTakenDoses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyShowActualTime) ?? false;
  }

  /// Set the preference for showing actual time for taken doses
  static Future<void> setShowActualTimeForTakenDoses(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowActualTime, value);
  }

  /// Get the preference for showing fasting countdown
  /// Returns true if the user wants to see a countdown of remaining fasting time
  /// Returns false (default) to not show the countdown
  static Future<bool> getShowFastingCountdown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyShowFastingCountdown) ?? false;
  }

  /// Set the preference for showing fasting countdown
  static Future<void> setShowFastingCountdown(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowFastingCountdown, value);
  }

  /// Get the preference for showing fasting countdown in ongoing notification
  /// Returns true if the user wants to see an ongoing notification with fasting countdown
  /// Returns false (default) to not show the notification
  /// Note: This only works on Android, iOS doesn't support ongoing notifications
  static Future<bool> getShowFastingNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyShowFastingNotification) ?? false;
  }

  /// Set the preference for showing fasting countdown in ongoing notification
  static Future<void> setShowFastingNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowFastingNotification, value);
  }

  /// Get the preference for showing persons in separate tabs
  /// Returns true (default) if the user wants to see persons in separate tabs
  /// Returns false to show all persons mixed in a single list with person labels
  static Future<bool> getShowPersonTabs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyShowPersonTabs) ?? true; // Default: true (tabs enabled)
  }

  /// Set the preference for showing persons in separate tabs
  static Future<void> setShowPersonTabs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowPersonTabs, value);
  }

  /// Get the theme mode preference
  /// Returns 'system' (default), 'light', or 'dark'
  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  /// Set the theme mode preference
  /// Valid values: 'system', 'light', 'dark'
  static Future<void> setThemeMode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, value);
  }

  /// Get the color palette preference
  /// Returns 'seaGreen' (default) or 'material3'
  static Future<String> getColorPalette() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyColorPalette) ?? 'seaGreen';
  }

  /// Set the color palette preference
  /// Valid values: 'seaGreen', 'material3'
  static Future<void> setColorPalette(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyColorPalette, value);
  }

  /// Get the notification sound preference
  /// Returns null (default system sound) or the URI/title of the selected ringtone
  static Future<String?> getNotificationSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNotificationSound);
  }

  /// Set the notification sound preference
  /// Pass null to use default system sound, or provide the URI/title of the ringtone
  static Future<void> setNotificationSound(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(_keyNotificationSound);
    } else {
      await prefs.setString(_keyNotificationSound, value);
    }
  }
}
