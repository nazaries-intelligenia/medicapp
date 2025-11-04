import 'package:flutter/material.dart';

/// A generic reusable widget for displaying two action buttons in a vertical layout.
///
/// This widget displays a primary action button (FilledButton) and an optional
/// secondary action button (OutlinedButton) in a column layout with consistent
/// spacing and styling.
///
/// The primary button can display a loading state with a progress indicator,
/// and the secondary button can be completely omitted if not needed.
///
/// Example usage for save/cancel buttons:
/// ```dart
/// ActionButtons(
///   primaryLabel: 'Save',
///   primaryIcon: Icons.check,
///   onPrimaryPressed: _handleSave,
///   secondaryLabel: 'Cancel',
///   secondaryIcon: Icons.cancel,
///   onSecondaryPressed: _handleCancel,
///   isLoading: _isSaving,
///   loadingLabel: 'Saving...',
/// )
/// ```
///
/// Example usage for continue/back buttons:
/// ```dart
/// ActionButtons(
///   primaryLabel: 'Continue',
///   primaryIcon: Icons.arrow_forward,
///   onPrimaryPressed: _handleContinue,
///   secondaryLabel: 'Back',
///   secondaryIcon: Icons.arrow_back,
///   onSecondaryPressed: _handleBack,
/// )
/// ```
class ActionButtons extends StatelessWidget {
  /// The label text for the primary button
  final String primaryLabel;

  /// The icon for the primary button
  final IconData primaryIcon;

  /// Callback function for the primary button press
  final VoidCallback onPrimaryPressed;

  /// The label text for the secondary button (optional)
  final String? secondaryLabel;

  /// The icon for the secondary button (optional)
  final IconData? secondaryIcon;

  /// Callback function for the secondary button press (optional)
  final VoidCallback? onSecondaryPressed;

  /// Whether the primary button is in a loading state
  final bool isLoading;

  /// The label to display when loading (optional)
  final String? loadingLabel;

  /// Optional background color for the primary button
  final Color? primaryButtonColor;

  const ActionButtons({
    super.key,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimaryPressed,
    this.secondaryLabel,
    this.secondaryIcon,
    this.onSecondaryPressed,
    this.isLoading = false,
    this.loadingLabel,
    this.primaryButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: isLoading ? null : onPrimaryPressed,
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(primaryIcon),
          label: Text(isLoading && loadingLabel != null ? loadingLabel! : primaryLabel),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: primaryButtonColor,
          ),
        ),
        if (secondaryLabel != null && secondaryIcon != null && onSecondaryPressed != null) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: isLoading ? null : onSecondaryPressed,
            icon: Icon(secondaryIcon),
            label: Text(secondaryLabel!),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ],
    );
  }
}
