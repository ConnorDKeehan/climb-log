import 'package:climasys/climasys/api/models/facility.dart';
import 'package:flutter/material.dart';
import 'add_facility_alert.dart';
import 'get_icons_from_string.dart';

class FacilitiesExpansionTile extends StatefulWidget {
  final List<Facility> facilities;
  final ThemeData theme;
  final bool isGymAdmin;
  final VoidCallback refreshGym;

  const FacilitiesExpansionTile(
      {super.key,
      required this.facilities,
      required this.theme,
      required this.isGymAdmin,
      required this.refreshGym});

  @override
  State<StatefulWidget> createState() => _FacilitiesExpansionTileState();
}

class _FacilitiesExpansionTileState extends State<FacilitiesExpansionTile> {
  List<Facility> facilitiesToShow = [];
  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    setState(() {
      facilitiesToShow = widget.facilities;
    });
  }

  Future<void> openAddFacilityAlert() async {
    await showDialog<AddFacilitiesAlert>(
      context: context,
      builder: (context) => AddFacilitiesAlert(
        facilities: widget.facilities,
        refreshGym: widget.refreshGym, // Pass the callback
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(children: [
        Icon(
          Icons.fitness_center, // This is the clock icon
          size: 24.0, // Adjust the size as needed
          color:
              widget.theme.textTheme.bodyLarge?.color, // Match the text color
        ),
        const SizedBox(
            width: 8), // Add some spacing between the icon and the text
        Text('Facilities',
            style: widget.theme.textTheme.bodyLarge,
            selectionColor: Colors.blue)
      ]),
      trailing: Row(
        mainAxisSize: MainAxisSize
            .min, // Ensures the row only takes as much space as needed
        children: [
          if (widget.isGymAdmin) // Only show edit icon for gym admins
            IconButton(
              icon: Icon(Icons.edit, color: widget.theme.primaryColor),
              onPressed: openAddFacilityAlert,
            ),
          const Icon(Icons.expand_more), // Default dropdown icon
        ],
      ),
      children: [
        if (widget.facilities.isNotEmpty)
          Card(
              elevation: 2,
              child: Column(
                children: widget.facilities.asMap().entries.map((entry) {
                  final facility = entry.value;
                  return ListTile(
                      leading: Icon(
                        getIconDataFromString(facility.iconName),
                        color: widget.theme.primaryColor,
                      ),
                      title: Text(facility.name));
                }).toList(),
              ))
        else
          Text('No facilities listed.', style: widget.theme.textTheme.bodyLarge)
      ],
    );
  }
}
