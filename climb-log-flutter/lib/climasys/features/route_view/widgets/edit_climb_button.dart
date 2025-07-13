import 'package:climasys/climasys/widgets/upsert_route_dialog/upsert_route_dialog.dart';
import 'package:flutter/material.dart';

class EditClimbButton extends StatefulWidget {
  final int routeId;
  const EditClimbButton({super.key, required this.routeId});

  @override
  State<EditClimbButton> createState() => _EditClimbButtonState();
}

class _EditClimbButtonState extends State<EditClimbButton> {

  void handleButton() async {
    try {
      await showDialog<UpsertRouteDialog>(
        context: context,
        builder: (context) => UpsertRouteDialog(routeId: widget.routeId),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging climb: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: handleButton,
      icon: const Icon(Icons.edit),
    );
  }
}
