import 'package:flutter/material.dart';
import '../../medication_dosage_screen.dart';
import '../../../widgets/forms/selectable_option_card.dart';

/// Widget to display a dosage mode option as a selectable card
///
/// This is a thin wrapper around [SelectableOptionCard] specialized for
/// [DosageMode] types.
class DosageModeOptionCard extends StatelessWidget {
  final DosageMode mode;
  final DosageMode selectedMode;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final ValueChanged<DosageMode> onTap;

  const DosageModeOptionCard({
    super.key,
    required this.mode,
    required this.selectedMode,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableOptionCard<DosageMode>(
      value: mode,
      selectedValue: selectedMode,
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: color,
      onTap: (DosageMode? val) {
        if (val != null) onTap(val);
      },
    );
  }
}
