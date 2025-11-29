import 'package:flutter/material.dart';

/// A generic, reusable widget to display a selectable option as a card.
///
/// This widget provides a consistent UI pattern for selectable cards across
/// the application. It can be used with any type [T] and supports both
/// value-based selection (comparing value == selectedValue) and explicit
/// boolean selection (isSelected).
///
/// The card displays an icon, title, and subtitle, and changes its appearance
/// when selected (highlighted background, colored border, and checkmark icon).
///
/// Example usage:
/// ```dart
/// SelectableOptionCard<FrequencyType>(
///   value: FrequencyType.daily,
///   selectedValue: currentFrequency,
///   icon: Icons.calendar_today,
///   title: 'Daily',
///   subtitle: 'Take once per day',
///   color: Colors.blue,
///   onTap: (value) => setState(() => currentFrequency = value),
/// )
/// ```
class SelectableOptionCard<T> extends StatelessWidget {
  /// The value this card represents
  final T? value;

  /// The currently selected value (for comparison with [value])
  final T? selectedValue;

  /// Explicit selection state (overrides value comparison if provided)
  final bool? isSelected;

  /// Icon to display on the left side of the card
  final IconData icon;

  /// Main title text
  final String title;

  /// Subtitle/description text
  final String subtitle;

  /// Color used for highlighting when selected
  final Color color;

  /// Callback when the card is tapped
  /// - If [value] is provided, calls onTap with the value
  /// - If [value] is null, calls onTap with null (acts as VoidCallback)
  final void Function(T?)? onTap;

  const SelectableOptionCard({
    super.key,
    this.value,
    this.selectedValue,
    this.isSelected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  }) : assert(
          isSelected != null || (value != null && selectedValue != null),
          'Either isSelected must be provided, or both value and selectedValue must be provided',
        );

  @override
  Widget build(BuildContext context) {
    // Determine selection state: use explicit isSelected if provided,
    // otherwise compare value with selectedValue
    final bool selected = isSelected ?? (selectedValue == value);

    return InkWell(
      onTap: onTap != null ? () => onTap!(value) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: selected ? color : Theme.of(context).dividerColor,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? color : Theme.of(context).colorScheme.onSurface,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: selected ? color : Theme.of(context).colorScheme.onSurface,
                          fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: selected
                              ? color.withValues(alpha: 0.8)
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
