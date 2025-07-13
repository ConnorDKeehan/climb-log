import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/facility.dart';
import 'package:climasys/climasys/features/gym_about/widgets/facilities_expansion_tile/get_icons_from_string.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class AddFacilitiesAlert extends StatefulWidget {
  final List<Facility> facilities;
  final VoidCallback refreshGym;
  const AddFacilitiesAlert(
      {super.key, required this.facilities, required this.refreshGym});

  @override
  State<StatefulWidget> createState() => _AddFacilitiesAlertState();
}

class _AddFacilitiesAlertState extends State<AddFacilitiesAlert> {
  bool _isLoading = true;
  List<Facility> facilitiesToShow = [];
  Set<int> selectedFacilities = {};

  @override
  void initState() {
    super.initState();
    _initializeFacilitiesAlert();
  }

  Future<void> _initializeFacilitiesAlert() async {
    final apiFacilitiesResponse = await getAllFacilities();

    setState(() {
      facilitiesToShow = apiFacilitiesResponse;
      Set<int> existingFacilities =
          widget.facilities.map((facility) => facility.id).toSet();
      selectedFacilities = existingFacilities;
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    String gymName = await getGymName(context);

    try {
      await editGymFacilities(gymName, selectedFacilities.toList());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated the facilities')));
      widget.refreshGym();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error setting the facilities')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Facilities"),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: facilitiesToShow.asMap().entries.map((entry) {
                  final facility = entry.value;
                  return ListTile(
                    leading: Icon(getIconDataFromString(facility.iconName)),
                    title: Text(facility.name),
                    trailing: Checkbox(
                      value: selectedFacilities.contains(facility.id),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            selectedFacilities.add(facility.id);
                          } else {
                            selectedFacilities.remove(facility.id);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(null), // Return null on cancel
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              selectedFacilities.isEmpty ? null : _submit, // Handle submission
          child: const Text('Edit Facilities'),
        ),
      ],
    );
  }
}
