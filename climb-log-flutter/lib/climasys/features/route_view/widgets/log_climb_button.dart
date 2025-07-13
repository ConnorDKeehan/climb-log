import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/features/route_view/widgets/log_climb_dialog.dart';
import 'package:flutter/material.dart';

class LogClimbButton extends StatefulWidget {
  final int routeId;
  final VoidCallback onActionCompleted;
  const LogClimbButton({super.key, required this.routeId, required this.onActionCompleted});

  @override
  State<LogClimbButton> createState() => _LogClimbButtonState();
}

class _LogClimbButtonState extends State<LogClimbButton> {
  void handleButton() async {
    try {
      await showDialog<LogClimbDialog>(
        context: context,
        builder: (context) => LogClimbDialog(routeId: widget.routeId),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging climb: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: handleButton,
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
      child: const Text('Log Climb'),
    );
  }
}
