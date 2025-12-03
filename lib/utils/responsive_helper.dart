import 'package:flutter/material.dart';

/// Breakpoints for responsive design
/// Based on Material Design guidelines
class Breakpoints {
  /// Phone: < 600dp
  static const double phone = 600;

  /// Tablet: 600dp - 840dp
  static const double tablet = 840;

  /// Desktop: > 840dp
  static const double desktop = 1200;
}

/// Device type enumeration for responsive layouts
enum DeviceType { phone, tablet, desktop }

/// Helper class for responsive design
/// Provides utilities for adapting layouts to different screen sizes
class ResponsiveHelper {
  /// Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.phone) {
      return DeviceType.phone;
    } else if (width < Breakpoints.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if device is a phone
  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.phone;
  }

  /// Check if device is a tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.phone && width < Breakpoints.tablet;
  }

  /// Check if device is a tablet or larger
  static bool isTabletOrLarger(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.phone;
  }

  /// Check if device is a desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.tablet;
  }

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get the number of grid columns based on screen width
  /// Returns 1 for phones, 2 for tablets, 3 for desktop
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.phone) {
      return 1;
    } else if (width < Breakpoints.tablet) {
      return 2;
    } else {
      return 3;
    }
  }

  /// Get the number of grid columns for card-based layouts
  /// More granular control for card grids
  static int getCardGridColumns(BuildContext context, {double minCardWidth = 300}) {
    final width = MediaQuery.of(context).size.width;
    final availableWidth = width - 32; // Account for padding
    return (availableWidth / minCardWidth).floor().clamp(1, 4);
  }

  /// Get appropriate content max width for readability
  /// Returns null for phones (full width), constrained for larger screens
  static double? getContentMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.phone) {
      return null; // Full width on phones
    } else if (width < Breakpoints.tablet) {
      return 700; // Constrained on tablets
    } else {
      return 900; // More constrained on desktop for readability
    }
  }

  /// Get horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.phone) {
      return 16;
    } else if (width < Breakpoints.tablet) {
      return 24;
    } else {
      return 32;
    }
  }

  /// Get dialog max width based on screen size
  static double getDialogMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.phone) {
      return width - 32;
    } else {
      return 500;
    }
  }

  /// Get form max width for better readability
  static double getFormMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.phone) {
      return double.infinity;
    } else {
      return 600;
    }
  }

  /// Calculate aspect ratio for grid items based on content type
  static double getCardAspectRatio(BuildContext context, {bool isCompact = false}) {
    final deviceType = getDeviceType(context);
    if (isCompact) {
      return deviceType == DeviceType.phone ? 3.5 : 3.0;
    }
    return deviceType == DeviceType.phone ? 2.5 : 2.2;
  }
}

/// Extension on BuildContext for easy access to responsive helpers
extension ResponsiveExtension on BuildContext {
  /// Get device type
  DeviceType get deviceType => ResponsiveHelper.getDeviceType(this);

  /// Check if phone
  bool get isPhone => ResponsiveHelper.isPhone(this);

  /// Check if tablet
  bool get isTablet => ResponsiveHelper.isTablet(this);

  /// Check if tablet or larger
  bool get isTabletOrLarger => ResponsiveHelper.isTabletOrLarger(this);

  /// Check if desktop
  bool get isDesktop => ResponsiveHelper.isDesktop(this);

  /// Check if landscape
  bool get isLandscape => ResponsiveHelper.isLandscape(this);

  /// Get grid columns
  int get gridColumns => ResponsiveHelper.getGridColumns(this);

  /// Get content max width
  double? get contentMaxWidth => ResponsiveHelper.getContentMaxWidth(this);

  /// Get horizontal padding
  double get horizontalPadding => ResponsiveHelper.getHorizontalPadding(this);

  /// Get dialog max width
  double get dialogMaxWidth => ResponsiveHelper.getDialogMaxWidth(this);

  /// Get form max width
  double get formMaxWidth => ResponsiveHelper.getFormMaxWidth(this);

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;
}
