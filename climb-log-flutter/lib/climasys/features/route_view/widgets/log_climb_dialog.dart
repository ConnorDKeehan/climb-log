import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/log_climb_request.dart';
import 'package:climasys/climasys/features/map_view/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogClimbDialog extends StatefulWidget {
  final int routeId;
  const LogClimbDialog({Key? key, required this.routeId}) : super(key: key);

  @override
  State<LogClimbDialog> createState() => _LogClimbDialogState();
}

class _LogClimbDialogState extends State<LogClimbDialog> {
  final Map<int, String> difficultyForGrade = {
    1: "Easy",
    2: "Very Easy",
    3: "Average",
    4: "Hard",
    5: "Very Hard",
  };

  int? selectedGrade;
  int? attemptCount;
  String notes = "";

  Future<void> handleLogButton() async {
    try {
      final logClimbRequest = LogClimbRequest(
        routeId: widget.routeId,
        difficultyForGradeId: selectedGrade,
        attemptCount: attemptCount,
        notes: notes.isEmpty ? null : notes,
      );

      print(logClimbRequest);

      await logClimb(logClimbRequest);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MapView()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging climb: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Log Climb"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Difficulty
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Difficulty',
                border: OutlineInputBorder(),
              ),
              value: selectedGrade,
              items: difficultyForGrade.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGrade = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Attempt Count
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Attempt Count",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  attemptCount = int.tryParse(value);
                });
              },
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  notes = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: handleLogButton,
          child: const Text("Save"),
        ),
      ],
    );
  }
}
