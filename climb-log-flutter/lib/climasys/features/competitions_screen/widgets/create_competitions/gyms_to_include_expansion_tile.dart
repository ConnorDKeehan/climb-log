import 'package:climasys/climasys/features/competitions_screen/widgets/create_competitions/add_gyms_alert.dart';
import 'package:flutter/material.dart';

class GymsToIncludeExpansionTile extends StatefulWidget {
  final List<String> gyms;
  final Function(List<String>) updateSelectedGyms;

  const GymsToIncludeExpansionTile(
      {super.key, required this.gyms, required this.updateSelectedGyms});

  @override
  State<StatefulWidget> createState() => _GymsToIncludeExpansionTileState();
}

class _GymsToIncludeExpansionTileState
    extends State<GymsToIncludeExpansionTile> {
  List<String> gymsToShow = [];
  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    setState(() {
      gymsToShow = widget.gyms;
    });
  }

  Future<void> openAddFacilityAlert() async {
    await showDialog<AddGymsAlert>(
      context: context,
      builder: (context) => AddGymsAlert(
        currentGymsIncluded: widget.gyms,
        updateSelectedGyms: widget.updateSelectedGyms,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Row(children: [
        Icon(
          Icons.fitness_center, // This is the clock icon
          size: 24.0, // Adjust the size as needed
          color: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.color, // Match the text color
        ),
        const SizedBox(
            width: 8), // Add some spacing between the icon and the text
        Text('Gyms To Include',
            style: Theme.of(context).textTheme.bodyLarge,
            selectionColor: Colors.blue)
      ]),
      trailing: Row(
        mainAxisSize: MainAxisSize
            .min, // Ensures the row only takes as much space as needed
        children: [
          // Only show edit icon for gym admins
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
            onPressed: openAddFacilityAlert,
          ),
          const Icon(Icons.expand_more), // Default dropdown icon
        ],
      ),
      children: [
        if (widget.gyms.isNotEmpty)
          Card(
              elevation: 2,
              child: Column(
                children: widget.gyms.asMap().entries.map((entry) {
                  final gymName = entry.value;
                  return ListTile(title: Text(gymName));
                }).toList(),
              ))
        else
          Text('No facilities listed.',
              style: Theme.of(context).textTheme.bodyLarge)
      ],
    );
  }
}
