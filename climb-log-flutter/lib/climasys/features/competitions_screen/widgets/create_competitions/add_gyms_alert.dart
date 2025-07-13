import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:flutter/material.dart';

class AddGymsAlert extends StatefulWidget {
  final List<String> currentGymsIncluded;
  final Function(List<String>) updateSelectedGyms;
  const AddGymsAlert(
      {super.key,
      required this.currentGymsIncluded,
      required this.updateSelectedGyms});

  @override
  State<StatefulWidget> createState() => _AddGymsAlertState();
}

class _AddGymsAlertState extends State<AddGymsAlert> {
  bool _isLoading = true;
  List<String> gymsToShow = [];
  Set<String> selectedGyms = {};

  @override
  void initState() {
    super.initState();
    _initializeFacilitiesAlert();
  }

  Future<void> _initializeFacilitiesAlert() async {
    final apiWhereUserIsGymAdminResponse = await getAllGymsWhereUserIsAdmin();

    setState(() {
      gymsToShow = apiWhereUserIsGymAdminResponse;
      Set<String> currentGymsIncluded = widget.currentGymsIncluded.toSet();
      selectedGyms = currentGymsIncluded;
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    widget.updateSelectedGyms(selectedGyms.toList());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Include Gyms"),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: gymsToShow.asMap().entries.map((entry) {
                  final gymName = entry.value;
                  return ListTile(
                    title: Text(gymName),
                    trailing: Checkbox(
                      value: selectedGyms.contains(gymName),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            selectedGyms.add(gymName);
                          } else {
                            selectedGyms.remove(gymName);
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
          onPressed: selectedGyms.isEmpty ? null : _submit, // Handle submission
          child: const Text('Add'),
        ),
      ],
    );
  }
}
