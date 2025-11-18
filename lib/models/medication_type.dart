import 'package:flutter/material.dart';

enum MedicationType {
  pill,
  capsule,
  injection,
  syrup,
  ovule,
  suppository,
  inhaler,
  sachet,
  spray,
  ointment,
  lotion,
  bandage,
  drops,
  other;

  String get displayName => switch (this) {
        .pill => 'Pastilla',
        .capsule => 'Cápsula',
        .injection => 'Inyección',
        .syrup => 'Jarabe',
        .ovule => 'Óvulo',
        .suppository => 'Supositorio',
        .inhaler => 'Inhalador',
        .sachet => 'Sobre',
        .spray => 'Spray',
        .ointment => 'Pomada',
        .lotion => 'Loción',
        .bandage => 'Apósito',
        .drops => 'Gota',
        .other => 'Otro',
      };

  IconData get icon => switch (this) {
        .pill => Icons.circle,
        .capsule => Icons.medication,
        .injection => Icons.vaccines,
        .syrup => Icons.local_drink,
        .ovule => Icons.egg,
        .suppository => Icons.toggle_off,
        .inhaler => Icons.air,
        .sachet => Icons.inventory_2,
        .spray => Icons.water_drop,
        .ointment => Icons.opacity,
        .lotion => Icons.water,
        .bandage => Icons.healing,
        .drops => Icons.invert_colors,
        .other => Icons.category,
      };

  Color getColor(BuildContext context) => switch (this) {
        .pill => Colors.blue,
        .capsule => Colors.purple,
        .injection => Colors.red,
        .syrup => Colors.orange,
        .ovule => Colors.pink,
        .suppository => Colors.teal,
        .inhaler => Colors.cyan,
        .sachet => Colors.brown,
        .spray => Colors.lightBlue,
        .ointment => Colors.green,
        .lotion => Colors.indigo,
        .bandage => Colors.amber,
        .drops => Colors.blueGrey,
        .other => Colors.grey,
      };

  /// Get the unit of measurement for the medication type
  String get stockUnit => switch (this) {
        .pill => 'pastillas',
        .capsule => 'cápsulas',
        .injection => 'inyecciones',
        .syrup => 'ml',
        .ovule => 'óvulos',
        .suppository => 'supositorios',
        .inhaler => 'inhalaciones',
        .sachet => 'sobres',
        .spray => 'ml',
        .ointment => 'gramos',
        .lotion => 'ml',
        .bandage => 'apósitos',
        .drops => 'gotas',
        .other => 'unidades',
      };

  /// Get the singular unit of measurement for the medication type
  String get stockUnitSingular => switch (this) {
        .pill => 'pastilla',
        .capsule => 'cápsula',
        .injection => 'inyección',
        .syrup => 'ml',
        .ovule => 'óvulo',
        .suppository => 'supositorio',
        .inhaler => 'inhalación',
        .sachet => 'sobre',
        .spray => 'ml',
        .ointment => 'gramo',
        .lotion => 'ml',
        .bandage => 'apósito',
        .drops => 'gota',
        .other => 'unidad',
      };
}
