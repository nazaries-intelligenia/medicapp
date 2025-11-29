import 'package:flutter/material.dart';

/// A reusable badge for displaying medication status (suspended, expired, etc.)
class MedicationStatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final double? fontSize;

  const MedicationStatusBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    this.fontSize,
  });

  /// Factory constructor for suspended medication badge
  factory MedicationStatusBadge.suspended({
    required String label,
  }) {
    return MedicationStatusBadge(
      icon: Icons.pause_circle_outline,
      label: label,
      backgroundColor: Colors.grey.shade200,
      borderColor: Colors.grey.shade600,
      iconColor: Colors.grey.shade600,
      textColor: Colors.grey.shade600,
    );
  }

  /// Factory constructor for expired medication badge
  factory MedicationStatusBadge.expired({
    required String label,
  }) {
    return MedicationStatusBadge(
      icon: Icons.warning,
      label: label,
      backgroundColor: Colors.red.shade100,
      borderColor: Colors.red.shade700,
      iconColor: Colors.red.shade700,
      textColor: Colors.red.shade700,
    );
  }

  /// Factory constructor for near-expiration medication badge
  factory MedicationStatusBadge.nearExpiration({
    required String label,
  }) {
    return MedicationStatusBadge(
      icon: Icons.schedule,
      label: label,
      backgroundColor: Colors.orange.shade100,
      borderColor: Colors.orange.shade700,
      iconColor: Colors.orange.shade700,
      textColor: Colors.orange.shade700,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize ?? 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
