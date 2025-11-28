import 'package:flutter/material.dart';

/// Extensions to reduce boilerplate in common widgets
/// Takes advantage of Dart 3.10 improvements

/// Extension to create SizedBox with less code
extension SpacingExtension on num {
  /// Creates a SizedBox with height = this number
  /// Usage: 16.verticalSpace instead of const SizedBox(height: 16)
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Creates a SizedBox with width = this number
  /// Usage: 16.horizontalSpace instead of const SizedBox(width: 16)
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}

/// Extension to create EdgeInsets with less code
extension EdgeInsetsExtension on num {
  /// Creates EdgeInsets.all with this number
  /// Usage: 16.allPadding instead of const EdgeInsets.all(16)
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  /// Creates EdgeInsets.all with this number (alias of allPadding)
  EdgeInsets get allMargin => EdgeInsets.all(toDouble());

  /// Creates symmetric vertical EdgeInsets
  /// Usage: 16.verticalPadding instead of const EdgeInsets.symmetric(vertical: 16)
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  /// Creates symmetric horizontal EdgeInsets
  /// Usage: 16.horizontalPadding instead of const EdgeInsets.symmetric(horizontal: 16)
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());
}

/// Extension to create BorderRadius with less code
extension BorderRadiusExtension on num {
  /// Creates BorderRadius.circular with this number
  /// Usage: 8.circular instead of BorderRadius.circular(8)
  BorderRadius get circular => BorderRadius.circular(toDouble());

  /// Creates RoundedRectangleBorder with this radius
  /// Usage: 8.roundedShape instead of RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
  RoundedRectangleBorder get roundedShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(toDouble()),
      );
}

/// Common constants to maintain visual consistency
class AppSpacing {
  // Common vertical spacing
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  // Pre-built SizedBox for the most common values
  static const verticalXs = SizedBox(height: xs);
  static const verticalSm = SizedBox(height: sm);
  static const verticalMd = SizedBox(height: md);
  static const verticalLg = SizedBox(height: lg);
  static const verticalXl = SizedBox(height: xl);
  static const verticalXxl = SizedBox(height: xxl);

  static const horizontalXs = SizedBox(width: xs);
  static const horizontalSm = SizedBox(width: sm);
  static const horizontalMd = SizedBox(width: md);
  static const horizontalLg = SizedBox(width: lg);
  static const horizontalXl = SizedBox(width: xl);
  static const horizontalXxl = SizedBox(width: xxl);
}

/// Common padding constants
class AppPadding {
  static const xs = EdgeInsets.all(4);
  static const sm = EdgeInsets.all(8);
  static const md = EdgeInsets.all(12);
  static const lg = EdgeInsets.all(16);
  static const xl = EdgeInsets.all(24);
  static const xxl = EdgeInsets.all(32);

  // Common horizontal padding
  static const horizontalXs = EdgeInsets.symmetric(horizontal: 4);
  static const horizontalSm = EdgeInsets.symmetric(horizontal: 8);
  static const horizontalMd = EdgeInsets.symmetric(horizontal: 12);
  static const horizontalLg = EdgeInsets.symmetric(horizontal: 16);
  static const horizontalXl = EdgeInsets.symmetric(horizontal: 24);

  // Common vertical padding
  static const verticalXs = EdgeInsets.symmetric(vertical: 4);
  static const verticalSm = EdgeInsets.symmetric(vertical: 8);
  static const verticalMd = EdgeInsets.symmetric(vertical: 12);
  static const verticalLg = EdgeInsets.symmetric(vertical: 16);
  static const verticalXl = EdgeInsets.symmetric(vertical: 24);
}

/// Common border radius constants
class AppBorderRadius {
  static const xs = BorderRadius.all(Radius.circular(4));
  static const sm = BorderRadius.all(Radius.circular(8));
  static const md = BorderRadius.all(Radius.circular(12));
  static const lg = BorderRadius.all(Radius.circular(16));
  static const xl = BorderRadius.all(Radius.circular(24));

  // Pre-built shapes
  static const shapeXs = RoundedRectangleBorder(borderRadius: xs);
  static const shapeSm = RoundedRectangleBorder(borderRadius: sm);
  static const shapeMd = RoundedRectangleBorder(borderRadius: md);
  static const shapeLg = RoundedRectangleBorder(borderRadius: lg);
  static const shapeXl = RoundedRectangleBorder(borderRadius: xl);
}
