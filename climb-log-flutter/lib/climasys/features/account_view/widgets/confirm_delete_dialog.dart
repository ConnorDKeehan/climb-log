import 'package:flutter/material.dart';

Future<Map<String, String>?> confirmAccountDeletion(BuildContext context) async {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // We return a Map<String, String> on confirm and `null` if user cancels
  final result = await showDialog<Map<String, String>>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Action'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("This cannot be undone. "),
            const Text("IT WILL DELETE ALL OF YOUR DATA."),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null), // User cancels
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop({
              'username': usernameController.text,
              'password': passwordController.text,
            }), // User confirms
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );

  return result;
}