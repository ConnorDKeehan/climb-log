import 'package:climasys/climasys/features/account_view/account_view_api.dart';
import 'package:climasys/climasys/features/account_view/models/edit_account_details_request.dart';
import 'package:flutter/material.dart';

class EditAccountDetailsDialog extends StatefulWidget {
  final String currentDisplayName;
  final String currentBio;
  final BuildContext context;
  final VoidCallback onEditComplete;

  const EditAccountDetailsDialog({
    super.key,
    required this.currentDisplayName,
    required this.currentBio,
    required this.context,
    required this.onEditComplete
  });

  @override
  State<EditAccountDetailsDialog> createState() => _EditAccountDetailsDialogState();
}

class _EditAccountDetailsDialogState extends State<EditAccountDetailsDialog> {
  late TextEditingController displayNameController;
  late TextEditingController bioController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    displayNameController = TextEditingController(text: widget.currentDisplayName);
    bioController = TextEditingController(text: widget.currentBio);
  }

  @override
  void dispose() {
    displayNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    final snackBarMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      isLoading = true;
    });

    final displayName = displayNameController.text;
    if(displayName.isEmpty){
      snackBarMessenger.showSnackBar(
        const SnackBar(content: Text('You must enter a display name')),
      );

      setState(() {
        isLoading = false;
      });
      return;
    }

    //Leave null if the bio is blank
    final bioText = bioController.text.isNotEmpty ? bioController.text : null;

    final request = EditAccountDetailsRequest(
        friendlyName: displayName,
        bioText: bioText
    );

    try {
      await editAccountDetails(request);
      widget.onEditComplete();
    }
    catch(e){
      snackBarMessenger.showSnackBar(const SnackBar(content: Text(
          'Sorry! Failed to update details.'
              'Please try again or raise the issue.'
      )));
    }

    setState(() {
      isLoading = false;
    });
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: isLoading ? () => {} : handleSubmit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}