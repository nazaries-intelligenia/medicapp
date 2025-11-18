import 'package:flutter/material.dart';

/// Extensions para reducir boilerplate en widgets comunes
/// Aprovecha las mejoras de Dart 3.10

/// Extension para crear SizedBox con menos código
extension SpacingExtension on num {
  /// Crea un SizedBox con altura = este número
  /// Uso: 16.verticalSpace en vez de const SizedBox(height: 16)
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Crea un SizedBox con ancho = este número
  /// Uso: 16.horizontalSpace en vez de const SizedBox(width: 16)
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}

/// Extension para crear EdgeInsets con menos código
extension EdgeInsetsExtension on num {
  /// Crea EdgeInsets.all con este número
  /// Uso: 16.allPadding en vez de const EdgeInsets.all(16)
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  /// Crea EdgeInsets.all con este número (alias de allPadding)
  EdgeInsets get allMargin => EdgeInsets.all(toDouble());

  /// Crea EdgeInsets simétrico vertical
  /// Uso: 16.verticalPadding en vez de const EdgeInsets.symmetric(vertical: 16)
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  /// Crea EdgeInsets simétrico horizontal
  /// Uso: 16.horizontalPadding en vez de const EdgeInsets.symmetric(horizontal: 16)
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());
}

/// Extension para crear BorderRadius con menos código
extension BorderRadiusExtension on num {
  /// Crea BorderRadius.circular con este número
  /// Uso: 8.circular en vez de BorderRadius.circular(8)
  BorderRadius get circular => BorderRadius.circular(toDouble());

  /// Crea RoundedRectangleBorder con este radio
  /// Uso: 8.roundedShape en vez de RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
  RoundedRectangleBorder get roundedShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(toDouble()),
      );
}

/// Constantes comunes para mantener consistencia visual
class AppSpacing {
  // Espaciado vertical común
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  // SizedBox preconstruidos para los valores más comunes
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

/// Constantes de padding comunes
class AppPadding {
  static const xs = EdgeInsets.all(4);
  static const sm = EdgeInsets.all(8);
  static const md = EdgeInsets.all(12);
  static const lg = EdgeInsets.all(16);
  static const xl = EdgeInsets.all(24);
  static const xxl = EdgeInsets.all(32);

  // Padding horizontal común
  static const horizontalXs = EdgeInsets.symmetric(horizontal: 4);
  static const horizontalSm = EdgeInsets.symmetric(horizontal: 8);
  static const horizontalMd = EdgeInsets.symmetric(horizontal: 12);
  static const horizontalLg = EdgeInsets.symmetric(horizontal: 16);
  static const horizontalXl = EdgeInsets.symmetric(horizontal: 24);

  // Padding vertical común
  static const verticalXs = EdgeInsets.symmetric(vertical: 4);
  static const verticalSm = EdgeInsets.symmetric(vertical: 8);
  static const verticalMd = EdgeInsets.symmetric(vertical: 12);
  static const verticalLg = EdgeInsets.symmetric(vertical: 16);
  static const verticalXl = EdgeInsets.symmetric(vertical: 24);
}

/// Constantes de border radius comunes
class AppBorderRadius {
  static const xs = BorderRadius.all(Radius.circular(4));
  static const sm = BorderRadius.all(Radius.circular(8));
  static const md = BorderRadius.all(Radius.circular(12));
  static const lg = BorderRadius.all(Radius.circular(16));
  static const xl = BorderRadius.all(Radius.circular(24));

  // Shapes preconstruidos
  static const shapeXs = RoundedRectangleBorder(borderRadius: xs);
  static const shapeSm = RoundedRectangleBorder(borderRadius: sm);
  static const shapeMd = RoundedRectangleBorder(borderRadius: md);
  static const shapeLg = RoundedRectangleBorder(borderRadius: lg);
  static const shapeXl = RoundedRectangleBorder(borderRadius: xl);
}
