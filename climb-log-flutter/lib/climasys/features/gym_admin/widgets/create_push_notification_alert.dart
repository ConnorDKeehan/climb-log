import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/create_push_notification_for_gym_command.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class CreatePushNotificationAlert extends StatefulWidget {
  const CreatePushNotificationAlert({super.key});

  @override
  State<CreatePushNotificationAlert> createState() => _CreatePushNotificationAlertState();
}

class _CreatePushNotificationAlertState extends State<CreatePushNotificationAlert> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  Future<void> _submit() async {
    if (titleController.text.isEmpty) {
      // Show a warning if address is not entered
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a title')));
      return;
    }

    String gymName = await getGymName(context);
    try {
      final command = CreatePushNotificationForGymCommand(
          title: titleController.text,
          body: bodyController.text,
          gymName: gymName
      );

      await createPushNotificationForGym(command);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully sent push notification')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to send push notification')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Send Push Notification"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Enter Notification Title Text"),
                  controller: titleController),
              const SizedBox(height: 20),
              TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Enter Notification Body Text"),
                  controller: bodyController),
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
