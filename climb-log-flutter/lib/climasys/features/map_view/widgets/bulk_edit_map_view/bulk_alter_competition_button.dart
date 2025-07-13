import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/features/competitions_screen/models/get_competition_by_gym_query_response.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/models/bulk_alter_competition_command.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BulkAlterCompetitionButton extends StatefulWidget {
  final List<int> routeIds;
  const BulkAlterCompetitionButton({super.key, required this.routeIds});

  @override
  State<BulkAlterCompetitionButton> createState() => _BulkAlterCompetitionButtonState();
}

class _BulkAlterCompetitionButtonState extends State<BulkAlterCompetitionButton> {
  int? selectedCompetitionId;
  List<GetCompetitionByGymQueryResponse> competitions = [];
  String gymName = "";
  bool isLoading = true;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    try {
      gymName = await getGymName(context);
      competitions = await getCompetitionsByGym(gymName);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error fetching competitions. Please try again later.')),
      );
    }
  }

  void _submit() async {
    if(selectedCompetitionId == null){
      return;
    }

    final command = BulkAlterCompetitionCommand(routeIds: widget.routeIds, competitionId: selectedCompetitionId!);
    try {
      await bulkAlterCompetition(command, gymName);
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update routes")));
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Updated Routes!")));
    Navigator.of(context).pop();
  }

  Widget _editRoutesDialog() {
    return AlertDialog(
      title: const Text('Bulk Edit Routes'),
      content: isLoading
          ? const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (competitions.isNotEmpty)
              Column(children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Competitions',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCompetitionId,
                  items: competitions.map((GetCompetitionByGymQueryResponse competition) {
                    return DropdownMenuItem<int>(
                      value: competition.competitionId,
                      child: Text(competition.competitionName),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCompetitionId = newValue;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a grade' : null,
                ),
                const SizedBox(height: 16)
              ])
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => _editRoutesDialog(),
      ),
      icon: const Icon(Icons.edit),
    );
  }
}
