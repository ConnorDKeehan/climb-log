import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/opening_hour.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class EditOpeningHoursAlert extends StatefulWidget {
  final List<OpeningHour> initialOpeningHours;
  final VoidCallback refreshGym;

  const EditOpeningHoursAlert(
      {super.key, required this.initialOpeningHours, required this.refreshGym});

  @override
  State<StatefulWidget> createState() => _EditOpeningHoursAlertState();
}

class _EditOpeningHoursAlertState extends State<EditOpeningHoursAlert> {
  late List<OpeningHour> _selectedOpeningHours;

  @override
  void initState() {
    super.initState();
    // Make a copy of the initial opening hours so we can edit them safely
    _selectedOpeningHours = widget.initialOpeningHours
        .map((h) => OpeningHour(
              dayNumber: h.dayNumber,
              weekDay: h.weekDay,
              startTime: h.startTime,
              endTime: h.endTime,
            ))
        .toList();
  }

  Future<void> _pickTime(int index, bool isStartTime) async {
    final initialTime = isStartTime
        ? _selectedOpeningHours[index].startTime
        : _selectedOpeningHours[index].endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _selectedOpeningHours[index] = OpeningHour(
            dayNumber: _selectedOpeningHours[index].dayNumber,
            weekDay: _selectedOpeningHours[index].weekDay,
            startTime: picked,
            endTime: _selectedOpeningHours[index].endTime,
          );
        } else {
          _selectedOpeningHours[index] = OpeningHour(
            dayNumber: _selectedOpeningHours[index].dayNumber,
            weekDay: _selectedOpeningHours[index].weekDay,
            startTime: _selectedOpeningHours[index].startTime,
            endTime: picked,
          );
        }
      });
    }
  }

  Future<void> _submit() async {
    final gymName = await getGymName(context);

    try {
      await editOpeningHours(gymName, _selectedOpeningHours);
      widget.refreshGym();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated opening hours')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed updated opening hours')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Default Opening Hours"),
      content: SizedBox(
        width: double.maxFinite,
        height: 400, // Adjust height if needed
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _selectedOpeningHours.length,
          itemBuilder: (context, index) {
            final openingHour = _selectedOpeningHours[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Day of the week text
                  Expanded(
                    flex: 2,
                    child: Text(
                      openingHour.weekDay,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Start time field
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () => _pickTime(index, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatTimeOfDay(openingHour.startTime),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // End time field
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () => _pickTime(index, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatTimeOfDay(openingHour.endTime),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss without saving
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Save"),
        ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    // Format TimeOfDay to hh:mm, can be adjusted as needed
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    final minuteStr = time.minute.toString().padLeft(2, '0');
    return "$hour:$minuteStr $period";
  }
}
