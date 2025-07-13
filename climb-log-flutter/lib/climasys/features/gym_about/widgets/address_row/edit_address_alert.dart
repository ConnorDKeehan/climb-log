import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class EditAddressAlert extends StatefulWidget {
  final String address;
  final VoidCallback refreshGym;

  const EditAddressAlert(
      {super.key, required this.address, required this.refreshGym});

  @override
  _EditAddressAlertState createState() => _EditAddressAlertState();
}

class _EditAddressAlertState extends State<EditAddressAlert> {
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (addressController.text.isEmpty) {
      // Show a warning if address is not entered
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an address')));
      return;
    }

    String gymName = await getGymName(context);
    try {
      await updateGymAddress(gymName, addressController.text);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated the address')));
      widget.refreshGym();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error setting address, not sure what happened')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Edit Address"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Enter Address"),
                  controller: addressController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(null), // Return null on cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submit, // Handle submission
            child: const Text('Submit'),
          ),
        ]);
  }
}
