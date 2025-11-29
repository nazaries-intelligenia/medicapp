import 'package:flutter/material.dart';
import 'selectable_option_card.dart';

/// Reusable widget to display a frequency option as a selectable card
/// Used in medication frequency creation and editing screens
///
/// This is a thin wrapper around [SelectableOptionCard] that maintains
/// backward compatibility with existing code.
class FrequencyOptionCard<T> extends StatelessWidget {
  final T value;
  final T selectedValue;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final ValueChanged<T> onTap;

  const FrequencyOptionCard({
    super.key,
    required this.value,
    required this.selectedValue,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableOptionCard<T>(
      value: value,
      selectedValue: selectedValue,
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: color,
      onTap: (T? val) {
        if (val != null) onTap(val);
      },
    );
  }
}
