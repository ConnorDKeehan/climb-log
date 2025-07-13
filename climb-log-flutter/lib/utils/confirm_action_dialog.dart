import 'package:flutter/material.dart';

Future<bool?> confirmActionDialog(BuildContext context,
    {String negativeText = 'Cancel', String positiveText = 'Confirm'}) async {

  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text("This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // User cancels
            child: Text(negativeText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // User confirms
            child: Text(positiveText),
          ),
        ],
      );
    },
  );

  return confirm;
}