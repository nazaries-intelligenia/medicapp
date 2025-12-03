import 'package:flutter/services.dart';

/// Service to communicate with the Android home screen widgets.
/// Updates widgets when medication data changes.
class WidgetService {
  static const _channel = MethodChannel('com.medicapp.medicapp/widget');

  /// Singleton instance.
  static final WidgetService instance = WidgetService._();

  WidgetService._();

  /// Request all widgets to refresh their data.
  /// Called after dose registration, medication changes, etc.
  /// Updates both the medication widget and fasting widget.
  Future<void> updateWidget() async {
    try {
      await _channel.invokeMethod('updateWidget');
    } on PlatformException {
      // Widget may not be added to home screen - ignore errors
    } on MissingPluginException {
      // Platform doesn't support widgets (iOS, web, etc.)
    }
  }

  /// Request only the fasting widget to refresh its data.
  /// Called when fasting-related data changes.
  Future<void> updateFastingWidget() async {
    try {
      await _channel.invokeMethod('updateFastingWidget');
    } on PlatformException {
      // Widget may not be added to home screen - ignore errors
    } on MissingPluginException {
      // Platform doesn't support widgets (iOS, web, etc.)
    }
  }
}
