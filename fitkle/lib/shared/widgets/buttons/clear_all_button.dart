import 'package:flutter/material.dart';
import 'package:fitkle/shared/widgets/dialogs/confirm_dialog.dart';

/// Clear all button widget
///
/// A text button with red color styling for clearing all items
/// Shows a confirmation dialog before executing the clear action
class ClearAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final double fontSize;
  final String dialogTitle;
  final String dialogMessage;
  final String confirmButtonText;
  final String cancelButtonText;

  const ClearAllButton({
    super.key,
    required this.onPressed,
    this.label = 'Clear all',
    this.fontSize = 13,
    this.dialogTitle = 'Clear All',
    this.dialogMessage = 'Are you sure you want to clear all items? This action cannot be undone.',
    this.confirmButtonText = 'Clear',
    this.cancelButtonText = 'Cancel',
  });

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: dialogTitle,
      message: dialogMessage,
      confirmText: confirmButtonText,
      cancelText: cancelButtonText,
      confirmColor: Colors.red,
    );

    if (confirmed == true) {
      onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showConfirmationDialog(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: Colors.transparent,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.red,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
