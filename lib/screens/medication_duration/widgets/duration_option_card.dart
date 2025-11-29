import 'package:flutter/material.dart';
import '../../../models/treatment_duration_type.dart';
import '../../../widgets/forms/selectable_option_card.dart';

/// Widget to display a treatment duration type option as a selectable card
///
/// This is a thin wrapper around [SelectableOptionCard] specialized for
/// [TreatmentDurationType]. It automatically retrieves the icon and color
/// from the duration type.
class DurationOptionCard extends StatelessWidget {
  final TreatmentDurationType type;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const DurationOptionCard({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = type.getColor(context);

    return SelectableOptionCard<void>(
      isSelected: isSelected,
      icon: type.icon,
      title: title,
      subtitle: subtitle,
      color: color,
      onTap: (_) => onTap(),
    );
  }
}
