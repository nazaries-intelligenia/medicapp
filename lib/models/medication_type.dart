import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/localization_service.dart';

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

  /// Get localized display name for the medication type
  String getDisplayName(AppLocalizations l10n) => switch (this) {
        .pill => l10n.medicationTypePill,
        .capsule => l10n.medicationTypeCapsule,
        .injection => l10n.medicationTypeInjection,
        .syrup => l10n.medicationTypeSyrup,
        .ovule => l10n.medicationTypeOvule,
        .suppository => l10n.medicationTypeSuppository,
        .inhaler => l10n.medicationTypeInhaler,
        .sachet => l10n.medicationTypeSachet,
        .spray => l10n.medicationTypeSpray,
        .ointment => l10n.medicationTypeOintment,
        .lotion => l10n.medicationTypeLotion,
        .bandage => l10n.medicationTypeBandage,
        .drops => l10n.medicationTypeDrops,
        .other => l10n.medicationTypeOther,
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

  /// Get the localized plural unit of measurement for the medication type
  String getStockUnit(AppLocalizations l10n) => switch (this) {
        .pill => l10n.stockUnitPills,
        .capsule => l10n.stockUnitCapsules,
        .injection => l10n.stockUnitInjections,
        .syrup => l10n.stockUnitMl,
        .ovule => l10n.stockUnitOvules,
        .suppository => l10n.stockUnitSuppositories,
        .inhaler => l10n.stockUnitInhalations,
        .sachet => l10n.stockUnitSachets,
        .spray => l10n.stockUnitMl,
        .ointment => l10n.stockUnitGrams,
        .lotion => l10n.stockUnitMl,
        .bandage => l10n.stockUnitBandages,
        .drops => l10n.stockUnitDrops,
        .other => l10n.stockUnitUnits,
      };

  /// Get the localized singular unit of measurement for the medication type
  String getStockUnitSingular(AppLocalizations l10n) => switch (this) {
        .pill => l10n.stockUnitPill,
        .capsule => l10n.stockUnitCapsule,
        .injection => l10n.stockUnitInjection,
        .syrup => l10n.stockUnitMl,
        .ovule => l10n.stockUnitOvule,
        .suppository => l10n.stockUnitSuppository,
        .inhaler => l10n.stockUnitInhalation,
        .sachet => l10n.stockUnitSachet,
        .spray => l10n.stockUnitMl,
        .ointment => l10n.stockUnitGram,
        .lotion => l10n.stockUnitMl,
        .bandage => l10n.stockUnitBandage,
        .drops => l10n.stockUnitDrop,
        .other => l10n.stockUnitUnit,
      };

  /// Localized display name (uses LocalizationService for context-free access)
  String get displayName => getDisplayName(LocalizationService.instance.l10n);

  /// Localized plural stock unit (uses LocalizationService for context-free access)
  String get stockUnit => getStockUnit(LocalizationService.instance.l10n);

  /// Localized singular stock unit (uses LocalizationService for context-free access)
  String get stockUnitSingular => getStockUnitSingular(LocalizationService.instance.l10n);
}
