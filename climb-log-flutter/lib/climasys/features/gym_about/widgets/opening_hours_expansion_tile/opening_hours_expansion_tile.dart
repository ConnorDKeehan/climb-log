import 'package:climasys/climasys/api/models/opening_hour.dart';
import 'package:climasys/climasys/features/gym_about/widgets/opening_hours_expansion_tile/edit_opening_hours_alert.dart';
import 'package:flutter/material.dart';

class OpeningHoursExpansionTile extends StatefulWidget {
  final List<OpeningHour> openingHours;
  final bool? currentlyOpen;
  final TimeOfDay? todayStartTime;
  final TimeOfDay? todayEndTime;
  final ThemeData theme;
  final bool isGymAdmin;
  final VoidCallback refreshGym;

  const OpeningHoursExpansionTile(
      {super.key,
      required this.openingHours,
      required this.currentlyOpen,
      required this.todayStartTime,
      required this.todayEndTime,
      required this.theme,
      required this.isGymAdmin,
      required this.refreshGym});

  @override
  State<StatefulWidget> createState() => _OpeningHoursExpansionTileState();
}

class _OpeningHoursExpansionTileState extends State<OpeningHoursExpansionTile> {
  String _formatTimeOfDay(TimeOfDay time) {
    final hourStr = time.hour.toString().padLeft(2, '0');
    final minuteStr = time.minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  bool isClosedAllDay(TimeOfDay startTime, TimeOfDay endTime) =>
      (startTime.hour == 0 &&
          startTime.minute == 0 &&
          endTime.hour == 0 &&
          endTime.minute == 0);

  Widget openingHoursSubTitle() {
    Text gymOpenStatus =
        const Text("Closed", style: TextStyle(color: Colors.red));

    if (widget.currentlyOpen == true) {
      gymOpenStatus = const Text("Open", style: TextStyle(color: Colors.green));
    }

    return Row(children: [
      const SizedBox(width: 32),
      gymOpenStatus,
      const SizedBox(width: 16),
      if (!isClosedAllDay(widget.todayStartTime!, widget.todayEndTime!))
        Text(
            "${_formatTimeOfDay(widget.todayStartTime!)}-${_formatTimeOfDay(widget.todayEndTime!)}")
    ]);
  }

  Future<void> _openEditOpeningHoursDialog() async {
    await showDialog<EditOpeningHoursAlert>(
        context: context,
        builder: (context) => EditOpeningHoursAlert(
              initialOpeningHours: widget.openingHours,
              refreshGym: widget.refreshGym,
            ));
  }

  Widget displayWeekDayHoursSubtitle(TimeOfDay startTime, TimeOfDay endTime) {
    if (isClosedAllDay(startTime, endTime)) {
      return const Text('Not Open');
    }

    return Text(
        '${_formatTimeOfDay(startTime)} - ${_formatTimeOfDay(endTime)}');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Row(children: [
          Icon(
            Icons.access_time, // This is the clock icon
            size: 24.0, // Adjust the size as needed
            color:
                widget.theme.textTheme.bodyLarge?.color, // Match the text color
          ),
          const SizedBox(
              width: 8), // Add some spacing between the icon and the text
          Text('Opening Hours',
              style: widget.theme.textTheme.bodyLarge,
              selectionColor: Colors.blue)
        ]),
        subtitle: openingHoursSubTitle(),
        trailing: Row(
          mainAxisSize: MainAxisSize
              .min, // Ensures the row only takes as much space as needed
          children: [
            if (widget.isGymAdmin) // Only show edit icon for gym admins
              IconButton(
                  icon: Icon(Icons.edit_calendar,
                      color: widget.theme.primaryColor),
                  onPressed: _openEditOpeningHoursDialog),
            const Icon(Icons.expand_more), // Default dropdown icon
          ],
        ),
        children: [
          if (widget.openingHours.isEmpty)
            Text('No opening hours listed.',
                style: widget.theme.textTheme.bodyLarge)
          else
            Card(
              elevation: 2,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.openingHours.length,
                itemBuilder: (context, index) {
                  final hour = widget.openingHours[index];
                  return ListTile(
                    leading: Icon(
                      Icons.calendar_month_sharp,
                      color: widget.theme.primaryColor,
                    ),
                    title: Text(hour.weekDay),
                    subtitle: displayWeekDayHoursSubtitle(
                        hour.startTime, hour.endTime),
                  );
                },
              ),
            )
        ]);
  }
}
