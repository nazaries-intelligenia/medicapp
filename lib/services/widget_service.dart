import 'package:flutter/services.dart';

/// Service to communicate with the Android home screen widget.
/// Updates the widget when medication data changes.
class WidgetService {
  static const _channel = MethodChannel('com.medicapp.medicapp/widget');

  /// Singleton instance.
  static final WidgetService instance = WidgetService._();

  WidgetService._();

  /// Request the widget to refresh its data.
  /// Called after dose registration, medication changes, etc.
  Future<void> updateWidget() async {
    try {
      await _channel.invokeMethod('updateWidget');
    } on PlatformException {
      // Widget may not be added to home screen - ignore errors
    } on MissingPluginException {
      // Platform doesn't support widgets (iOS, web, etc.)
    }
  }
}
