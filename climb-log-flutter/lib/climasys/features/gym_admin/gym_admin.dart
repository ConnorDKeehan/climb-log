
import 'package:climasys/climasys/features/gym_admin/widgets/create_push_notification_alert.dart';
import 'package:climasys/climasys/widgets/user_search/user_search_widget.dart';
import 'package:flutter/material.dart';

class GymAdmin extends StatefulWidget {
  const GymAdmin({super.key});

  @override
  createState() => _GymAdminState();
}

class _GymAdminState extends State<GymAdmin> {

  void openCreatePushNotificationAlert() async {
    await showDialog<CreatePushNotificationAlert>(
        context: context,
        builder: (context) => const CreatePushNotificationAlert()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gym Admin")),
      body: const Column(children: [UserSearchWidget()]),

      // A bottom bar with our button
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: openCreatePushNotificationAlert,
          child: const Text("Create Push Notification"),
        ),
      ),
    );
  }
}
