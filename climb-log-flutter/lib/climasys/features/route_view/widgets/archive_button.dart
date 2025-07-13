import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/utils/confirm_action_dialog.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class ArchiveButton extends StatefulWidget {
  final int routeId;
  final VoidCallback onActionCompleted;
  const ArchiveButton({super.key, required this.routeId, required this.onActionCompleted});

  @override
  State<ArchiveButton> createState() => _ArchiveButtonState();
}

class _ArchiveButtonState extends State<ArchiveButton> {
  void handleArchiveButton() async {
    final bool? confirm = await confirmActionDialog(context);
    if (confirm != true) return;

    try {
      String gymName = await getGymName(context);
      await archiveRoute(widget.routeId, gymName);
      Navigator.pop(context); // Close the page after success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Route archived successfully.')),
      );
      widget.onActionCompleted();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error archiving route: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: handleArchiveButton,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
      child: const Text('Archive Climb'),
    );
  }
}
