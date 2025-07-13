import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:flutter/material.dart';

class UnlogClimbButton extends StatefulWidget {
  final int routeId;
  final VoidCallback onActionCompleted;
  const UnlogClimbButton({super.key, required this.routeId, required this.onActionCompleted});

  @override
  State<UnlogClimbButton> createState() => _UnlogClimbButtonState();
}

class _UnlogClimbButtonState extends State<UnlogClimbButton> {
  void handleUnlogButton() async {
    try {
      await unlogClimb(widget.routeId);
      Navigator.pop(context); // Close the page after success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Climb unlogged successfully.')),
      );
      widget.onActionCompleted();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error unlogging climb: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: handleUnlogButton,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: colorScheme.onPrimary,
          ),
          const SizedBox(width: 8),
          Text(
            'Sent',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
